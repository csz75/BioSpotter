# BioSpotter — Flutter starter

Ez a mappa a BioSpotter mobilalkalmazás kiinduló kódja (Flutter + Supabase).

## Amire szükséged van (egyszeri telepítés)

1. **Flutter SDK** — https://docs.flutter.dev/get-started/install
2. **VS Code** + a Flutter és Dart bővítmények
3. **Git** (a Flutter is használja)

## Első lépések

1. Nyisd meg ezt a mappát VS Code-ban (File → Open Folder).
2. A `lib/core/config/env.dart` fájlban illeszd be a Supabase adataidat:
   - `supabaseUrl` — pl. `https://xyz.supabase.co`
   - `supabaseAnonKey` — az "anon public" kulcs
3. Nyiss egy terminált VS Code-ban (Ctrl+`) és futtasd:

   ```
   flutter pub get
   ```

4. Indítsd el az appot (válassz egy emulátort vagy csatlakoztatott telefont):

   ```
   flutter run
   ```

## Ha a függőségek verziója nem stimmel

Ha a `flutter pub get` verzió-hibát jelez, futtasd egyenként — ezek automatikusan a legfrissebb kompatibilis verziókat húzzák be:

```
flutter pub add supabase_flutter
flutter pub add flutter_riverpod
flutter pub add image_picker
flutter pub add geolocator
flutter pub add flutter_map
flutter pub add latlong2
flutter pub add cached_network_image
```

## Mappa struktúra

- `lib/core/` — konfiguráció, szolgáltatások, téma
- `lib/features/` — üzleti logika (auth, megfigyelések)
- `lib/screens/` — képernyők

## Következő lépések

Ez egy induló váz. A fejlesztés javasolt sorrendje:

1. Bejelentkezés + regisztráció működjön
2. Megfigyelés létrehozása (fotó + GPS)
3. Megfigyelési lista betöltése
4. Fajazonosító API bekötése (Plant.id / iNaturalist)
