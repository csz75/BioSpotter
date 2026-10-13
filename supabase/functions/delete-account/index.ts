// Fiók anonimizálása — nem törlés, hanem átírás.
//
//  • a neved és az e-mail címed eltűnik, véletlen azonosítóra cserélődik
//  • a régi e-mail FELSZABADUL → ugyanazzal a címmel újra lehet regisztrálni
//  • a jelszó véletlenre cserélődik → a belépés véglegesen megszűnik
//  • a megfigyelések és a pénzügyi napló MARAD, csak a személy tűnik el
//  • az előfizetés nem törlődik, csak free-re vált — a Stripe-nyom megmarad
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

/// Véletlen, soha ki nem adott e-mail — a valódi cím felszabadul.
function anonymousEmail(): string {
  const hex = crypto.randomUUID().replace(/-/g, '');
  return `anon-${hex}@anonim.anonim`;
}

/// Véletlen jelszó — a belépés véglegesen megszűnik.
function anonymousPassword(): string {
  return crypto.randomUUID() + crypto.randomUUID();
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: CORS });
  }

  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'Nincs bejelentkezve' }),
        { status: 401, headers: { ...CORS, 'Content-Type': 'application/json' } },
      );
    }

    // 1. Ki a hívó? — a felhasználó saját tokenjével ellenőrizzük.
    const userClient = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      { global: { headers: { Authorization: authHeader } } },
    );

    const { data: { user }, error: userError } = await userClient.auth.getUser();
    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: 'Érvénytelen munkamenet' }),
        { status: 401, headers: { ...CORS, 'Content-Type': 'application/json' } },
      );
    }

    // 2. Admin kliens — ez tudja átírni az auth.users sort.
    const admin = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
      { auth: { autoRefreshToken: false, persistSession: false } },
    );

    const anonEmail = anonymousEmail();
    const now = new Date().toISOString();

    // 3. A public.users átírása.
    //    display_name NOT NULL → véletlen azonosító kerül bele.
    //    avatar_url, bio, institution → töröljük.
    const { error: profileError } = await admin
      .from('users')
      .update({
        email: anonEmail,
        display_name: `Anonim-${crypto.randomUUID().slice(0, 8)}`,
        avatar_url: null,
        bio: null,
        institution: null,
        updated_at: now,
      })
      .eq('id', user.id);

    if (profileError) {
      return new Response(
        JSON.stringify({ error: `Profil: ${profileError.message}` }),
        { status: 500, headers: { ...CORS, 'Content-Type': 'application/json' } },
      );
    }

    // 3b. Az előfizetés lezárása — NEM töröljük, csak free-re tesszük.
    //
    //     A stripe_customer_id és a stripe_subscription_id MEGMARAD:
    //     ez a pénzügyi nyom, ami később a Stripe-nál az auditáláshoz kell.
    //     Ha valódi, aktív Stripe-előfizetés lenne, itt kellene a
    //     Stripe-nál is lemondani (külön API-hívás) — de a sor marad.
    const { error: subError } = await admin
      .from('subscriptions')
      .update({
        plan: 'free',
        auto_renew: false,
        valid_until: now,
        updated_at: now,
      })
      .eq('user_id', user.id);

    if (subError) {
      return new Response(
        JSON.stringify({ error: `Előfizetés: ${subError.message}` }),
        { status: 500, headers: { ...CORS, 'Content-Type': 'application/json' } },
      );
    }

    // 4. Az auth.users átírása — a régi e-mail itt szabadul fel.
    const { error: authError } = await admin.auth.admin.updateUserById(
      user.id,
      {
        email: anonEmail,
        email_confirm: true,
        password: anonymousPassword(),
        user_metadata: { anonymized: true },
      },
    );

    if (authError) {
      return new Response(
        JSON.stringify({ error: `Auth: ${authError.message}` }),
        { status: 500, headers: { ...CORS, 'Content-Type': 'application/json' } },
      );
    }

    return new Response(
      JSON.stringify({ ok: true }),
      { headers: { ...CORS, 'Content-Type': 'application/json' } },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: `$e` }),
      { status: 500, headers: { ...CORS, 'Content-Type': 'application/json' } },
    );
  }
});
