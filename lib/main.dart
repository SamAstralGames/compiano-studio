import 'dart:async';
import 'package:flutter/material.dart';
import 'ui/score_page.dart';
import 'ui/library_page.dart';
import 'ui/debug_page.dart';
import 'ui/settings/settings_page.dart';
import 'ui/theme/app_theme.dart';
import 'ui/theme/theme_controller.dart';
import 'logic/score/score_controller.dart';
import 'logic/play/play_controller.dart';


void main() {
  runApp(const PianoApp());
}

class PianoApp extends StatefulWidget {
  const PianoApp({super.key});

  @override
  State<PianoApp> createState() => _PianoAppState();
}

class _PianoAppState extends State<PianoApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeSelection>(
      valueListenable: _themeController.selection,
      builder: (context, selection, _) {
        final themeMode = _resolveThemeMode(selection);
        final themeData = _resolveThemeData(selection);
        return MaterialApp(
          title: 'Piano App',
          debugShowCheckedModeBanner: false, // Enlève le bandeau "DEBUG"
          theme: themeData,
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          home: MainShell(themeController: _themeController),
        );
      },
    );
  }

  // Resout le ThemeMode a partir de la selection.
  ThemeMode _resolveThemeMode(AppThemeSelection selection) {
    switch (selection) {
      case AppThemeSelection.system:
        return ThemeMode.system;
      case AppThemeSelection.light:
        return ThemeMode.light;
      case AppThemeSelection.dark:
        return ThemeMode.dark;
      case AppThemeSelection.custom:
        return ThemeMode.light;
    }
  }

  // Resout le ThemeData a partir de la selection.
  ThemeData _resolveThemeData(AppThemeSelection selection) {
    switch (selection) {
      case AppThemeSelection.system:
        return AppTheme.light();
      case AppThemeSelection.light:
        return AppTheme.light();
      case AppThemeSelection.dark:
        return AppTheme.dark();
      case AppThemeSelection.custom:
        return AppTheme.custom();
    }
  }
}

class MainShell extends StatefulWidget {
  final ThemeController themeController;

  const MainShell({super.key, required this.themeController});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  bool _isScoreOpen = false; // État pour savoir si la partition est visible
  final double _bottomMenuHeight = 60.0; // Hauteur de notre future barre de menu
  final double _sideMenuWidth = 72.0; // Largeur du menu latéral
  Duration _animationDuration = Duration.zero; // Durée dynamique (0 par défaut pour le resize)
  Timer? _animationTimer;
  String? _currentScorePath; // Le fichier actuellement ouvert
  late final ScoreController _scoreController;
  late final PlayController _playController;

  @override
  void initState() {
    super.initState();
    // Controleur partage pour la partition et la console debug.
    _scoreController = ScoreController();
    // Controleur de lecture qui pilote l'ouverture des morceaux.
    _playController = PlayController(scoreController: _scoreController);
    _playController.playRequests.addListener(_handlePlayRequest);
  }

  @override
  void dispose() {
    // Libere les ressources FFI au moment de quitter l'app.
    _scoreController.dispose();
    _playController.playRequests.removeListener(_handlePlayRequest);
    _playController.dispose();
    super.dispose();
  }

  // Nouvelle méthode pour ouvrir un score spécifique
  void _openScore(String path) {
    _animationTimer?.cancel();
    setState(() {
      _currentScorePath = path;
      _animationDuration = const Duration(milliseconds: 600);
      _isScoreOpen = true;
    });
    
    _animationTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _animationDuration = Duration.zero);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // On définit les pages ici pour pouvoir passer le callback onOpenScore
    final List<Widget> pages = [
      PlaceholderPage(title: 'Home (Dashboard)', color: Colors.red, onOpenScore: _toggleScore),
      PlaceholderPage(title: 'Exercices (Cursus)', color: Colors.orange, onOpenScore: _toggleScore),
      LibraryPage(playController: _playController), // On remplace le placeholder par la vraie bibliothèque
      SettingsPage(themeController: widget.themeController), //const PlaceholderPage(title: 'Settings', color: Colors.blue),
      DebugPage(playController: _playController),
      //const PlaceholderPage(title: 'Debug', color: Colors.grey),
    ];

