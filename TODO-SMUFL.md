# Roadmap SMuFL (Performance Focus)

**Objectif** : Rendre les symboles musicaux (Têtes de notes, Clés, Altérations, etc.) en utilisant une police SMuFL (ex: Bravura) tout en maintenant un temps de rendu total (Pipeline + Paint) inférieur à **16ms** (60 FPS constants).

## 1. Analyse & Stratégie Performance

Le rendu de texte (Glyphes) via `TextPainter` est coûteux si on instancie un painter par glyphe (ex: 2000 notes = 2000 layouts texte).
Pour maximiser la performance, nous utiliserons une stratégie progressive :

1.  **Batching (ParagraphBuilder)** : Regrouper tous les glyphes de même taille/police dans un seul appel de dessin (`canvas.drawParagraph`). Flutter gère le layout, mais comme nous donnons des positions absolues, nous devons "hacker" le layout texte ou utiliser `drawParagraph` intelligemment.
2.  **Atlas Rendering (Ultimate Optimization)** : Si le texte est trop lent, nous pré-calculerons les glyphes dans une texture (Atlas) et utiliserons `canvas.drawRawAtlas` (similaire aux moteurs de jeu). C'est la méthode la plus rapide possible (Batch Draw Call GPU).

---

## 2. Étapes d'Implémentation

### Phase 1 : Assets & Mapping (Infrastructure)
**But** : Faire le lien entre les IDs du moteur C++ et les caractères Unicode de la police Bravura.

- [ ] **Assets** : Ajouter `Bravura.otf` (et `BravuraMetadata.json` si besoin) dans `pubspec.yaml`.
- [ ] **C-API Extension** :
    - Le moteur C++ renvoie des `GlyphId` (uint16). Dart ne sait pas à quel caractère Unicode cela correspond.
    - Ajouter `mxml_get_glyph_utf16(handle, glyphId)` ou exposer la table de mapping complète pour éviter les appels JNI/FFI unitaires.
    - *Alternative Performance* : Le moteur C++ écrit directement le code UTF-32/16 dans la struct `RenderCommand` au lieu de l'ID interne.
- [ ] **Dart Bridge** : Mettre à jour `bridge.dart` pour lire ces infos.

### Phase 2 : Rendu Naïf (Baseline Benchmark)
**But** : Avoir un rendu visuel correct, même si lent, pour valider la logique.

- [ ] **ScorePainter** : Dans le `switch (MXML_GLYPH)`, utiliser `TextPainter` pour dessiner le caractère correspondant à l'ID.
- [ ] **Validation** : Vérifier que les clés et les notes s'affichent au bon endroit (Attention aux baselines : SMuFL a une baseline spécifique, souvent centrée ou base, différente du standard HTML).

### Phase 3 : Optimisation "Paragraph Batching"
**But** : Réduire l'overhead CPU de Flutter.

- [ ] **Grouping** : Dans `ScorePainter`, ne pas dessiner immédiatement. Collecter tous les glyphes dans une liste.
- [ ] **ParagraphBuilder** : Utiliser `ui.ParagraphBuilder` pour ajouter les glyphes avec des styles (positionnement via `addPlaceholder` ou calcul manuel des offsets).
- [ ] **Benchmark** : Comparer le temps de "Paint" avec la Phase 2.

### Phase 4 : Cache & Pre-calculation (Si nécessaire)
**But** : 0ms de layout texte à la frame.

- [ ] **Glyph Atlas** : Au chargement, générer une `ui.Image` contenant tous les glyphes utilisés.
- [ ] **DrawAtlas** : Utiliser `canvas.drawAtlas` pour dessiner des centaines de notes en 1 appel GPU.

---

## 3. Questions Techniques à résoudre

1.  **Baseline** : Comment le moteur C++ calcule-t-il la position Y ? Est-ce le centre de la note, la ligne de base, ou le coin haut-gauche ? SMuFL a des règles strictes.
2.  **Mapping** : Qui détient la vérité sur le mapping ID <-> Unicode ? Le moteur C++ semble utiliser un `mxml-glyph-registry.h`. Il faudra probablement l'exposer.
