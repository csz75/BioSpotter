import 'legal_texts.dart';

/// Magyar jogi szövegek — ez az irányadó változat.
const LegalTexts legalTextsHu = LegalTexts(
  privacy: _privacy,
  terms: _terms,
  deletion: _deletion,
);

const _privacy = <(String, List<String>)>[
  ('1. Az adatkezelő', [
    'Név: Therma Kft.',
    'Székhely: 1098 Budapest, Friss utca 3.',
    'E-mail: szabolcs.csoke@thermakft.hu',
  ]),
  ('2. Milyen adatokat kezelünk', [
    'A fiók létrehozásakor: e-mail-cím, megjelenített név, profilkép (opcionális).',
    'A megfigyelések rögzítésekor: a megfigyelt faj neve, a megfigyelés helye '
        '(GPS-koordináta), az időpont, és a készített fénykép.',
    'Előfizetés esetén: az előfizetés típusa és érvényessége, valamint a fizetési '
        'szolgáltatónál (Stripe) generált azonosítók.',
    'Technikai adatok: az alkalmazás használatához szükséges naplóadatok.',
  ]),
  ('3. Miért kezeljük ezeket (cél és jogalap)', [
    'A szolgáltatás működtetése (fiók, bejelentkezés) — a szerződés teljesítése.',
    'A megfigyelések tárolása és megjelenítése — a szerződés teljesítése.',
    'A fajazonosítás (iNaturalist, GBIF) — a szerződés teljesítése.',
    'Közösségi megfigyelések megjelenítése (prémium) — az érintett hozzájárulása.',
    'Előfizetés kezelése, számlázás — szerződés és jogszabályi kötelezettség.',
    'Visszaélések megelőzése — jogos érdek.',
  ]),
  ('4. Kivel osztjuk meg az adatokat', [
    'iNaturalist — a fénykép elküldése a fajazonosításhoz.',
    'GBIF / Catalogue of Life — a fajnevek lekérdezése.',
    'Supabase — az adatok tárolása (adatfeldolgozó).',
    'Stripe — a fizetések kezelése (ha előfizetsz).',
    'Ezek adatfeldolgozók, nem használják az adataidat saját célra. Az adatokat '
        'harmadik országnak nem adjuk el.',
  ]),
  ('5. A helyadatokról', [
    'A megfigyelés helye érzékeny adat. Ezért a megfigyelés helye csak akkor '
        'látszik másoknak, ha a közösségi nézetet használod (prémium), és a '
        'megfigyelésed megjelenik benne.',
    'A helyadatot nem használjuk reklámhoz vagy követéshez.',
  ]),
  ('6. A fényképekről', [
    'Amit lefotózol, azt te teszed közzé. Kérjük, figyelj rá, hogy a képen ne '
        'legyen más személy arca, vagy más tulajdonában lévő ingatlan vagy jármű '
        'azonosítója (pl. rendszám).',
  ]),
  ('7. Meddig tároljuk az adatokat', [
    'Fiókadatok: a fiók törléséig.',
    'Megfigyelések: anonim formában a fiók törlése után is megmaradhatnak (8. pont).',
    'Számlázási adatok: a számviteli jogszabályok szerint, 8 évig.',
  ]),
  ('8. A fiókod törlése', [
    'A fiókodat bármikor törölheted az alkalmazásból '
        '(Beállítások → Fiók törlése).',
    'A törlés azt jelenti, hogy a neved és e-mail-címed törlődik, és egy véletlen '
        'azonosítóra cserélődik. Ezzel a címmel később újra regisztrálhatsz.',
    'A megfigyeléseid anonim formában megmaradnak — a faj, a hely és a dátum '
        'bennmarad, de a személyedhez többé nem köthető.',
    'Ha azt szeretnéd, hogy a megfigyeléseid is teljesen eltűnjenek, a fiók '
        'törlése előtt töröld őket kézzel a megfigyeléseid listájából.',
    'A számlázási adatokat jogszabályi kötelezettség miatt a törlés után is '
        'megőrizzük.',
  ]),
  ('9. A jogaid', [
    'Hozzáférés — kérhetsz másolatot az adataidról.',
    'Helyesbítés — javíttathatod a pontatlan adatokat.',
    'Törlés — az appból, egy gombbal (8. pont).',
    'Tiltakozás — tiltakozhatsz a jogos érdeken alapuló kezelés ellen.',
    'Panasz — a NAIH-hoz fordulhatsz (Nemzeti Adatvédelmi és Információszabadság '
        'Hatóság, 1055 Budapest, Falk Miksa utca 9-11., naih.hu).',
    'Kéréseidet a szabolcs.csoke@thermakft.hu címre küldheted. 30 napon belül '
        'válaszolunk.',
  ]),
  ('10. Gyermekek', [
    'A szolgáltatás 16 éven aluliak számára szülői hozzájárulással használható. '
        'Ha tudomásunkra jut, hogy 16 év alatti adatot hozzájárulás nélkül '
        'kezeltünk, azt töröljük.',
  ]),
  ('11. A tájékoztató módosítása', [
    'A tájékoztatót módosíthatjuk. A lényeges változásról az alkalmazásban '
        'értesítünk.',
  ]),
];

