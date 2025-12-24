# TODO — Roadmap Projet : Compiano Studio

Ce document trace la route pour le développement de **Compiano Studio**, une application d'apprentissage du piano assistée par IA, basée sur le moteur de rendu `mXMLConverter`.

**Légende** :
- [x] Fait
- [~] En cours / Partiel
- [ ] À faire

---

## 1. Epic : Core Engine & Rendering (Fondations)
**Objectif** : Stabiliser l'intégration du moteur C++ via FFI et garantir un rendu performant et fidèle.

### 1.1. Feature : FFI Bridge & Binding
- [x] **Initialisation** : Chargement des bibliothèques dynamiques (`.so`, `.dll`, `.dylib`) selon l'OS.
- [x] **Mapping C-API** :
    - [x] Lifecycle (`create`, `destroy`).
    - [x] I/O (`load_file`, `load_string`).
    - [x] Rendering (`get_render_commands`, `get_height`).
    - [x] Options (Mapping exhaustif des options de layout, notation, couleurs).
- [ ] **Optimisation** :
    - [ ] Implémenter un mécanisme de *callback* pour les logs C++ vers Dart.
    - [ ] Gestion robuste des erreurs (codes de retour vs exceptions Dart).

### 1.2. Feature : Pipeline de Rendu Graphique
- [x] **Canvas Painter** : Dessin des primitives (Lignes, Glyphes SMuFL, Texte) via `CustomPainter`.
- [x] **Gestion des Fonts** : Chargement correct de la police musicale (Bravura/Petaluma).
- [~] **Layout Réactif** :
    - [x] Recalcul du layout au redimensionnement de la fenêtre.
    - [ ] Debounce/Throttle des appels FFI lors du resize pour éviter le lag.
- [ ] **Performance** :
    - [ ] Benchmark comparatif SVG vs Canvas (via `mxml_get_pipeline_bench`).
    - [ ] Implémentation du *Partial Repaint* (ne redessiner que ce qui change).

---

## 2. Epic : Interaction & Navigation
**Objectif** : Rendre la partition vivante et navigable pour l'utilisateur.

### 2.1. Feature : Navigation dans la Partition
- [ ] **Scroll & Zoom** :
    - [ ] Gérer le scroll infini vertical ou horizontal (selon le layout).
    - [ ] Pinch-to-zoom (mapper vers `mxml_set_zoom` ou transformation Canvas).
- [ ] **Pagination** : Support du mode "Page View" vs "Continuous View".

### 2.2. Feature : Virtual Piano & Feedback
- [x] **Clavier Virtuel** : Affichage d'un clavier en bas d'écran.
- [~] **Visualisation MIDI** :
    - [x] Affichage des notes actives (Demo random).
    - [ ] Connexion réelle aux événements MIDI (Input périphérique).
    - [ ] Mise en surbrillance des notes jouées sur la partition (Curseur).

---

## 3. Epic : Audio & Playback
**Objectif** : Permettre à l'élève d'écouter le morceau et de jouer avec un accompagnement.

### 3.1. Feature : Moteur Audio
- [ ] **Synthétiseur** : Intégration de `flutter_soloud` ou `flutter_midi_pro` pour jouer les notes.
- [ ] **Séquenceur** :
    - [ ] Parser les événements temporels du MusicXML (si exposés par la lib ou via parsing Dart).
    - [ ] Synchroniser le curseur de lecture avec le temps audio.

### 3.2. Feature : Outils de Pratique
- [ ] **Métronome** : Audio + Visuel.
- [ ] **Boucle (Loop)** : Sélectionner une plage de mesures (A-B repeat).
- [ ] **Tempo Variable** : Ralentir sans changer la hauteur (si audio) ou via MIDI.

---

## 4. Epic : AI-Assisted Learning (Cursus Intelligent)
**Objectif** : Créer de la valeur ajoutée pédagogique grâce à l'analyse de données et l'IA.

### 4.1. Feature : Analyse de Difficulté (Static Analysis)
*Analyse structurelle du fichier XML avant même de jouer.*
- [ ] **Algorithme de Complexité** :
    - [ ] Calculer la densité de notes par seconde.
    - [ ] Détecter les intervalles complexes (octaves, grands sauts).
    - [ ] Analyser la complexité rythmique (syncopes, triolets).
    - [ ] Identifier la tonalité et les modulations.
- [ ] **Scoring** : Attribuer un niveau (1-10 ou Débutant/Intermédiaire/Avancé) automatiquement.

