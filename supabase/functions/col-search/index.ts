// ============================================================================
// BioSpotter · Supabase Edge Function: col-search
// ----------------------------------------------------------------------------
// Fajnévre keres a GBIF Species API-val — tudományos ÉS népies nevekre is,
// mind a hét támogatott nyelven (hun, eng, deu, fra, spa, ita, pol).
//
// API: https://api.gbif.org/v1/species/search
//   - Nem kell API kulcs / regisztráció
//   - A válasz tartalmazza a vernacularNames tömböt (nyelvenként)
//
// Telepítés:
//   supabase functions deploy col-search --no-verify-jwt
// ============================================================================

import { serve } from "https://deno.land/std@0.208.0/http/server.ts";

const GBIF_API = "https://api.gbif.org/v1/species/search";

// A BioSpotter által támogatott nyelvek (ISO 639-3, ahogy a GBIF használja)
const SUPPORTED_LANGS = ["hun", "eng", "deu", "fra", "spa", "ita", "pol"];

// Csak az érdekes országok (állat, növény, gomba) — a vírusokat kihagyjuk
const INTERESTING_KINGDOMS = new Set([
  "Animalia",
  "Plantae",
  "Fungi",
  "Chromista",
  "Protozoa",
]);

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

interface GbifVernacular {
  vernacularName?: string;
  language?: string;
  preferred?: boolean;
}

interface GbifResult {
  key?: number;
  nubKey?: number;
  speciesKey?: number;
  scientificName?: string;
  canonicalName?: string;
  rank?: string;
  taxonomicStatus?: string;
  kingdom?: string;
  phylum?: string;
  class?: string;
  order?: string;
  family?: string;
  genus?: string;
  nameType?: string;
  vernacularNames?: GbifVernacular[];
}

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

  try {
    const body = await req.json() as {
      query?: string;
      language?: string;
      limit?: number;
    };

    const query = (body.query ?? "").trim();
    const language = (body.language ?? "eng").toLowerCase();
    const limit = Math.min(Math.max(body.limit ?? 20, 1), 50);

    if (query.length < 2) {
      return new Response(
        JSON.stringify({ ok: true, matches: [] }),
        { headers: { ...CORS, "Content-Type": "application/json" } },
      );
    }

    // A GBIF kereső végpontja.
    // A "q" a keresett szöveg; a rank a főbb taxonómiai szintekre szűkít.
    const url = new URL(GBIF_API);
    url.searchParams.set("q", query);
    url.searchParams.set("limit", String(limit));
    url.searchParams.set("rank", "SPECIES");
    url.searchParams.set("status", "ACCEPTED");

    const res = await fetch(url.toString(), {
      headers: { Accept: "application/json" },
    });

    if (!res.ok) {
      const text = await res.text();
      return new Response(
        JSON.stringify({
          error: "A GBIF API hibát adott.",
          status: res.status,
          detail: text.slice(0, 300),
        }),
        {
          status: 502,
          headers: { ...CORS, "Content-Type": "application/json" },
        },
      );
    }

    const data = await res.json() as { results?: GbifResult[] };

    // Csak az érdekes országok (állat, növény, gomba) — a vírusokat kihagyjuk
    const results = (data.results ?? []).filter((r) => {
      const k = r.kingdom ?? "";
      // Ha nincs kingdom vagy ismeretlen, megtartjuk (biztonsági tartalék)
      if (!k) return true;
      return INTERESTING_KINGDOMS.has(k);
    });

    // Egyszerűsített, a BioSpotter számára hasznos alak
    const matches = results.map((r) => {
      const vernaculars = r.vernacularNames ?? [];

      // A kért nyelvet részesítjük előnyben
      const matchForLang = vernaculars.find(
        (v) => (v.language ?? "").toLowerCase() === language,
      );
      const anyVernacular = vernaculars.find((v) => !v.preferred) ??
        vernaculars[0];

      // Az összes támogatott nyelvű népies név, nyelvenként egy (a preferred)
      const byLang: Record<string, string> = {};
      for (const v of vernaculars) {
        const lang = (v.language ?? "").toLowerCase();
        if (!SUPPORTED_LANGS.includes(lang)) continue;
        // A preferred nevet részesítjük előnyben
        if (!byLang[lang] || v.preferred) {
          byLang[lang] = v.vernacularName ?? "";
        }
      }

      return {
        // A GBIF azonosító (ezt mentjük a species táblába)
        gbif_key: r.nubKey ?? r.speciesKey ?? r.key ?? null,
        scientific_name: r.canonicalName ?? r.scientificName ?? null,
        authorship: r.scientificName ?? null,
        rank: r.rank ?? null,
        status: r.taxonomicStatus ?? null,
        kingdom: r.kingdom ?? null,
        family: r.family ?? null,
        genus: r.genus ?? null,
        // A kért nyelven, vagy ha nincs, egy elérhető népies név
        common_name: matchForLang?.vernacularName ??
          anyVernacular?.vernacularName ?? null,
        common_name_lang: matchForLang?.language ??
          anyVernacular?.language ?? null,
        // Az összes elérhető népies név nyelvenként (hun, eng, deu, fra, spa, ita, pol)
        vernacular_names: byLang,
      };
    });

    return new Response(
      JSON.stringify({ ok: true, matches }),
      { headers: { ...CORS, "Content-Type": "application/json" } },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: "Váratlan hiba", detail: String(e) }),
      { status: 500, headers: { ...CORS, "Content-Type": "application/json" } },
    );
  }
});
