# IA-PATTERN : Définition Algorithmique des Difficultés Pianistiques

Ce document définit la méthodologie pour identifier et classifier les difficultés techniques du piano de manière **mathématique et déterministe**, sans dépendre de l'intuition du développeur.

## 1. Philosophie : "Maths > Intuition"

Le défi : Coder un système capable d'évaluer un niveau "Virtuose" (Henle 9) alors que le développeur est "Intermédiaire" (Henle 4).

**La Solution :**
La musique est une géométrie dans le temps et l'espace (clavier). Nous ne cherchons pas à "sentir" la difficulté, mais à mesurer :
1.  **L'Écartement** (Intervalles, Extension).
2.  **La Vitesse** (Densité de notes / seconde).
3.  **La Simultanéité** (Polyphonie, Accords).
4.  **L'Indépendance** (Mouvements contraires, Polyrythmie).

---

## 2. Taxonomie de Cortot (Les 5 Piliers)

Nous utilisons la classification d'Alfred Cortot (*Principes Rationnels de la Technique Pianistique*) pour catégoriser les patterns détectés par le moteur C++.

### I. Égalité, Indépendance et Mobilité
*Gammes, traits, trilles.*

### II. Passage du Pouce
*Gammes, arpèges, changement de position.*

### III. Doubles Notes & Polyphonie
*Tierces, sixtes, quartes, jeu léguato.*

### IV. Extension
*Accords plaqués, arpèges larges ( > octave), sauts.*

### V. Technique du Poignet
*Staccato, octaves, répétitions rapides.*

---

## 3. Catalogue des Patterns & Logique de Détection

Voici comment traduire les concepts musicaux en règles algorithmiques (Pseudo-code C++).

### A. Les Gammes (Scales)
**Définition** : Suite de notes conjointes (intervalles ≤ 2 demi-tons) dans une direction constante.

```cpp
// Pseudo-code de détection
Pattern DetectScale(Note* notes, int count) {
    int consecutive = 0;
    Direction lastDir = NONE;
    
    for(i=0; i<count-1; i++) {
        int interval = abs(notes[i+1].pitch - notes[i].pitch);
        Direction dir = (notes[i+1].pitch > notes[i].pitch) ? UP : DOWN;
        
        if (interval <= 2 && interval > 0 && dir == lastDir) {
            consecutive++;
        } else {
            if (consecutive > 5) return Pattern(SCALE, start_idx, end_idx);
            consecutive = 0;
        }
        lastDir = dir;
    }
}
```

### B. Les Arpèges (Arpeggios)
**Définition** : Suite de notes espacées de tierces ou quartes (3 ou 4 demi-tons), couvrant plus d'une octave.

```cpp
// Logique
Intervalle moyen ~ 3.5 demi-tons.
Direction constante sur au moins 4 notes.
Span total > 12 demi-tons.
```

### C. Notes Répétées (Repeated Notes)
**Définition** : Même hauteur de note jouée successivement à haute vitesse.

```cpp
if (notes[i].pitch == notes[i+1].pitch) {
    float timeDelta = notes[i+1].startTime - notes[i].startTime;
    if (timeDelta < 200ms) { // Plus vite que 300 BPM en noires
        Tag("repeated_notes_fast");
    }
}
```

### D. Octaves & Accords
**Définition** :
*   **Octave** : 2 notes simultanées, intervalle = 12.
*   **Accord Dense** : ≥ 3 notes simultanées.

```cpp
// Densité verticale
int simultaneousNotes = CountNotesAtTime(t);
int maxSpan = MaxPitch(t) - MinPitch(t);

if (simultaneousNotes == 2 && maxSpan == 12) Tag("octave");
if (simultaneousNotes >= 4) Tag("dense_chord");
if (maxSpan > 12) Tag("wide_extension"); // Demande une grande main
```

### E. Polyrythmie (Polyrhythm)
**Définition** : Division temporelle inégale entre main gauche (MG) et main droite (MD).

```cpp
// Sur une mesure donnée
float ratio = CountNotes(MD) / CountNotes(MG);

if (ratio == 1.5 || ratio == 0.66) Tag("polyrhythm_3_2"); // 3 pour 2
if (ratio == 1.33 || ratio == 0.75) Tag("polyrhythm_4_3"); // 4 pour 3
```

---

## 4. Stratégie de Calibration ("Unit Tests" Musicaux)

Pour valider que l'algorithme fonctionne, nous utilisons des "Fichiers de Vérité Terrain" (Ground Truth). Si l'algorithme ne détecte pas le pattern dans ces morceaux, il doit être ajusté.