### 4.2. Feature : Générateur de Routine de Travail (AI Planner)
*Création d'un plan de travail personnalisé pour un morceau donné.*
- [ ] **Segmentation** : Découper le morceau en sections logiques (Intro, Thème A, Thème B) via analyse des barres de mesure et répétitions.
- [ ] **Routine Generator** :
    - [ ] "Jour 1 : Mains séparées sur les mesures 1-8".
    - [ ] "Jour 2 : Mains ensemble tempo lent (50%)".
    - [ ] "Jour 3 : Travail des nuances".
- [ ] **Intégration LLM (Optionnel)** : Utiliser un modèle (Gemini/GPT) pour générer des conseils textuels basés sur les métadonnées du compositeur et du style (ex: "Pour du Chopin, concentrez-vous sur le Rubato").

### 4.3. Feature : Suivi de Progression (Student Profiling)
- [ ] **Ecoute Active (Pitch Detection)** : Utiliser le microphone pour détecter si l'élève joue les bonnes notes (via `flutter_fft` ou autre).
- [ ] **Heatmap d'Erreurs** : Identifier les mesures où l'élève se trompe le plus souvent.
- [ ] **Adaptation du Cursus** : Suggérer des exercices techniques (Hanon, Czerny) spécifiques aux faiblesses détectées (ex: faiblesse main gauche -> Exercice MG).

### 4.4. Feature : Catalogue Certifié (Walled Garden)
- [x] **Structure de Données** : Définir le format JSON pour les métadonnées pédagogiques (Tags Cortot, Doigtés validés).
- [x] **Catalog Service** : Service Dart pour lister les morceaux certifiés et filtrer par difficulté.
- [ ] **Smart Overlay** : Système d'injection de doigtés sur fichiers tiers via reconnaissance d'empreinte musicale. Cible initiale : **Top 50 Répertoire Standard**.
- [ ] **Restriction IA** : Désactiver les features d'analyse avancée pour les fichiers importés (Mode "Lecteur Seul").

---

## 5. Epic : Architecture & Qualité

### 5.1. Feature : State Management
- [ ] **Migration Controller** : Sortir la logique de `_ScorePageState` vers un `ScoreController` ou BLoC/Riverpod.
- [ ] **Repository Pattern** : Abstraire l'accès aux fichiers (Local, Assets, Cloud).

### 5.2. Feature : Tests
- [ ] **Unit Tests** : Tester le parsing des commandes FFI en Dart.
- [ ] **Integration Tests** : Vérifier que le chargement d'un XML ne crash pas l'app.

---

## 6. Structure de Répertoire Cible (Refactoring)

Pour aligner le projet avec les `BEST-PRACTICE.md`, voici la structure cible à atteindre progressivement.

```text
lib/
├── core/                       # Fondations techniques (Bas niveau)
│   ├── ffi/                    # Découpage du bridge actuel
│   │   ├── mxml_types.dart     # Structs & Typedefs
│   │   ├── mxml_signatures.dart # Signatures C
│   │   ├── mxml_library.dart   # DynamicLibrary.open
│   │   └── bridge.dart         # Façade haut niveau (Singleton)
│   ├── errors/                 # Exceptions (MxmlException)
│   └── constants.dart          # Config globale
├── logic/                      # Business Logic (Feature-based)
│   ├── score/                  # Feature: Partition
│   │   ├── score_controller.dart
│   │   └── score_repository.dart
│   ├── audio/                  # Feature: Audio & MIDI
│   │   ├── midi_service.dart
│   │   └── audio_engine.dart
│   └── learning/               # Feature: IA & Cursus
│       ├── difficulty_analyzer.dart
│       └── practice_planner.dart
├── ui/                         # Interface Utilisateur
│   ├── common/                 # Widgets génériques (Design System)
│   │   ├── buttons/            # Boutons réutilisables
│   │   └── layout/             # Wrappers (SplitView, Sidebar)
│   ├── components/             # Widgets Métier (Réutilisables)
│   │   ├── piano/              # Clavier Virtuel (PianoKeyboard)
│   │   └── score/              # Partition (ScoreViewport, Minimap)
│   ├── painters/               # Rendu Bas Niveau (Canvas)
│   │   ├── score_painter.dart  # Rendu principal FFI
│   │   └── cursor_painter.dart # Curseur de lecture
│   ├── pages/                  # Écrans Complets (Scaffolds)
│   │   ├── library_page.dart   # Explorateur de fichiers
│   │   └── score_page.dart     # Studio principal
│   └── theme/                  # Styles & Palettes
│       ├── app_theme.dart
│       └── app_colors.dart
└── utils/                      # Outils (Loggers, Formatters)
```