    // On utilise LayoutBuilder pour connaître la hauteur de l'écran et calculer le slide exact
    return LayoutBuilder(builder: (context, constraints) {
      // Calcul de l'offset : On monte de tout l'écran MOINS la hauteur du menu
      final double slideOffset = _isScoreOpen
          ? -1.0 + (_bottomMenuHeight / constraints.maxHeight)
          : 0.0;
      
      final double height = constraints.maxHeight;
      final double width = constraints.maxWidth;

      return Scaffold(
        // Stack permet de superposer la Partition (fond) et le Menu (devant)
        body: Stack(
          children: [
            // COUCHE 1 : La Partition (en dessous)
            Positioned.fill(
              child: ScorePage(
                controller: _scoreController,
                playController: _playController,
                onClose: _toggleScore,
                filePath: _currentScorePath, // On passe le fichier sélectionné
              ),
            ),

            // COUCHE 2 : L'Interface Principale
            AnimatedSlide(
              duration: _animationDuration,
              curve: Curves.easeInOutCubic,
              offset: Offset(0, slideOffset),
              child: Scaffold(
                backgroundColor: Colors.transparent, // Important pour voir la partition derrière
                body: Stack(
                  children: [
                    // 1. LE CONTENU (Avec un padding animé)
                    AnimatedPadding(
                      duration: _animationDuration,
                      curve: Curves.easeInOutCubic,
                      // Si ouvert : marge en bas (pour le menu). Si fermé : marge à gauche.
                      padding: _isScoreOpen
                          ? EdgeInsets.only(bottom: _bottomMenuHeight)
                          : EdgeInsets.only(left: _sideMenuWidth),
                      child: Container(
                        // On met un fond opaque au contenu pour cacher la partition quand on est dessus
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: pages[_selectedIndex],
                      ),
                    ),

                    // 2. LE FOND DU MENU (Morphing : Barre Latérale <-> Barre du Bas)
                    AnimatedPositioned(
                      duration: _animationDuration,
                      curve: Curves.easeInOutCubic,
                      left: 0,
                      top: _isScoreOpen ? height - _bottomMenuHeight : 0,
                      width: _isScoreOpen ? width : _sideMenuWidth,
                      height: _isScoreOpen ? _bottomMenuHeight : height,
                      child: Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        // Petite ligne de séparation esthétique
                        child: Align(
                          alignment: _isScoreOpen ? Alignment.topCenter : Alignment.centerRight,
                          child: Container(
                            color: Theme.of(context).dividerColor,
                            width: _isScoreOpen ? double.infinity : 1,
                            height: _isScoreOpen ? 1 : double.infinity,
                          ),
                        ),
                      ),
                    ),

                    // 3. LES ICÔNES FLOTTANTES (C'est ici que la magie opère)
                    ..._buildFloatingIcons(width, height),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Génère la liste des icônes animées
  List<Widget> _buildFloatingIcons(double width, double height) {
    final icons = [Icons.home, Icons.school, Icons.music_note, Icons.settings, Icons.bug_report];
    final labels = ["Home", "Exercices", "Jouer", "Settings", "Debug"];
    
    List<Widget> widgets = [];

    for (int i = 0; i < icons.length; i++) {
      // --- Calcul des positions ---
      
      // Position Verticale (Mode Normal - Gauche)
      double vLeft = 0;
      double vTop = 100.0 + (i * 80.0); // On les espace verticalement
      double vWidth = _sideMenuWidth;

      // Position Horizontale (Mode Partition - Bas)
      // On divise la largeur par le nombre d'icônes + 1 (pour le bouton toggle)
      double hWidth = width / (icons.length + 1); 
      double hLeft = i * hWidth;
      double hTop = height - _bottomMenuHeight;

      widgets.add(
        AnimatedPositioned(
          duration: _animationDuration,
          curve: Curves.easeInOutCubic,
          // Si ouvert -> Position H, Sinon -> Position V
          left: _isScoreOpen ? hLeft : vLeft,
          top: _isScoreOpen ? hTop : vTop,
          width: _isScoreOpen ? hWidth : vWidth,
          height: _bottomMenuHeight,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() => _selectedIndex = i);
                if (_isScoreOpen) {
                  _toggleScore(); // Ferme la partition si elle est ouverte
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[i],
                    color: _selectedIndex == i 
                        ? Theme.of(context).colorScheme.primary 
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  // Le texte disparaît en mode horizontal pour gagner de la place
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isScoreOpen ? 0.0 : 1.0,
                    child: _isScoreOpen 
                        ? const SizedBox() 
                        : Text(labels[i], style: const TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Ajout du bouton "Toggle" (Flèche) à la fin
    widgets.add(
      AnimatedPositioned(
        duration: _animationDuration,
        curve: Curves.easeInOutCubic,
        // Vertical : En bas à gauche. Horizontal : En bas à droite.
        left: _isScoreOpen ? width - (width / (icons.length + 1)) : 0,
        top: height - _bottomMenuHeight,
        width: _isScoreOpen ? (width / (icons.length + 1)) : _sideMenuWidth,
        height: _bottomMenuHeight,
        child: IconButton(
          icon: Icon(_isScoreOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
          onPressed: _toggleScore,
        ),
      )
    );

    return widgets;
  }

  void _toggleScore() {
    _animationTimer?.cancel(); // Annule le timer précédent si on clique vite
    setState(() {
      _animationDuration = const Duration(milliseconds: 600); // On active l'anim
      _isScoreOpen = !_isScoreOpen;
    });
    
    // On désactive l'anim une fois finie pour que le futur resize soit instantané
    _animationTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _animationDuration = Duration.zero);
      }
    });
  }

  // Reagit aux demandes de lecture du PlayController.
  void _handlePlayRequest() {
    final request = _playController.playRequests.value;
    // On ignore l'evenement si la requete est absente.
    if (request == null) return;
    _openScore(request.path);
  }
}

// Widget temporaire pour visualiser les pages
class PlaceholderPage extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback? onOpenScore; // Callback optionnel pour ouvrir la partition

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.color,
    this.onOpenScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.1), // Fond légèrement coloré
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (onOpenScore != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onOpenScore,
                icon: const Icon(Icons.piano),
                label: const Text("Ouvrir un morceau (Demo)"),
              )
            ]
          ],
        ),
      ),
    );
  }
}
