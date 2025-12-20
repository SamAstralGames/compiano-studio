# TODO — Projet : mXMLConverter Boilerplate (Flutter FFI)

**Objectif** : Créer une application de référence ("Reference Implementation") minimale et propre, démontrant l'intégration complète de `mXMLConverter` dans un environnement Flutter via FFI. Ce projet servira de base ("Template") pour toute future application (Mobile, Desktop).

---

## 1. Architecture

L'application suit une architecture en couches stricte pour séparer l'UI du moteur C++.

```
[ Flutter UI (Widgets) ]
       |
       v
[ Controller (State Management) ] <--- (Gère l'état : Loading, Error, Playing)
       |
       v
[ mXML Bridge (Dart) ] <--- (Interface Dart pure, cache les pointeurs)
       |
       v
[ dart:ffi ]
       |
       v
[ C-API Wrapper (extern "C") ] <--- (Expose mXMLConverter en C pur)
       |
       v
[ mXMLConverter (C++ Core) ]
```

---

## 2. Structure du Projet (Proposée)

```text
mxmlconverter-boilerplate/
├── lib/
│   ├── core/
│   │   ├── bridge.dart       # Définitions FFI (généré ou manuel)
│   │   └── native_lib.dart   # Chargement de la dylib (.so/.dll)
│   ├── logic/
│   │   └── score_controller.dart # Business Logic (Load, Render)
│   ├── ui/
│   │   ├── score_widget.dart # Widget d'affichage (CustomPainter)
│   │   └── main.dart
│   └── main.dart
├── native/
│   ├── CMakeLists.txt        # Build du wrapper C++
│   └── src/                  # Code glue (C-API implementation)
├── assets/                   # Fichiers XML de démo
└── pubspec.yaml
```

---

## 3. Roadmap Fonctionnelle

### Phase 1 : "Hello Score" (Integration Basics)
**But** : Valider la chaîne de compilation et l'affichage statique.

- [x] **Build System** : Configurer CMake pour générer `libmxmlconverter.so` (Linux/Android) et `.dylib` (macOS/iOS).
- [x] **FFI Bridge** : Mapper les fonctions C de base :
    - `mxml_create()`
    - `mxml_load_file(path)`
    - `mxml_get_render_commands()`
    - `mxml_destroy()`
- [x] **UI** : Implémentation via CustomPainter directement (Skipped SVG display).

### Phase 2 : Native Canvas Rendering (Zero-Copy)
**But** : Performance maximale (60fps). Ne plus passer par du texte SVG.

- [x] **C-API** : Exposer `mxml_get_render_commands()` (Buffer binaire de commandes graphiques) et `mxml_write_svg_to_file`.
- [x] **Dart Parser** : Lire le buffer binaire (structs `RenderCommand`) en Dart.
- [x] **CustomPainter** : Implémenter un `ScorePainter` qui dessine les commandes (MoveTo, LineTo, CubicTo, Text) directement sur le Canvas Flutter.
- [ ] **Benchmark** : Mesurer le temps de rendu (vs SVG).

### Phase 3 : Interactivité & Chunking
**But** : Utiliser les nouvelles Epics 15 (Chunking) et 16 (Skyline).

- [ ] **Viewport Awareness** : Envoyer la taille du widget (`size.width`, `size.height`) au moteur C++.
- [ ] **Pan/Zoom** : Gérer `GestureDetector` en Flutter et mapper vers la caméra du moteur (ou gérer la transfo côté Flutter).
- [ ] **Infinite Scroll** : Implémenter la boucle de demande de Chunks (`RenderRange`) au fur et à mesure du scroll.

### Phase 4 : Playback & Audio (Optionnel)
- [ ] **Rhythm API** : Récupérer les événements rythmiques (Epic 12).
- [ ] **Audio Engine** : Jouer un métronome ou des sons basiques (via `flutter_soloud` ou autre) synchronisés avec le curseur.

---

## 4. Interfaces C-API requises (Specs)

Le core C++ doit exposer ces signatures (dans `mxml_c_api.h`) :

```c
typedef void* MXMLContext;

// Lifecycle
MXMLContext mxml_create();
void mxml_destroy(MXMLContext ctx);

// I/O
bool mxml_load_string(MXMLContext ctx, const char* xml_data);

// Configuration
void mxml_set_option(MXMLContext ctx, const char* key, const char* value);
void mxml_set_viewport(MXMLContext ctx, int w, int h);

// Rendering
// Retourne un pointeur vers un tableau de RenderCommands
const RenderCommand* mxml_get_commands(MXMLContext ctx, int* count);
```