const _terms = <(String, List<String>)>[
  ('1. A szolgáltatás', [
    'A BioSpotter (üzemeltető: Therma Kft., 1098 Budapest, Friss utca 3.) egy '
        'citizen science alkalmazás, amellyel növényeket, állatokat és gombákat '
        'lehet megfigyelni, azonosítani és rögzíteni.',
  ]),
  ('2. A fiók', [
    'A regisztrációhoz valós e-mail-cím kell.',
    'A fiókodért te felelsz – őrizd a jelszavadat.',
    '16 éven aluliak szülői hozzájárulással regisztrálhatnak.',
  ]),
  ('3. Amit tenned kell', [
    'Csak valós megfigyelést rögzíts.',
    'Ne tölts fel más jogait sértő tartalmat.',
    'Ne fotózz embereket az engedélyük nélkül.',
    'Ne próbáld megkárosítani a szolgáltatást (túlterhelés, automatizált '
        'adatgyűjtés).',
  ]),
  ('4. Amit nem garantálunk', [
    'A fajazonosítás automatikus (iNaturalist, GBIF) – lehet hibás. A végső '
        'azonosításért a felhasználó felel.',
    'A szolgáltatás folyamatos elérhetőségét nem garantáljuk.',
    'Az adatbázisban tárolt tudományos adatok felhasználásáért felelősséget '
        'nem vállalunk.',
  ]),
  ('5. A tartalmaid', [
    'A feltöltött megfigyeléseid a tieid maradnak.',
    'Azzal, hogy feltöltöd, engedélyt adsz arra, hogy a BioSpotter azokat '
        'megjelenítse (pl. a közösségi nézetben), és anonim formában tudományos '
        'célra felhasználja.',
    'Az engedély a fiók törlése után is megmarad az anonim adatokra.',
  ]),
  ('6. Előfizetés', [
    'Egyes funkciók (közösségi megfigyelések) prémium előfizetéssel érhetők el.',
    'Az előfizetés automatikusan megújul, amíg le nem mondod.',
    'A lemondás az appból vagy az áruházból (App Store / Google Play) lehetséges.',
  ]),
  ('7. A fiók megszüntetése', [
    'A fiókodat bármikor törölheted (Beállítások → Fiók törlése).',
    'Súlyos visszaélés esetén a fiókot felfüggeszthetjük vagy törölhetjük.',
  ]),
  ('8. Felelősség', [
    'A szolgáltatást „ahogy van” nyújtjuk. A Therma Kft. nem felel a szolgáltatás '
        'használatából eredő közvetett károkért.',
  ]),
  ('9. Irányadó jog', [
    'A feltételekre a magyar jog irányadó. Jogvita esetén a magyar bíróságok '
        'illetékesek.',
  ]),
  ('10. Kapcsolat', [
    'szabolcs.csoke@thermakft.hu',
  ]),
];

const _deletion = <(String, List<String>)>[
  ('Hogyan törölheted a fiókodat', [
    'Nyisd meg a Beállításokat.',
    'Görgess az aljára, és válaszd a Fiók törlése pontot.',
    'Erősítsd meg a törlést.',
  ]),
  ('Mi történik a törlés után', [
    'E-mail-cím: törlődik, és egy véletlen azonosítóra cserélődik.',
    'Megjelenített név, profilkép, bemutatkozás: törlődik.',
    'A fiókba való belépés: megszűnik (a jelszó érvénytelenítve).',
    'A korábbi e-mail-címed felszabadul – ugyanazzal a címmel újra regisztrálhatsz.',
    'A megfigyeléseid anonim formában megmaradnak (faj, hely, dátum, fotó).',
    'Az előfizetésed ingyenes csomagra vált, és nem újul meg.',
    'A számlázási adatok jogszabályi kötelezettség miatt megmaradnak (8 év).',
  ]),
  ('Ha mindent törölni akarsz', [
    'Ha azt szeretnéd, hogy a megfigyeléseid is eltűnjenek, tedd ezt a fiók '
        'törlése ELŐTT: nyisd meg a Megfigyeléseim listát, nyisd meg az egyes '
        'megfigyeléseket, és töröld őket egyenként.',
    'Ezután töröld a fiókodat – így semmi nem marad vissza.',
  ]),
  ('Miért maradnak meg az anonim adatok', [
    'A BioSpotter tudományos adatbázis. A megfigyelések – faj, hely, dátum – '
        'akkor is értékesek, ha a személy már nem köthető hozzájuk. Ezért az '
        'anonimizálás a törlés egy elfogadott formája: a személyes adat megszűnik, '
        'a tudományos adat megmarad.',
  ]),
  ('Kérdés esetén', [
    'szabolcs.csoke@thermakft.hu',
  ]),
];
