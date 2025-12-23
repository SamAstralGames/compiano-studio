# Architecture Technique - Compiano Studio

Ce document décrit l'architecture logicielle de **Compiano Studio**, une application Flutter intégrant un moteur de rendu musical C++ haute performance.

## 1. Vue d'ensemble

L'application suit une architecture en couches (Layered Architecture) stricte pour isoler la complexité de la gestion mémoire (FFI) de l'interface utilisateur réactive.

```mermaid
graph TD
    UI[Flutter UI Layer] --> Logic[Business Logic Layer]
    Logic --> Bridge[Dart Bridge Layer]
    Bridge --> FFI[Dart FFI (dart:ffi)]
    FFI --> CAPI[C-API Wrapper (extern C)]
    CAPI --> Core[mXMLConverter Core (C++)]
    
    subgraph "Dart / Flutter"
    UI
    Logic
    Bridge
    end
    
    subgraph "Native"
    CAPI
    Core
    end
```

## 2. Description des Couches

### 2.1. Flutter UI Layer (`lib/ui/`)
- **Rôle** : Affichage et Interaction utilisateur. 
- **Fonctionnalités** : Le projet repose sur une répartition stricte des responsabilités pour maximiser la performance sans sacrifier la réactivité.
- **Composants Clés** :
    - `ScorePage` : Page principale orchestrant la vue partition et les outils.
    - `ScorePainter` : `CustomPainter` qui reçoit une liste de commandes de dessin (primitives) et les exécute sur le Canvas Flutter. C'est ici que le rendu "Zero-Copy" (ou presque) a lieu.
    - `PianoKeyboard` : Widget interactif visualisant les notes MIDI.

### 2.2. Business Logic Layer (`lib/logic/` - *À venir*)
- **Rôle** : Gestion de l'état de l'application (chargement, lecture, erreurs).
- **Responsabilités** :
    - Coordonner le chargement des fichiers XML.
    - Gérer le timer de lecture (Playback).
    - Analyser les données pour le module IA (Difficulté, Progression).
    - | Couche | Langage | Rôle | Exemple | +| :--- | :--- | :--- | :--- | +| UI & State | Dart (Flutter) | Chef d'Orchestre. Gère l'état visuel, les animations, les entrées utilisateur et la coordination des plugins (Audio/MIDI). | ScoreController, MidiService | +| Engine | C++ (Native) | Moteur de Calcul. Effectue les tâches lourdes, le parsing, l'algorithmique complexe et le DSP. | mxml_layout, mxml_analyze |

### 2.3. Dart Bridge Layer (`lib/core/bridge.dart`)
- **Rôle** : Abstraction de la couche native.
- **Fonctionnement** :
    - Charge la bibliothèque dynamique (`.so`, `.dll`, `.dylib`).
    - Définit les signatures de fonctions FFI (`typedef`).
    - Convertit les types Dart (String, List) en types C (Pointer<Utf8>, Array) et inversement.
    - Gère la mémoire manuelle (allocation/libération via `calloc`) pour les échanges de données.
    - Règle d'Or : Ne jamais mettre de logique d'état (State Management) ou d'asynchronisme en C++. Le C++ doit être une fonction pure ou un moteur passif interrogé par Dart.

### 2.4. Native Layer (`libmxmlconverter`)
- **Rôle** : Moteur de calcul lourd (Parsing XML, Layout, Engraving).
- **Flux de données** :
    1. **Input** : Fichier MusicXML.
    2. **Process** : Construction du modèle musical -> Calcul du Layout (mesures, systèmes, espacements) -> Génération des commandes de rendu.
    3. **Output** : Buffer de `RenderCommand` (structs C légères : `Line`, `Glyph`, `Text`).

## 3. Structure des Couches (Target)

### 3.1. Flutter UI Layer (lib/ui/) 
- **Rôle** : Affichage et Interaction.
- **Structure** :
- common/ : Widgets génériques (Design System).
- components/ : Widgets métier (PianoKeyboard, ScoreViewport).
- painters/ : Rendu bas niveau (ScorePainter).
- pages/ : Écrans complets (ScorePage).

### 3.2. Business Logic Layer (lib/logic/)
- **Rôle** : Cerveau de l'application, organisé par Feature.
- **Structure** :
- score/ : État de la partition (ScoreController).
- audio/ : Services Audio/MIDI (MidiService).
- learning/ : IA et Pédagogie (DifficultyAnalyzer).

### 3.3. Core & Bridge Layer (lib/core/)
- **Rôle** : Fondations et communication FFI.
- **Structure** :
- ffi/ : Découpage du bridge (types, signatures, library, bridge).
- errors/ : Exceptions typées (MxmlException).

### 3.4. Native Layer (libmxmlconverter)
- **Rôle** : Moteur de calcul lourd (Parsing XML, Layout, Engraving).
- **Flux de données** :
- Input : Fichier MusicXML. @@ -53,7 +69,7 @@
- Output : Buffer de RenderCommand (structs C légères : Line, Glyph, Text).

## 4. Flux de Rendu (Rendering Pipeline)

Le rendu n'utilise pas de SVG intermédiaire pour des raisons de performance. Il utilise une approche "Direct Drawing".

1. **Flutter** demande un layout pour une largeur donnée (`width`).
2. **C++** calcule le layout et remplit un buffer de commandes.
3. **Flutter** récupère le pointeur vers ce buffer via FFI.
4. **ScorePainter** itère sur ce buffer et appelle les méthodes natives du Canvas Flutter (`drawLine`, `drawText`, etc.).
    - *Note* : Les glyphes musicaux (SMuFL) sont rendus comme du texte via une font spécifique (Bravura) chargée dans Flutter.

## 5. Module IA & Apprentissage (Conceptuel)

Ce module se situera dans la couche **Logic**.
Il génère une liste d'objets PracticeTask (ex: "Mesures 1-4, Main Gauche").
Ces tâches pilotent l'état de l'UI (masquage de portées, tempo suggéré).

### Analyse Statique
- Le moteur C++ peut exposer des métriques (nombre de notes, tessiture).
- Dart utilise ces métriques pour calculer un score de difficulté.

### Génération de Routine
- Un service Dart (`PracticeService`) analyse la structure du morceau.
- Il génère une liste d'objets `PracticeTask` (ex: "Mesures 1-4, Main Gauche").
- Ces tâches pilotent l'état de l'UI (masquage de portées, tempo suggéré).

## 6. Gestion de la Mémoire

- **C++** : Gère la mémoire du modèle musical (DOM) et des caches de glyphes.
- **Dart FFI** :
    - Les pointeurs `MXMLHandle` et `MXMLOptions` sont opaques côté Dart.
    - Dart doit explicitement appeler `destroy()` pour libérer les ressources C++.
    - Les chaînes de caractères retournées par le C++ doivent être copiées en Dart si elles doivent persister, ou lues à la volée.

## 7. Dépendances Critiques

- `ffi` : Pour l'interopérabilité native.
- `path_provider` : Pour l'accès au système de fichiers (chargement XML).
- `flutter_midi_pro` (prévu) : Pour la sortie audio/MIDI.