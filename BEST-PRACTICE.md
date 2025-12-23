# Best Practices & Guidelines — Compiano Studio

Bienvenue dans le développement Flutter ! Ce document rassemble les règles d'or pour maintenir ce projet propre, performant et stable, en tenant compte de sa spécificité (Moteur C++ via FFI).

---

## 1. Structure du Projet

Pour éviter le "Spaghetti Code", nous adoptons une structure stricte par couches techniques.

```text
lib/
├── core/                 # 🧱 Fondations techniques (Bas niveau)
│   ├── bridge.dart       # Le pont FFI (Seul fichier autorisé à importer dart:ffi)
│   ├── errors.dart       # Exceptions personnalisées (ex: MxmlException)
│   └── constants.dart    # Constantes globales (ex: chemins assets par défaut)
├── logic/                # 🧠 Cerveau de l'app (Business Logic)
│   ├── controllers/      # Gestion d'état (ChangeNotifier, Cubit, etc.)
│   │   └── score_controller.dart
│   ├── models/           # Modèles de données Dart purs (POJO)
│   └── services/         # Services (Audio, FileSystem, AI Analysis)
├── ui/                   # 🎨 Interface Utilisateur (Widgets)
│   ├── common/           # Widgets réutilisables (Boutons, Sliders)
│   ├── painters/         # CustomPainters (ScorePainter)
│   └── pages/            # Écrans complets (ScorePage, HomePage)
└── utils/                # 🛠️ Outils génériques (Formatters, Loggers)
```

---

## 2. Règles d'Architecture (Layered Architecture)

### Règle #1 : Sens unique de dépendance
`UI` -> `Logic` -> `Core`.
*   L'UI ne doit **jamais** toucher directement au `bridge.dart` ou à `dart:ffi`.
*   L'UI parle à un `Controller`. Le `Controller` parle au `Bridge`.

### Règle #2 : Séparation "Smart" vs "Dumb" Widgets
*   **Pages (Smart)** : Elles instancient les contrôleurs, écoutent les changements d'état et passent les données aux enfants.
*   **Composants (Dumb)** : Ils reçoivent des données en paramètres (constructeur) et renvoient des événements via des callbacks (`onTap`). Ils ne doivent pas avoir de logique métier complexe.

---

## 3. Spécifique FFI & Gestion Mémoire (CRITIQUE ⚠️)

Puisque nous manipulons du C++, le Garbage Collector (GC) de Dart ne peut pas tout faire.

### Règle #3 : "You alloc, you free"
Si tu alloues de la mémoire côté Dart pour l'envoyer au C++ (ex: `calloc<Utf8>`), tu dois **impérativement** la libérer dans un bloc `try / finally`.

```dart
// ✅ BONNE PRATIQUE
final ptr = path.toNativeUtf8();
try {
  _bridge.loadFile(ptr);
} finally {
  calloc.free(ptr); // Toujours libérer, même si ça crash avant
}
```

### Règle #4 : Ne jamais stocker de pointeurs dans l'UI
Ne garde jamais un `Pointer<MXMLHandle>` dans un Widget. Si le Widget est détruit et reconstruit (ce qui arrive souvent en Flutter), tu risques de perdre la référence ou de créer une fuite. Le pointeur doit vivre dans un `Service` ou un `Controller` qui a un cycle de vie long (Singleton ou Scoped).

---

## 4. Performance & Rendu (CustomPainter)

### Règle #5 : La méthode `paint()` doit être rapide
La méthode `paint()` est appelée à chaque frame (60x par seconde lors d'une animation).
*   **Interdit** : Charger des fichiers, allouer de la mémoire lourde, faire des calculs complexes (boucles imbriquées inutiles) dans `paint()`.
*   **Recommandé** : Prépare tes données (Listes de commandes, Offsets) dans le `Controller` *avant* de demander le repaint.

### Règle #6 : Utiliser `shouldRepaint`
Dans ton `CustomPainter`, implémente correctement `shouldRepaint`. Si les données n'ont pas changé, renvoie `false` pour économiser le GPU.

---

## 5. Style de Code (Dart Standard)

### Règle #7 : Nommage
*   `UpperCamelCase` pour les Classes, Enums, Typedefs (`ScoreController`).
*   `lowerCamelCase` pour les variables, méthodes (`loadScore`).
*   `snake_case` pour les noms de fichiers (`score_controller.dart`).
*   `_underscore` pour les membres privés (`_handle`).

### Règle #8 : Async / Await
Évite la syntaxe `.then()`. Utilise toujours `async` / `await` pour la lisibilité.

---

## 6. Revue de l'existant (Conseils spécifiques)

Basé sur l'état actuel de ton repo :

1.  **Bridge.dart est massif** :
    *   *Conseil* : Le fichier `bridge.dart` contient tout (structs, signatures, wrappers). À terme, sépare les définitions de types (`mxml_types.dart`) des fonctions (`mxml_bindings.dart`).

2.  **Gestion des Strings C++** :
    *   *Conseil* : Quand le C++ renvoie un `const char*` (via `mxml_get_string`), Dart reçoit un pointeur. Si tu veux garder cette string, convertis-la tout de suite avec `.toDartString()`. Ne garde pas le pointeur, car si le C++ nettoie sa mémoire, ton pointeur Dart pointera vers le vide (Crash).

3.  **Architecture UI** :
    *   *Conseil* : Actuellement, il semble que `ScorePage` fasse beaucoup de choses. Ta priorité (selon le TODO) de créer un `ScoreController` est la bonne. Fais-le dès maintenant pour ne pas t'enfermer dans une dette technique.

---

## En résumé
1. **Sépare** l'UI de la Logique.
2. **Libère** ta mémoire FFI (`calloc.free`).
3. **Optimise** ta boucle de rendu (`paint`).

---

## 7. Plan de Refactoring (Découpage Prévisionnel)

Pour anticiper la complexité future, voici comment nous prévoyons de découper les fichiers "critiques" (notamment `bridge.dart`) et les modules à venir.

### 7.1. Éclatement de `lib/core/bridge.dart`
Ce fichier est actuellement un "God Object". Il sera divisé en sous-dossier `lib/core/ffi/` :
1.  **`mxml_types.dart`** : Uniquement les classes `Struct`, `Union` et les `typedef` de base (Int32, etc.).
2.  **`mxml_signatures.dart`** : Les signatures des fonctions C (`typedef mxml_create_func = ...`).
3.  **`mxml_library.dart`** : Le chargement du binaire (`DynamicLibrary.open`) et le lookup des symboles.
4.  **`bridge.dart`** : La classe de haut niveau `MXMLBridge` qui expose des méthodes Dart propres (`String`, `List`) et gère les `try/finally`.

### 7.2. Structure cible du dossier `lib/logic/`
Au lieu de tout mettre à la racine de `logic/`, nous adopterons ce découpage par "Feature" :
```text
lib/logic/
├── score/                  # Feature: Partition
│   ├── score_controller.dart
│   └── score_repository.dart
├── audio/                  # Feature: Son & MIDI
│   ├── midi_service.dart
│   └── audio_player.dart
└── learning/               # Feature: IA & Apprentissage
    ├── difficulty_analyzer.dart
    └── practice_planner.dart
```