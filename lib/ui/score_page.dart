import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'piano_keyboard.dart';
// On remplace le mock local par le package réel
//import 'package:music_xml_engine/music_xml_engine.dart';
import 'score_painter.dart';
import '../logic/score/score_controller.dart';
import '../logic/play/play_controller.dart';
import 'widgets/console.dart';
import 'widgets/front_buffer.dart';

class ScorePage extends StatefulWidget {
  final VoidCallback onClose;
  final ScoreController controller;
  final PlayController playController;
  final String? filePath; // Le chemin du fichier à afficher

  const ScorePage({
    super.key,
    required this.onClose,
    required this.controller,
    required this.playController,
    this.filePath,
  });

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  // Controleur partage pour le rendu et la console.
  ScoreController get _controller => widget.controller;
  PlayController get _playController => widget.playController;


  bool _isKeyboardVisible = false;
  bool _isFocusMode = false; // Pour zoomer sur une partie du clavier
  
  String _statusMessage = "Ready";
  bool _isLoading = false;

  // Theme State
  bool _isDarkMode = false;
  double _canvasWidth = 0.0;
  int _leftbarTabIndex = 0;
  static const Duration _leftbarAnimationDuration = Duration(milliseconds: 250);


  // Notre structure de données pour le MIDI : un Set de notes actives
  final Set<int> _activeNotes = {};
  Timer? _demoTimer;
  final ScrollController _rightbarScrollController = ScrollController();
  final TextEditingController _rightbarInputController = TextEditingController();
  final FocusNode _rightbarInputFocusNode = FocusNode();

  Duration _animationDuration = Duration.zero; // Durée dynamique (0 par défaut pour le resize)
  Timer? _animationTimer;

  // Liste des commandes de rendu générées par la librairie
  //List<RenderCommand> _renderCommands = [];

  // Benchmarks
  int _reprocessCount = 0;
  double _lastProcessTimeMs = 0.0;
  //List<BenchLayer> _benchLayers = const [];
  
  // Memoise les dernieres valeurs loggees pour eviter le spam.
  static double? _lastLoggedCanvasWidth;
  static double? _lastLoggedContentHeight;
//   bool _optionsReady = false;
//   final Map<String, bool> _boolValues = {};
//   final Map<String, int> _intValues = {};
//   final Map<String, double> _doubleValues = {};
//   final Map<String, String> _stringValues = {};
//   final Map<String, String> _stringListValues = {};
//   final Map<String, TextEditingController> _textControllers = {};
//   final Map<String, FocusNode> _focusNodes = {};
//   final Map<String, String> _previousTextValues = {};
//   late final List<OptionSection> _optionSections = _buildOptionSections();

  @override
  void initState() {
    super.initState();

    try {
      // Informe si le controleur partage est pret.
      if (_controller.ready) {
        _statusMessage = "Engine initialized";
      } else {
        _statusMessage = "Engine initialization failed";
      }
    } catch (e) {
      _statusMessage = "Error initializing engine: $e";
    }

    // Initialise l'etat et la transparence de la leftbar.
    _controller.setLeftbarOpen(true);
    _controller.setLeftbarOpacity(0.5);
    _controller.setLeftbarWidthRatio(0.2);

    // Scrolle la console rightbar quand une nouvelle sortie arrive.
    _playController.consoleLines.addListener(_scrollRightbarConsoleToBottom);

    //_loadScore();
  }

  @override
  void didUpdateWidget(ScorePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si le fichier change, on recharge
    if (oldWidget.filePath != widget.filePath) {
      _loadScore();
    }
  }

  void _loadScore() {
    // Si aucun fichier n'est sélectionné, on peut charger un exemple ou rien du tout
    final path = widget.filePath ?? "dummy_content.xml";
    _logLoadStep('start path=$path');

    setState(() {
      _isLoading = true;
      _statusMessage = "Loading...";
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      //final path = _pathController.text;
      _logLoadStep('calling loadFile path=$path');
      final success = _controller.loadFile(path);
      _logLoadStep('loadFile done success=$success');

      if (mounted) {
        setState(() {
          if (success) {
            _statusMessage = "Loaded: $path";
            //if (_lastLayoutWidth > 0) {
            if (_canvasWidth > 0) {
               _logLoadStep('calling performLayout width=$_canvasWidth');
               _performLayout(_canvasWidth);
            }
          } else {
            _statusMessage = "Failed to load: $path";
          }
          _isLoading = false;
        });
      }
    });

    //_renderCommands = MusicXmlEngine.parse(path);
    //setState(() {});
  }

