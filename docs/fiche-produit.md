# 🎹 Compiano Studio : L'Académie de Piano Virtuelle Nouvelle Génération

> **"Ne jouez pas seulement les bonnes notes. Adoptez le bon geste."**

**Compiano Studio** n'est pas une simple application de lecture de partitions. C'est une **solution pédagogique complète** qui fusionne la précision d'un moteur de gravure professionnel avec l'intelligence d'un coach virtuel, basé sur les principes physiologiques d'Alfred Cortot.

Destiné aux pianistes exigeants, aux autodidactes bloqués par des plafonds de verre techniques, et aux professeurs cherchant un outil de suivi moderne, Compiano Studio redéfinit l'apprentissage du piano à l'ère de l'IA.

---

## 💎 Pourquoi Compiano Studio est unique ?

La plupart des applications (Simply Piano, Yousician) misent sur la "gamification" : des barres qui défilent et des points. C'est amusant, mais cela n'enseigne pas la **technique pianistique**.

Compiano Studio prend le contre-pied :
1.  **La Partition avant tout** : Nous utilisons le standard professionnel (MusicXML & SMuFL) pour vous habituer à la vraie lecture.
2.  **La Physiologie avant le Score** : Notre IA n'analyse pas seulement si vous avez appuyé sur la touche, mais *comment* (régularité, isochronie, vélocité).
3.  **La Remédiation ciblée** : Au lieu de vous dire "Ressayez", nous vous disons "Votre pouce est lent, voici l'exercice Cortot n°4 pour le débloquer".

---

## 🚀 Fonctionnalités Clés

### 1. Le Moteur de Rendu "Zero-Compromise"
Au cœur de l'application tourne `mXMLConverter`, un moteur natif C++ développé sur mesure.
*   **Gravure Professionnelle** : Utilisation de la police **Bravura** (standard SMuFL) pour un rendu vectoriel identique aux éditions papier de référence (Henle, Bärenreiter).
*   **Fluidité Absolue** : Rendu à **60 FPS** garantissant une lecture sans saccade, même sur des partitions orchestrales complexes.
*   **Universel** : Importez vos propres fichiers `.musicxml` ou `.mxl` sans limite. L'application recalcule la mise en page (systèmes, mesures) instantanément selon votre écran.

### 2. L'Intelligence Artificielle Pédagogique (Gemini Core)
L'IA ne se contente pas d'écouter, elle comprend la structure musicale.
*   **Analyse de Difficulté (AI Grading)** : Avant même de jouer, l'IA scanne le fichier pour détecter les défis techniques (octaves, grands sauts, polyrythmie) et attribue un niveau (1-9).
*   **Générateur de Routine (Smart Practice)** : Fini de jouer le morceau du début à la fin sans progresser. L'IA découpe l'œuvre en sections logiques et génère un plan de travail :
    *   *Jour 1 :* Mains séparées sur les mesures 12-16 (Passage du pouce).
    *   *Jour 2 :* Travail du rythme pointé pour la régularité.
    *   *Jour 3 :* Mise en place mains ensemble à 50% du tempo.

### 3. La Méthode Cortot Digitalisée
Nous avons codé les *Principes Rationnels de la Technique Pianistique* d'Alfred Cortot directement dans l'algorithme d'analyse.
*   **Diagnostic Biomécanique** : Détection des tensions musculaires via l'analyse des micro-variations de tempo (isochronie).
*   **Exercices Contextuels** : Si vous butez sur un trait de Chopin, l'application vous propose immédiatement l'exercice technique préparatoire correspondant (Hanon, Czerny ou Brahms) pour isoler la difficulté.

### 4. Outils de Travail Avancés
*   **Clavier Virtuel Réactif** : Visualisation temps réel des notes jouées (Input MIDI) et attendues.
*   **Mode Focus** : Zoom intelligent sur une plage de mesures spécifique.
*   **Personnalisation Poussée** : +50 options de gravure (taille des notes, espacements, mode sombre réel, coloration pédagogique des notes).

---

## 🎯 Pour qui ?

### Pour l'Étudiant Autodidacte
Vous avez appris les bases mais vous stagnez ? Vos morceaux manquent de fluidité ? Compiano Studio agit comme le professeur qui corrige votre position et votre technique, disponible 24h/24.

### Pour le Professeur de Piano
Utilisez Compiano comme un "Assistant de répétition" pour vos élèves.
*   Importez vos partitions annotées.
*   L'élève travaille chez lui avec le feedback actif.
*   Vous récupérez des statistiques précises sur ses points de blocage à la leçon suivante.

### Pour le Musicien Numérique
Une bibliothèque unique pour toutes vos partitions XML, avec un moteur de rendu bien supérieur aux lecteurs PDF statiques, permettant la transposition et le reformatage à la volée.

---

## 💰 Offres & Tarifs

| Fonctionnalité | **Compiano Reader** (Gratuit) | **Compiano Academy** (Premium) |
| :--- | :---: | :---: |
| **Moteur de Rendu C++** | ✅ Illimité | ✅ Illimité |
| **Import MusicXML** | ✅ Illimité | ✅ Illimité |
| **Outils (Métronome, Clavier)** | ✅ | ✅ |
| **Catalogue Certifié** | ❌ | ✅ (Doigtés experts inclus) |
| **Coach IA & Routines** | ❌ | ✅ |
| **Analyse Cortot** | ❌ | ✅ |
| **Suivi de Progression** | ❌ | ✅ |

> *Le modèle Freemium permet à tout musicien de bénéficier du meilleur lecteur de partition du marché, tandis que l'offre Academy s'adresse à ceux qui veulent progresser techniquement.*

---

## 🛠 Spécifications Techniques

*   **Plateformes** : Windows, macOS, Linux (Mobile iOS/Android en roadmap).
*   **Formats Supportés** : MusicXML (`.xml`, `.musicxml`), Compressed MXL (`.mxl`).
*   **Connectivité** : MIDI (USB/Bluetooth) pour le feedback interactif.
*   **Audio** : Synthétiseur intégré pour l'écoute (Playback) et Métronome intelligent.
*   **Architecture** : Flutter UI + C++ Core (FFI) pour une performance native.

---

## 🔮 Le Futur de l'Apprentissage

Compiano Studio ne remplace pas le professeur : il le seconde. En déléguant la répétition technique et la surveillance de la régularité à l'IA, nous libérons du temps pour ce qui compte vraiment lors des cours : **l'interprétation et l'émotion**.

**Rejoignez la révolution pianistique.**
```