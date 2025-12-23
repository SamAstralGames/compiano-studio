import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'piano_keyboard.dart';
// On remplace le mock local par le package réel
//import 'package:music_xml_engine/music_xml_engine.dart';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'score_painter.dart';
import '../core/bridge.dart';

import "../options/options.dart";



class ScorePage extends StatefulWidget {
  final VoidCallback onClose;
  final String? filePath; // Le chemin du fichier à afficher

  const ScorePage({super.key, required this.onClose, this.filePath});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  // FFI State
  ffi.Pointer<MXMLHandle>? _handle;
  ffi.Pointer<MXMLRenderCommandC>? _commands;
  ffi.Pointer<ffi.Size>? _countPtr;
  int _commandCount = 0;
  final MXMLBridge _bridge = MXMLBridge();


  bool _isKeyboardVisible = false;
  bool _isFocusMode = false; // Pour zoomer sur une partie du clavier
  
  String _statusMessage = "Ready";
  bool _isLoading = false;

  // Theme State
  bool _isDarkMode = false;
  double _canvasWidth = 0.0;
  double _canvasHeight = 0.0;
  double _contentHeight = 0.0;


  // Notre structure de données pour le MIDI : un Set de notes actives
  final Set<int> _activeNotes = {};
  Timer? _demoTimer;

  Duration _animationDuration = Duration.zero; // Durée dynamique (0 par défaut pour le resize)
  Timer? _animationTimer;

  // Liste des commandes de rendu générées par la librairie
  //List<RenderCommand> _renderCommands = [];

  // Benchmarks
  int _reprocessCount = 0;
  double _lastProcessTimeMs = 0.0;
  MXMLPipelineBench? _pipelineBench;
  //List<BenchLayer> _benchLayers = const [];
  
  // Options
  ffi.Pointer<MXMLOptions>? _options;
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
      MXMLBridge.initialize();
      _handle = _bridge.create();
      _countPtr = calloc<ffi.Size>();
      // Initialise les options avec le preset standard.
      //_options = _bridge.optionsCreate();
      //_bridge.optionsApplyStandard(_options!);
      //_bridge.setColorsDarkMode(_options!, _isDarkMode);
      //_reloadOptionsFromBridge();
      //_optionsReady = true;
      _statusMessage = "Engine initialized";
    } catch (e) {
      _statusMessage = "Error initializing engine: $e";
    }


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

    setState(() {
      _isLoading = true;
      _statusMessage = "Loading...";
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      //final path = _pathController.text;
      final success = _bridge.loadFile(_handle!, path);

      if (mounted) {
        setState(() {
          if (success) {
            _statusMessage = "Loaded: $path";
            //if (_lastLayoutWidth > 0) {
            if (_canvasWidth > 0) {
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
    if (_handle == null || width <= 0) return;
    
    _canvasWidth = width;

    final stopwatch = Stopwatch()..start();
    // Utilise les options si elles sont disponibles.
    //if (_options != null) {
    //  _bridge.layoutWithOptions(_handle!, width, _options!);
    //} else {
      _bridge.layout(_handle!, width);
    //}
    stopwatch.stop();
    
    _commands = _bridge.getRenderCommands(_handle!, _countPtr!);
    _commandCount = _countPtr!.value;
    _contentHeight = _bridge.getHeight(_handle!);
    
    _lastProcessTimeMs = stopwatch.elapsedMicroseconds / 1000.0;
    _reprocessCount++;
    //_updatePipelineBench();
  }
  
  @override
  void dispose() {
    _demoTimer?.cancel();
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
                child: Row(
                  children: [
                    // ZONE 1 : La Partition
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, scoreConstraints) {
                          // Calcul de la largeur disponible (moins le padding horizontal de 40)
                          final double width = scoreConstraints.maxWidth - 40.0;
                          
                          // Si la largeur change, on recalcule le layout via FFI
                          if (width > 0 && (width - _canvasWidth).abs() > 1.0) {
                            print ( "Redimensionnement width : $width height : scoreConstraints.maxHeight : ${scoreConstraints.maxHeight} " ); 
                            _canvasWidth = width;
                            _performLayout(_canvasWidth);
                          }
                          else
                          {
                            print ( "_canvasWidth : $width height : scoreConstraints.maxHeight : ${scoreConstraints.maxHeight} " ); 
                            _canvasWidth = width;
                          }
                          
                          return Container(
                            color: Colors.black12,
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: CustomPaint(
                                painter: ScorePainter(
                                  commands: _commands,
                                  commandCount: _commandCount,
                                  handle: _handle,
                                  bridge: _bridge,
                                  isDarkMode: _isDarkMode,
                                ),
                                size: Size(width, _contentHeight),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // ZONE 2 : La Barre Latérale Droite
                    Container(
                      width: 280,
                      color: Colors.blueGrey.shade800,
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const Spacer(),
                          
                          // Bouton DEMO MIDI
                          Center(
                            child: OutlinedButton(
                              onPressed: _toggleDemoPlay,
                              child: Text(_demoTimer != null ? "Stop Demo" : "Test MIDI (Random)"),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Bouton FOCUS MODE
                          Center(
                            child: TextButton.icon(
                              onPressed: () => setState(() => _isFocusMode = !_isFocusMode),
                              icon: Icon(_isFocusMode ? Icons.zoom_out : Icons.zoom_in),
                              label: Text(_isFocusMode ? "Vue Complète" : "Vue Zoomée"),
                            ),
                          ),

                          // Bouton pour afficher/cacher le clavier
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _animationTimer?.cancel(); // Annule le timer précédent si on clique vite
                                setState(() {
                                  _animationDuration = const Duration(milliseconds: 300); // On active l'anim
                                  _isKeyboardVisible = !_isKeyboardVisible;
                                });

                                // On désactive l'anim une fois finie pour que le futur resize soit instantané
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
                        ],
                      ),
                    ),
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