  void _performLayout(double width) {
    // Stoppe si le handle n'est pas pret ou largeur invalide.
    if (!_controller.ready || width <= 0) return;
    
    _canvasWidth = width;
    _logLoadStep('performLayout start width=$_canvasWidth');

    final stopwatch = Stopwatch()..start();
    // Utilise le controleur partage pour lancer le layout.
    _controller.layout(width: width);
    stopwatch.stop();
    
    _lastProcessTimeMs = stopwatch.elapsedMicroseconds / 1000.0;
    _reprocessCount++;
    //_updatePipelineBench();
  }

  // Log les etapes du chargement sans boucle.
  void _logLoadStep(String message) {
    if (!kDebugMode) return;
    debugPrint('[ScorePage] load $message');
  }

  // Log des contraintes de rendu sans spam.
  void _logPaintSize(double width, double height) {
    if (!kDebugMode) return;

    if (_lastLoggedCanvasWidth == width && _lastLoggedContentHeight == height) {
      return;
    }

    _lastLoggedCanvasWidth = width;
    _lastLoggedContentHeight = height;
    debugPrint('[ScorePage] paintSize width=$width height=$height');
  }
  
  @override
  void dispose() {
    _demoTimer?.cancel();
    _playController.consoleLines.removeListener(_scrollRightbarConsoleToBottom);
    _rightbarScrollController.dispose();
    _rightbarInputController.dispose();
    _rightbarInputFocusNode.dispose();
    super.dispose();
  }