| Pattern Cible | Fichier de Test (Répertoire) | Résultat Attendu |
| :--- | :--- | :--- |
| **Gammes** | *Czerny Op. 299 No. 1* | Détection continue de `SCALE_RUN` (MD). |
| **Arpèges** | *Chopin Étude Op. 10 No. 1* | Détection `WIDE_ARPEGGIO` sur 100% du morceau. |
| **Tierces** | *Chopin Étude Op. 25 No. 6* | Détection `DOUBLE_NOTE_THIRDS` à haute vélocité. |
| **Main Gauche** | *Czerny Op. 740 No. 1* | Score de difficulté MG > Score MD. |
| **Polyrythmie** | *Debussy Arabesque No. 1* | Détection `POLYRHYTHM_2_3` (Deux pour Trois). |
| **Octaves** | *Liszt La Campanella* | Détection `JUMP_OCTAVES` (Sauts d'octaves). |

## 5. Workflow de Développement (Reverse Engineering)

1.  **Extraction** : Prendre un XML de virtuose (ex: Liszt).
2.  **Analyse IA** : Demander à Gemini : *"Analyse les mesures 10 à 20. Quelle est la règle mathématique qui rend ce passage difficile ?"*
3.  **Implémentation** : Coder la règle en C++ dans `DifficultyAnalyzer`.
4.  **Validation** : Passer le XML dans le moteur et vérifier que le `DifficultyScore` explose (8/10 ou 9/10).
5.  **Régression** : Passer "Au clair de la lune" et vérifier que le score reste bas (1/10).

# 6. Analyse Algorithmique (Approche Cortot)

**Objectif** : Détection de patterns et évaluation de l'Index de Difficulté Cortot (IDC).

## 6.1. Philosophie de l'Analyse

- Contrairement aux classifications statiques (type Score Henle), ce système repose sur une décomposition **physiologique** de la partition.
- La difficulté n'est pas considérée comme une valeur globale, mais comme une série de conflits mécaniques entre la structure de la main humaine et l'écriture musicale.

## 6.2. Les 5 Familles de Patterns (Features)

Le logiciel doit extraire cinq catégories de données à partir des fichiers MusicXML :

| Catégorie Cortot | Indicateur Algorithmique (Feature) | Risque Technique |
| :--- | :--- | :--- |
| **I. Mobilité Digitale** | Fréquence d'articulation par doigt (Notes isochrones) | Fatigue et perte d'égalité |
| **II. Passage du Pouce** | Ratio $\Delta$ Pitch / $\Delta$ Temps avec changement de position | Rupture du legato, lenteur de pivot |
| **III. Polyphonie** | Superposition de durées différentes à une même main | Défaut d'indépendance musculaire |
| **IV. Extension** | Intervalle > 7 demi-tons pour les doigts internes | Tension ligamentaire |
| **V. Grand Saut** | Déplacement latéral > 12 demi-tons en t < 200ms | Imprécision de la chute (poignet) |

## 6.3. Logique de Détection (Pseudo-Code)

Le moteur d'analyse doit scanner chaque mesure pour identifier les "points de friction".

```python
def calculate_cortot_index(measure_data):
    # Initialisation du score de difficulté
    idc_score = 0
    
    # 1. Détection de l'indépendance (Chapitre 1 & 3)
    if has_sustained_note_with_moving_inner_voices(measure_data):
        idc_score += weight_polyphony * density_factor
        
    # 2. Détection de l'extension critique (Chapitre 4)
    max_stretch = measure_data.get_max_interval()
    if max_stretch > 10: # Octave+
        idc_score += weight_stretch * (max_stretch - 7)
        
    # 3. Détection de la vélocité relative (Mobilité)
    notes_per_second = measure_data.note_count / measure_data.duration
    if notes_per_second > threshold_velocity:
        idc_score += weight_velocity * notes_per_second
        
    return idc_score
```

## 6.4. Recommandations pour l'Apprentissage (Output IA)

Une fois le pattern identifié, l'IA ne doit pas simplement signaler l'erreur, mais proposer la "formule de travail" correspondante issue des 9 exercices quotidiens de Cortot :

- **Si conflit d'indépendance** : Générer un exercice de notes tenues avec pression constante sur les doigts inactifs.
- **Si problème de vélocité** : Appliquer l'algorithme de répétition rythmique (variations de rythmes : pointées, syncopes) pour stabiliser l'articulation.
- **Si grand saut** : Pratiquer le déplacement "muet" (préparation de la position sans frapper la note).

---

# 7. Module de Vélocité et Remédiation

## 7.1. La Vélocité comme "Sortie Logique"

Dans ce modèle, la vélocité n'est pas une variable d'entrée, mais le résultat de l'optimisation des cinq règles fondamentales.

### Métrique de la Vélocité Assistée par Ordinateur (VAO)
L'IA doit évaluer la "Vitesse Critique" de l'utilisateur en mesurant la dégradation de l'isochronie.

- **Indicateur de Rupture** : Le moment où l'écart-type de l'intervalle inter-notes ($t_{n+1} - t_n$) dépasse 15% de la valeur moyenne.
- **Diagnostic IA** : Si la rupture survient, l'IA identifie quel doigt ou quel pivot (Règles 1 à 5) est le "goulot d'étranglement".

## 7.2. Module de Remédiation : Les 9 Exercices de Maintenance

Pour chaque pattern de difficulté détecté, le logiciel propose une séquence de "Gymnastique Quotidienne" (environ 15 minutes).

| Type de Pattern Détecté | Exercice de Remédiation Cortot | Objectif Physiologique |
| :--- | :--- | :--- |
| Passage de pouce heurté | Exercice n°4 (Pivotement du pouce) | Fluidité du déplacement latéral. |
| Écarts de main tendus | Exercice n°6 (Extensions interdigitales) | Élastification de la paume. |
| Traits de croches inégaux | Exercice n°1 (Notes tenues) | Indépendance totale des extenseurs. |
| Accords plaqués durs | Exercice n°9 (Souplesse du poignet) | Absorption du choc par l'articulation. |

## 7.3. Algorithme de Travail par Rythmes

Pour atteindre la vélocité sans tension, Cortot préconise de transformer tout pattern difficile en une série de variations rythmiques.

- **Le Pattern Original** : 4 doubles croches égales ($1, 1, 1, 1$).
- **Transformation A (Pointée)** : Longue-brève ($1.5, 0.5, 1.5, 0.5$).
- **Transformation B (Inversée)** : Brève-longue ($0.5, 1.5, 0.5, 1.5$).
- **Transformation C (Groupe)** : Trois brèves, une longue ($0.5, 0.5, 0.5, 2.5$).

**Logique IA** :
- Si l'utilisateur réussit les transformations rythmiques mais échoue au pattern original -> Problème **neurologique** (vitesse de transmission).
- S'il échoue aux transformations -> Problème **mécanique** (indépendance des doigts).