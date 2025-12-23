# 1. Système de notation interne (Niveau Étudiant)

## Les Niveaux Henle (Référence)

- **Niveaux 1–3** : Débutant – Facile
- **Niveaux 4–6** : Intermédiaire
- **Niveaux 7–9** : Avancé → Virtuose

## 🎼 Équivalence Paliers → Niveaux Henle

| Palier | Nom | Henle | Description / Répertoire |
| :--- | :--- | :--- | :--- |
| **1** | **Fondations** | Niv. 1 | Premières pièces faciles, études élémentaires (Duvernoy début). |
| **2** | **Coordination** | Niv. 2 | Mouvements simples mains ensemble, syncopes légères. |
| **3** | **Fluidité & Nuances** | Niv. 3–4 | Burgmüller Op.100 précoce (Arabesque). Début intermédiaire. |
| **4** | **Vélocité & Précision** | Niv. 4–5 | Czerny Op.299 simplifié. Intermédiaire solide. |
| **5** | **Contrôle & Expression** | Niv. 5–6 | Burgmüller Op.100 avancé, Schumann (Album à la jeunesse). |
| **6** | **Passages Complexes** | Niv. 6 | Loeschhorn interm., Czerny Op.299 avancé. Début virtuosité. |
| **7** | **Virtuosité Interm.** | Niv. 7–8 | Cramer, Czerny Op.740 moyen. Polyrythmies, arpèges larges. |
| **8** | **Articulation Avancée** | Niv. 8 | Cramer difficile, Czerny Op.740 avancé, Chopin (Préludes). |
| **9** | **Virtuosité Supérieure** | Niv. 8–9 | Octaves rapides, endurance, chromatisme (Loeschhorn avancé). |
| **10** | **Maîtrise Totale** | Niv. 9 | Études de Chopin (Entrée vers le répertoire de concert). |

## Les Patterns
- [ ] **TODO** : Faire une liste exacte des patterns par niveau.

# 2. Analyse des fichiers MusicXML

## Classement Henle

## Mise en évidence des patterns
*Classement de ceux-ci sur une échelle de notation interne.*


# 3. Analyse des Patterns & Feedback Objectif

L'originalité du système repose sur le remplacement de l'intuition du professeur par une analyse algorithmique déterministe en C++.

## Analyse des Patterns (Le "Référentiel")

- **Pré-analyse IA** : Chaque morceau (MusicXML) est scanné par l'IA pour identifier les segments techniques. Chaque segment reçoit un **Tag Technique** et un **Score de Difficulté Henle** (1-9).
- **Vecteur de Performance** : Le Matcher local calcule pour chaque pattern :
    - **$P_t$ (Précision Temporelle)** : Déviation en millisecondes (seuil de détection < 10ms).
    - **$P_v$ (Régularité de Vélocité)** : Écart-type de la force d'impact (0-127) pour détecter les faiblesses digitales (ex: 4ème doigt).
    - **$S$ (Stabilité)** : Capacité à maintenir le BPM cible sur les passages denses.

## Diagnostic "Plus précis qu'un Professeur"

- **Micro-détection** : Là où un humain entend un "manque de clarté", l'algorithme identifie un retard systématique de 15ms entre deux doigts spécifiques.
- **Analyse de Tendance** : Le Stat Backend compile les sessions pour différencier une erreur ponctuelle d'une lacune structurelle (ex: fatigue musculaire après 20 min de jeu ou crispation sur les octaves).

---

# 4. Routines IA & Moteur de Recommandation

L'IA n'intervient pas pour "écouter" le son, mais pour interpréter le bilan de données et agir en coach pédagogique.

## Le "Mapping" Sémantique (Lien Morceau $\leftrightarrow$ Exercice)

Le système utilise une table de correspondance entre les tags identifiés dans le morceau préféré de l'élève et la base de données d'exercices du domaine public (Hanon, Czerny).

| Tag Identifié | Exemple de Source (ex: Beethoven) | Remède Hanon suggéré | Focus Technique |
| :--- | :--- | :--- | :--- |
| `repeated_notes` | Lettre à Élise (Partie C) | Hanon n°44 | Détente du poignet et rebond |
| `thumb_crossing` | Gamme de Do Maj Chromatique | Hanon n°32 à 37 | Agilité du passage de pouce |
| `weak_fingers_4_5` | Arpèges rapides | Hanon n°3 | Indépendance de l'annulaire |

## Génération de la Routine Personnalisée

Une fois le "match" effectué, l'IA génère un protocole d'entraînement asynchrone qui s'affiche dans Flutter :