  // Fonction pour simuler du MIDI (Demo)
  void _toggleDemoPlay() {
    if (_demoTimer != null) {
      _demoTimer?.cancel();
      _demoTimer = null;
      setState(() => _activeNotes.clear());
    } else {
      _demoTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        setState(() {
          _activeNotes.clear();
          // Ajoute 1 à 3 notes aléatoires entre 40 et 80
          final random = Random();
          int count = random.nextInt(3) + 1;
          for(int i=0; i<count; i++) {
            _activeNotes.add(40 + random.nextInt(40));
          }
        });
      });
    }
  }

  // Bascule l'etat de la leftbar via le controller.
  void _toggleLeftbar() {
    _controller.toggleLeftbar();
  }

  // Met a jour la transparence de la leftbar via le controller.
  void _updateLeftbarOpacity(double opacity) {
    _controller.setLeftbarOpacity(opacity);
  }

  // Met a jour la largeur de la leftbar via le controller.
  void _updateLeftbarWidth(double delta, double maxWidth) {
    // Evite un calcul invalide si la largeur dispo est nulle.
    if (maxWidth <= 0) return;
    final currentRatio = _controller.leftbarWidthRatio.value;
    final nextRatio = currentRatio + (delta / maxWidth);
    _controller.setLeftbarWidthRatio(nextRatio);
  }

  // Envoie une commande depuis la rightbar vers le PlayController.
  void _submitRightbarCommand(String line) {
    _playController.executeCommand(line);
    _rightbarInputController.clear();
    _rightbarInputFocusNode.requestFocus();
  }

  // Scrolle la console rightbar en bas apres ajout.
  void _scrollRightbarConsoleToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Evite le scroll si le controleur n'est pas attache.
      if (!_rightbarScrollController.hasClients) {
        return;
      }
      _rightbarScrollController.jumpTo(
        _rightbarScrollController.position.maxScrollExtent,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900, // Fond sombre pour le contraste
      appBar: AppBar(
        title: const Text('Partition - Nocturne Op. 9 No. 2'),
        backgroundColor: Colors.black26,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward),
          onPressed: widget.onClose, // Pour faire redescendre le menu
          tooltip: "Fermer la partition",
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 1. Déterminer la plage de notes
          final int firstKey = _isFocusMode ? 48 : 21;
          final int lastKey = _isFocusMode ? 84 : 108;

          // 2. Calculer le nombre de touches blanches visibles
          int whiteKeyCount = 0;
          for (int i = firstKey; i <= lastKey; i++) {
            if (!PianoKeyboard.isBlackKey(i)) whiteKeyCount++;
          }

          // 3. Calculer la hauteur idéale pour garder un ratio constant (ex: 1:4.5)
          // Largeur d'une touche = Largeur écran / Nombre de touches
          final double keyWidth = constraints.maxWidth / whiteKeyCount;
          final double keyboardHeight = keyWidth * 4.5;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Contenu principal (Partition + Barre de droite)
              AnimatedPadding(
                duration: _animationDuration,
                curve: Curves.easeInOut,
                padding: EdgeInsets.only(bottom: _isKeyboardVisible ? keyboardHeight : 0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ZONE 1 : La Partition (plein ecran)
                    LayoutBuilder(
                      builder: (context, scoreConstraints) {
                        // Calcul de la largeur disponible (moins le padding horizontal de 40)
                        final double width = scoreConstraints.maxWidth - 40.0;
                        
                        // On informe le controller de la taille disponible en permanence.
                        _controller.updateCanvasSize(width);

                        // Si la largeur change, on recalcule le layout via FFI
                        if (width > 0 && (width - _canvasWidth).abs() > 1.0) {
                          print ( "Redimensionnement width : $width height : scoreConstraints.maxHeight : ${scoreConstraints.maxHeight} " ); 
                          _canvasWidth = width;
                          _performLayout(_canvasWidth);
                        }
                        else
                        {
                          // print ( "_canvasWidth : $width height : scoreConstraints.maxHeight : ${scoreConstraints.maxHeight} " ); 
                          _canvasWidth = width;
                        }
                        
                        return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20.0),
                          child: ValueListenableBuilder<int>(
                            valueListenable: _controller.renderVersion,
                            builder: (context, _, __) {
                              // Met a jour la taille du canvas quand le buffer change.
                              final contentHeight = _controller.contentHeight;
                              final parentHeight = scoreConstraints.maxHeight;
                              final paintHeight = contentHeight > 0 ? contentHeight : parentHeight;
                              _logPaintSize(width, paintHeight);
                              return SingleChildScrollView(
                                child: CustomPaint(
                                  painter: ScorePainter(
                                    commands: _controller.renderCommands,
                                    repaint: _controller.renderVersion,
                                    isDarkMode: _isDarkMode,
                                  ),
                                  size: Size(width, paintHeight),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    // ZONE 2 : Rightbar overlay (sans redimensionner la partition)
                    _buildLeftbarOverlay(context, constraints.maxWidth, constraints.maxHeight),
                  ],
                ),
              ),
              // Le clavier qui slide depuis le bas
              AnimatedPositioned(
                duration: _animationDuration, //const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: _isKeyboardVisible ? 0 : -keyboardHeight,
                left: 0,
                right: 0,
                height: keyboardHeight,
                child: PianoKeyboard(
                  activeNotes: _activeNotes,
                  firstKey: firstKey,
                  lastKey: lastKey,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Construit la leftbar overlay et ses onglets.
  Widget _buildLeftbarOverlay(BuildContext context, double maxWidth, double maxHeight) {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.leftbarOpen,
      builder: (context, isOpen, _) {
        return ValueListenableBuilder<double>(
          valueListenable: _controller.leftbarWidthRatio,
          builder: (context, widthRatio, __) {
            final double leftbarWidth = maxWidth * widthRatio;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: _leftbarAnimationDuration,
                  curve: Curves.easeInOut,
                  right: isOpen ? 0 : -leftbarWidth,
                  top: 0,
                  bottom: 0,
                  child: ValueListenableBuilder<double>(
                    valueListenable: _controller.leftbarOpacity,
                    builder: (context, opacity, ___) {
                      return AnimatedOpacity(
                        duration: _leftbarAnimationDuration,
                        opacity: opacity,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              color: Colors.transparent,
                              child: SizedBox(
                                height: maxHeight,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildLeftbarTab(context, label: "Statistics", tabIndex: 0),
                                        const SizedBox(height: 10),
                                        _buildLeftbarTab(context, label: "Debug", tabIndex: 1),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: leftbarWidth,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade800,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(16),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(24.0, 24.0, 16.0, 24.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: _leftbarTabIndex == 0
                                          ? _buildStatisticsContent(context)
                                          : _buildDebugContent(context),
                                    ),
                                  ),
                                  // Poignee de redimensionnement.
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onHorizontalDragUpdate: (details) {
                                        _updateLeftbarWidth(-details.delta.dx, maxWidth);
                                      },
                                      child: SizedBox(
                                        width: kMinInteractiveDimension,
                                        height: maxHeight,
                                        child: const MouseRegion(
                                          cursor: SystemMouseCursors.resizeLeftRight,
                                          child: SizedBox.expand(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Bouton pour replier la leftbar.
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: IconButton(
                                      onPressed: _toggleLeftbar,
                                      icon: const Icon(Icons.chevron_right, color: Colors.white),
                                      tooltip: "Replier la rightbar",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Construit un onglet vertical pour la leftbar.
  Widget _buildLeftbarTab(BuildContext context, {required String label, required int tabIndex}) {
    final bool isSelected = _leftbarTabIndex == tabIndex;
    return Material(
      color: Colors.blueGrey.shade700,
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
      child: InkWell(
        onTap: () {
          // Ouvre la leftbar et selectionne l'onglet.
          _controller.setLeftbarOpen(true);
          setState(() => _leftbarTabIndex = tabIndex);
        },
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Contenu du panneau "Statistics".
  List<Widget> _buildStatisticsContent(BuildContext context) {
    return [
      Text(
        "Informations",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
      ),
      const Divider(color: Colors.white24, height: 30),
      _buildInfoItem("Titre", "Nocturne Op. 9 No. 2"),
      _buildInfoItem("Compositeur", "Frédéric Chopin"),
      _buildInfoItem("Année", "1832"),
      _buildInfoItem("Difficulté", "Avancé (Henle 7)"),
      _buildInfoItem("Tonalité", "Mi bémol majeur"),
    ];
  }

  // Contenu du panneau "Debug".
  List<Widget> _buildDebugContent(BuildContext context) {
    return [
      Text(
        "Debug",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
      ),
      const Divider(color: Colors.white24, height: 30),
      Center(
        child: OutlinedButton(
          onPressed: _toggleDemoPlay,
          child: Text(_demoTimer != null ? "Stop Demo" : "Test MIDI (Random)"),
        ),
      ),
      const SizedBox(height: 10),
      Center(
        child: TextButton.icon(
          onPressed: () => setState(() => _isFocusMode = !_isFocusMode),
          icon: Icon(_isFocusMode ? Icons.zoom_out : Icons.zoom_in),
          label: Text(_isFocusMode ? "Vue Complète" : "Vue Zoomée"),
        ),
      ),
      const SizedBox(height: 10),
      Center(
        child: ElevatedButton.icon(
          onPressed: () {
            _animationTimer?.cancel(); // Annule le timer precedent si on clique vite
            setState(() {
              _animationDuration = const Duration(milliseconds: 300); // On active l'anim
              _isKeyboardVisible = !_isKeyboardVisible;
            });

            // On desactive l'anim une fois finie pour que le futur resize soit instantane
            _animationTimer = Timer(const Duration(milliseconds: 300), () {
            if (mounted) {
                setState(() => _animationDuration = Duration.zero);
            }
            });

          },
          icon: Icon(_isKeyboardVisible ? Icons.keyboard_hide : Icons.keyboard),
          label: Text(_isKeyboardVisible ? "Cacher le clavier" : "Afficher le clavier"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueGrey.shade700,
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(
        "Transparence",
        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white70),
      ),
      ValueListenableBuilder<double>(
        valueListenable: _controller.leftbarOpacity,
        builder: (context, opacity, _) {
          return Slider(
            value: opacity,
            min: 0.0,
            max: 1.0,
            onChanged: _updateLeftbarOpacity,
          );
        },
      ),
      const SizedBox(height: 12),
      Expanded(
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<List<String>>(
                valueListenable: _playController.consoleLines,
                builder: (context, outputLines, _) {
                  return ConsoleWidget(
                    outputLines: outputLines,
                    scrollController: _rightbarScrollController,
                    inputController: _rightbarInputController,
                    focusNode: _rightbarInputFocusNode,
                    onSubmitted: _submitRightbarCommand,
                    onSend: () => _submitRightbarCommand(_rightbarInputController.text),
                    padding: EdgeInsets.zero,
                    lineSpacing: 4.0,
                    inputSpacing: 8.0,
                    hintText: "Enter command",
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ValueListenableBuilder<List<String>>(
                valueListenable: _playController.frontBufferLines,
                builder: (context, frontBufferLines, _) {
                  return FrontBufferWidget(
                    lines: frontBufferLines,
                    title: "FrontBuffer",
                    padding: EdgeInsets.zero,
                    lineSpacing: 4.0,
                    // onWidthChanged: _playController.updateLayoutWidth,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ];
  }

  // Petit helper pour créer les lignes d'infos proprement
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

/*
class ScorePainter extends CustomPainter {
  //final List<RenderCommand> commands;

  ScorePainter(this.commands);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    // 1. Fond blanc
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // 2. Exécution des commandes de rendu
    paint.color = Colors.black;
    paint.strokeWidth = 1.5;
    
    for (var command in commands) {
      command.render(canvas, paint, size);
    }
  }

  @override
  bool shouldRepaint(covariant ScorePainter oldDelegate) {
    return oldDelegate.commands != commands;
  }
}*/
