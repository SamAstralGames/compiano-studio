# Fonctionnalités de Compiano Studio

## 1. Moteur de Partition (Core Engine)

Basé sur la bibliothèque `mXMLConverter`, le moteur offre un rendu de qualité professionnelle.

### Import & Formats
- **MusicXML (.xml, .musicxml)** : Support complet du standard d'échange.
- **MXL (Compressé)** : Support des fichiers compressés (Zip container).

### Rendu Graphique (Engraving)
- **Standard SMuFL** : Utilisation de polices musicales standard (Bravura) pour un rendu vectoriel précis.
- **Layout Dynamique** :
    - Adaptation automatique à la largeur de l'écran (Responsive).
    - Gestion intelligente des sauts de ligne et de système.
    - Justification horizontale configurable.

### Personnalisation (Options)
Le moteur expose plus de 50 options de personnalisation réparties en catégories :
- **Affichage** : Titre, noms des parties, numéros de mesure, doigtés, pédales, paroles, crédits.
- **Layout** : Marges, espacement des systèmes, taille de page.
- **Notation** : Style des ligatures (beams), direction des hampes, taille des têtes de notes.
- **Couleurs** : Mode sombre (Dark Mode), coloration syntaxique des notes (Boomwhackers, Pitch-based).

---

## 2. Interface Utilisateur (Studio)

### Visualisation
- **Vue Partition** : Rendu fluide via Canvas natif (haute performance).
- **Mode Sombre** : Inversion intelligente des couleurs pour le confort visuel (supporté nativement par le moteur).
- **Zoom** : Ajustement de la taille de la partition.

### Outils Interactifs
- **Clavier Virtuel** :
    - Affichage d'un piano 88 touches en bas d'écran.
    - Réactif aux dimensions de l'écran.
    - Visualisation des notes jouées (Input) ou à jouer (Output).
- **Barre Latérale** :
    - Contrôle rapide des options (Switch Dark Mode, etc.).
    - Métadonnées du morceau (Titre, Compositeur, Difficulté).

---

## 3. Cursus d'Apprentissage Assisté par IA (Roadmap)

Ces fonctionnalités visent à transformer l'application en professeur virtuel.

### Analyse de Difficulté (AI Grading)
- **Scan Automatique** : À l'ouverture d'un fichier, l'IA analyse :
    - La tessiture (écartement des mains).
    - La vitesse (densité de notes).
    - La complexité rythmique.
    - Les altérations (tonalité).
- **Classification** : Classement du morceau sur une échelle de difficulté (ex: Henle 1-9).

### Routine de Travail Intelligente (Smart Practice)
- **Générateur de Séances** :
    - Création automatique d'un plan de travail (ex: "Séance de 20min").
    - Découpage du morceau en "Chunks" (segments digestes).
- **Modes de Travail** :
    - *Mains Séparées* : Le moteur masque ou grise une portée.
    - *Boucle de Répétition* : Focus sur les passages difficiles.
    - *Speed Trainer* : Augmentation progressive du tempo.

### Suivi de l'Étudiant
- **Profil** : Historique des morceaux joués.
- **Statistiques** : Temps passé par morceau, précision rythmique (si écoute active).

---

## 5. Modèle Économique (Freemium)

### Mode Gratuit (Reader)
- **Import illimité** de fichiers MusicXML personnels.
- Rendu haute qualité (Moteur C++).
- Clavier virtuel et feedback MIDI basique (Note jouée / Note attendue).

### Mode Premium (Academy)
- **Accès au catalogue certifié** (Doigtés validés, Analyse Cortot).
- **Coach IA H24** : Routines personnalisées, détection de fatigue, analyse biomécanique.
- Suivi de progression détaillé et historique.

## 4. Performance & Benchmarks

L'application intègre des outils de mesure pour garantir la fluidité (60fps).

### Pipeline Benchmarks
Mesure précise du temps passé dans chaque étape du moteur C++ :
- **Input** : Chargement XML et construction du modèle.
- **Layout** : Calcul des métriques et sauts de ligne.
- **Render** : Génération des commandes graphiques.

### Optimisations
- **Glyph Cache** : Mise en cache des glyphes pour éviter le recalcul.
- **Spatial Indexing** : Optimisation pour les très grandes partitions.
- **Zero-Copy** : Transfert minimal de données entre C++ et Dart.
```

<!--
[PROMPT_SUGGESTION]Implémente maintenant la classe ScoreController dans lib/logic/score_controller.dart pour sortir la logique FFI de l'UI, en utilisant le pattern ChangeNotifier.[/PROMPT_SUGGESTION]
[PROMPT_SUGGESTION]Crée un service Dart 'DifficultyAnalyzer' qui prend un MXMLHandle, extrait des métriques simples via le bridge (nombre de notes, armure) et retourne un score de difficulté.[/PROMPT_SUGGESTION]
