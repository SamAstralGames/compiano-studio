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

### 2.3. Dart Bridge Layer (`lib/core/bridge.dart`)
- **Rôle** : Abstraction de la couche native.
- **Fonctionnement** :
    - Charge la bibliothèque dynamique (`.so`, `.dll`, `.dylib`).
    - Définit les signatures de fonctions FFI (`typedef`).
    - Convertit les types Dart (String, List) en types C (Pointer<Utf8>, Array) et inversement.
    - Gère la mémoire manuelle (allocation/libération via `calloc`) pour les échanges de données.

### 2.4. Native Layer (`libmxmlconverter`)
- **Rôle** : Moteur de calcul lourd (Parsing XML, Layout, Engraving).
- **Flux de données** :
    1. **Input** : Fichier MusicXML.
    2. **Process** : Construction du modèle musical -> Calcul du Layout (mesures, systèmes, espacements) -> Génération des commandes de rendu.
    3. **Output** : Buffer de `RenderCommand` (structs C légères : `Line`, `Glyph`, `Text`).

## 3. Flux de Rendu (Rendering Pipeline)

Le rendu n'utilise pas de SVG intermédiaire pour des raisons de performance. Il utilise une approche "Direct Drawing".

1. **Flutter** demande un layout pour une largeur donnée (`width`).
2. **C++** calcule le layout et remplit un buffer de commandes.
3. **Flutter** récupère le pointeur vers ce buffer via FFI.
4. **ScorePainter** itère sur ce buffer et appelle les méthodes natives du Canvas Flutter (`drawLine`, `drawText`, etc.).
    - *Note* : Les glyphes musicaux (SMuFL) sont rendus comme du texte via une font spécifique (Bravura) chargée dans Flutter.

## 4. Module IA & Apprentissage (Conceptuel)

Ce module se situera dans la couche **Logic**.

### Analyse Statique
- Le moteur C++ peut exposer des métriques (nombre de notes, tessiture).
- Dart utilise ces métriques pour calculer un score de difficulté.

### Génération de Routine
- Un service Dart (`PracticeService`) analyse la structure du morceau.
- Il génère une liste d'objets `PracticeTask` (ex: "Mesures 1-4, Main Gauche").
- Ces tâches pilotent l'état de l'UI (masquage de portées, tempo suggéré).

## 5. Gestion de la Mémoire

- **C++** : Gère la mémoire du modèle musical (DOM) et des caches de glyphes.
- **Dart FFI** :
    - Les pointeurs `MXMLHandle` et `MXMLOptions` sont opaques côté Dart.
    - Dart doit explicitement appeler `destroy()` pour libérer les ressources C++.
    - Les chaînes de caractères retournées par le C++ doivent être copiées en Dart si elles doivent persister, ou lues à la volée.

## 6. Dépendances Critiques

- `ffi` : Pour l'interopérabilité native.
- `path_provider` : Pour l'accès au système de fichiers (chargement XML).
- `flutter_midi_pro` (prévu) : Pour la sortie audio/MIDI.