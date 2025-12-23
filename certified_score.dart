enum CortotTag {
  mobility,      // I. Mobilité Digitale
  thumbPassage,  // II. Passage du Pouce
  polyphony,     // III. Polyphonie
  extension,     // IV. Extension
  leaps,         // V. Grand Saut
}

class CertifiedScore {
  final String id;
  final String title;
  final String composer;
  
  /// Niveau de difficulté Henle (1-9)
  final int henleLevel;
  
  /// Les difficultés techniques principales validées par l'équipe pédagogique
  final List<CortotTag> technicalFocus;
  
  /// Chemin vers le fichier MusicXML certifié (avec doigtés corrects)
  final String assetPath;
  
  /// Si true, nécessite un abonnement "Academy"
  final bool isPremium;

  const CertifiedScore({
    required this.id,
    required this.title,
    required this.composer,
    required this.henleLevel,
    required this.technicalFocus,
    required this.assetPath,
    this.isPremium = true,
  });

  /// Retourne une description lisible pour l'UI
  String get difficultyLabel => 'Henle $henleLevel';
}