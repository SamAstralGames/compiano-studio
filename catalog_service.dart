import 'models/certified_score.dart';

class CatalogService {
  // Simulation d'une base de données locale ou distante
  static final List<CertifiedScore> _catalog = [
    CertifiedScore(
      id: 'bach_prelude_1',
      title: 'Prélude No. 1 en Do Majeur (WTC I)',
      composer: 'J.S. Bach',
      henleLevel: 3,
      technicalFocus: [CortotTag.mobility, CortotTag.thumbPassage],
      assetPath: 'assets/scores/bach_prelude_1.musicxml',
      isPremium: false, // Produit d'appel (Gratuit)
    ),
    CertifiedScore(
      id: 'chopin_nocturne_9_2',
      title: 'Nocturne Op. 9 No. 2',
      composer: 'Frédéric Chopin',
      henleLevel: 7,
      technicalFocus: [CortotTag.polyphony, CortotTag.extension, CortotTag.leaps],
      assetPath: 'assets/scores/chopin_nocturne_9_2.musicxml',
      isPremium: true, // Produit Premium (Coach H24 inclus)
    ),
  ];

  /// Récupère tout le catalogue (pour la page "Bibliothèque")
  Future<List<CertifiedScore>> getCatalog() async {
    // Simulation délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    return _catalog;
  }

  /// Filtre par difficulté pour le moteur de recommandation
  List<CertifiedScore> getRecommendationsByLevel(int userLevel) {
    // On propose des morceaux du niveau de l'élève ou +1 (Challenge)
    return _catalog.where((s) => s.henleLevel >= userLevel && s.henleLevel <= userLevel + 1).toList();
  }

  /// Vérifie si un fichier est certifié (pour activer l'IA)
  bool isCertified(String filePath) {
    // Dans une vraie app, on vérifierait le hash du fichier ou l'ID
    return _catalog.any((s) => s.assetPath == filePath);
  }
}