1.  **Isolation (Looping)** : Extraction automatique de la mesure problématique (ex: Mesure 24) grâce aux coordonnées du Graphical Model.
2.  **Exercice de Transfert** : Prescription de l'exercice de Hanon correspondant pour isoler le mouvement pur.
3.  **Variante Cognitive** : L'IA propose des variantes (ex: "Joue ce Hanon en rythme pointé") pour briser la mémoire musculaire défaillante.
4.  **Validation** : Le moteur C++ valide la réussite technique de l'exercice avant de suggérer le retour au morceau original.

## Avantages de ce Cursus IA

- **Disponibilité** : Supprime les contraintes de créneaux de 45 min et le coût des cours physiques.
- **Objectivité** : Feedback basé sur des chiffres, éliminant le stress du jugement humain.
- **Efficacité** : Temps de pratique optimisé (15 min de routine ciblée valent 1h de répétition globale sans but).

# 5. Architecture Technique & Choix du Modèle (Analyse)

Cette section détaille l'implémentation technique validée pour supporter le cursus pédagogique.

## L'Approche Hybride (C++ + IA)

Le système repose sur une séparation stricte des responsabilités pour garantir fiabilité et pertinence :

1.  **La "Vérité Terrain" (C++)** :
    - Le moteur C++ est seul responsable des mesures métriques ($P_t$, $P_v$, $S$).
    - Il fournit des données brutes incontestables (ex: "Retard de 12ms sur la note 42").
    - *Pourquoi ?* Les LLM hallucinent sur les calculs mathématiques précis et la temporalité fine.

2.  **Le "Pédagogue" (Gemini 1.5 Flash)** :
    - L'IA agit comme un coach qui interprète les chiffres.
    - Elle transforme "Variance vélocité > 15" en "Attention, ton 4ème doigt est faible".
    - *Pourquoi ?* Capacité de raisonnement sémantique et d'adaptation du ton à l'élève.

## Pourquoi Gemini 1.5 Flash ?

Pour le module de recommandation et d'analyse sémantique, **Gemini 1.5 Flash** est identifié comme le modèle optimal :

- **Fenêtre de Contexte (1M tokens)** : Permet d'envoyer l'intégralité du fichier MusicXML et l'historique de l'élève sans tronquer les données.
- **Latence Faible** : Critique pour maintenir le flux de l'utilisateur ("Flow") entre le jeu et le feedback.
- **Coût/Performance** : Permet de scaler l'analyse sans explosion des coûts, contrairement aux modèles "Frontier" sur-dimensionnés pour cette tâche de classification.

## Stratégie d'Intégration (Structured Output)

L'IA ne doit pas générer de texte libre, mais des données structurées exploitables par l'UI Flutter.

- **Input** : `Métrique C++` + `Extrait XML` -> **Gemini Flash**.
- **Output** : JSON structuré (`diagnosis`, `exercise_id`, `variant`, `message`).
- **UI** : Flutter parse le JSON et affiche les widgets correspondants (Bouton "Lancer l'exercice", Graphique).

# 6. Stratégie de Contenu : Le "Walled Garden" Pédagogique

Pour garantir une fiabilité pédagogique absolue, les fonctionnalités d'apprentissage avancées sont restreintes au contenu certifié.

## 6.1. Dichotomie du Service

| Fonctionnalité | 🏛️ Catalogue Interne (Classiques) | 📂 Import Utilisateur (XML Tiers) |
| :--- | :--- | :--- |
| **Rendu Partition** | ✅ Optimisé | ✅ Standard |
| **Feedback MIDI** | ✅ (Note jouée / attendue) | ✅ (Note jouée / attendue) |
| **Analyse Cortot** | ✅ **Active** (Doigtés validés) | ❌ Désactivée (Données non fiables) |
| **Coach IA** | ✅ Génération de routines | ❌ Indisponible |
| **Auto-Doigté** | 🔒 Pré-calculé (Humain/Expert) | ⚠️ Expérimental (À la demande) |

## 6.2. Pourquoi limiter l'IA aux morceaux internes ?

1.  **Qualité des Données** : L'analyse biomécanique (Cortot) nécessite des doigtés parfaits. Les XMLs d'internet (MuseScore, IMSLP) en sont souvent dépourvus.
2.  **Responsabilité** : Donner un mauvais conseil technique (ex: mauvais doigté sur une extension) peut causer des blessures (tendinites). Nous ne prenons ce risque que sur des partitions contrôlées.
3.  **Modèle Économique** : Le "Coach IA" devient la valeur ajoutée premium associée au catalogue, tandis que le "Lecteur" reste un outil utilitaire gratuit.