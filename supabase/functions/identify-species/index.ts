import { serve } from "https://deno.land/std@0.208.0/http/server.ts";

const INAT_API = "https://api.inaturalist.org/v1/computervision/score_image";
const INAT_TOKEN = Deno.env.get("INAT_TOKEN") ?? "";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS });
  }

  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({ error: "Only POST is supported" }),
      { status: 405, headers: { ...CORS, "Content-Type": "application/json" } },
    );
  }

  if (!INAT_TOKEN) {
    return new Response(
      JSON.stringify({
        error: "A szerveroldali iNaturalist token nincs beállítva.",
      }),
      { status: 500, headers: { ...CORS, "Content-Type": "application/json" } },
    );
  }

  try {
    const form = await req.formData();
    const image = form.get("image");

    if (!(image instanceof File)) {
      return new Response(
        JSON.stringify({ error: "Hiányzó vagy érvénytelen 'image' mező." }),
        { status: 400, headers: { ...CORS, "Content-Type": "application/json" } },
      );
    }

    const outForm = new FormData();
    outForm.append("image", image, image.name || "photo.jpg");

    const inatRes = await fetch(INAT_API, {
      method: "POST",
      headers: { Authorization: `Bearer ${INAT_TOKEN}` },
      body: outForm,
    });

    if (!inatRes.ok) {
      const text = await inatRes.text();
      return new Response(
        JSON.stringify({
          error: "Az iNaturalist API hibát adott.",
          status: inatRes.status,
          detail: text.slice(0, 300),
        }),
        {
          status: 502,
          headers: { ...CORS, "Content-Type": "application/json" },
        },
      );
    }

    const data = await inatRes.json() as { results?: unknown[] };
    const results = (data.results ?? []) as Array<Record<string, unknown>>;

    const suggestions = results.slice(0, 5).map((r) => {
      const taxon = (r.taxon ?? {}) as Record<string, unknown>;
      const raw = (r.combined_score ?? r.vision_score ?? 0) as number;
      return {
        taxon_id: taxon.id ?? null,
        scientific_name: taxon.name ?? null,
        common_name: taxon.preferred_common_name ?? null,
        rank: taxon.rank ?? null,
        iconic_taxon: taxon.iconic_taxon_name ?? null,
        // A combined_score 0-1 közötti valószínűség — százalékra váltjuk.
        score: raw > 1 ? raw : raw * 100,
      };
    });

    return new Response(
      JSON.stringify({ ok: true, suggestions }),
      { headers: { ...CORS, "Content-Type": "application/json" } },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: "Váratlan hiba", detail: String(e) }),
      { status: 500, headers: { ...CORS, "Content-Type": "application/json" } },
    );
  }
});
