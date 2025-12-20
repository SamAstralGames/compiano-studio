import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import '../core/bridge.dart';
import 'score_painter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // FFI State
  ffi.Pointer<MXMLHandle>? _handle;
  ffi.Pointer<MXMLRenderCommandC>? _commands;
  ffi.Pointer<ffi.Size>? _countPtr;
  int _commandCount = 0;
  final MXMLBridge _bridge = MXMLBridge();

  // UI State
  final TextEditingController _pathController = TextEditingController(text: "native/mxmlconverter/test-simple.xml");
  double _sidebarWidth = 250.0;
  String _statusMessage = "Ready";
  bool _isLoading = false;
  
  // Theme State
  bool _isDarkMode = false;
  
  // Layout State
  double _lastLayoutWidth = 0.0;

  @override
  void initState() {
    super.initState();
    try {
      MXMLBridge.initialize();
      _handle = _bridge.create();
      _countPtr = calloc<ffi.Size>();
      _statusMessage = "Engine initialized";
    } catch (e) {
      _statusMessage = "Error initializing engine: $e";
    }
  }

  @override
  void dispose() {
    if (_handle != null) {
      _bridge.destroy(_handle!);
    }
    if (_countPtr != null) {
      calloc.free(_countPtr!);
    }
    super.dispose();
  }

  void _loadFile() {
    if (_handle == null) return;

    setState(() {
      _isLoading = true;
      _statusMessage = "Loading...";
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      final path = _pathController.text;
      final success = _bridge.loadFile(_handle!, path);

      if (mounted) {
        setState(() {
          if (success) {
            _statusMessage = "Loaded: $path";
            // On force le layout avec la largeur actuelle connue ou une valeur par défaut
            // Le LayoutBuilder le fera aussi, mais ça initialise l'état.
            if (_lastLayoutWidth > 0) {
               _performLayout(_lastLayoutWidth);
            }
          } else {
            _statusMessage = "Failed to load: $path";
          }
          _isLoading = false;
        });
      }
    });
  }

  void _performLayout(double width) {
    if (_handle == null || width <= 0) return;
    
    // Éviter de recalculer pour rien
    // if ((width - _lastLayoutWidth).abs() < 1.0) return;
    
    // On met à jour _lastLayoutWidth immédiatement pour éviter la réentrance si on est dans un build ?
    // Non, ici on est appelé par le LayoutBuilder ou Load.
    _lastLayoutWidth = width;

    _bridge.layout(_handle!, width);
    
    _commands = _bridge.getRenderCommands(_handle!, _countPtr!);
    _commandCount = _countPtr!.value;
    
    // Pas de setState ici si on est appelé pendant le build du LayoutBuilder !
    // Si c'est via LayoutBuilder, on doit juste mettre à jour les variables.
    // Mais Flutter n'aime pas qu'on modifie l'état pendant le build.
    // Astuce: LayoutBuilder est un builder. On peut calculer des choses mais pour que l'UI se mette à jour...
    // Si on modifie _commands, le CustomPainter le verra s'il est reconstruit.
    
    // Exception: Si on appelle _performLayout depuis _loadFile, on veut setState.
    // Si on appelle depuis LayoutBuilder, on ne veut PAS setState.
  }
  
  void _downloadSvg() {
    if (_handle == null) return;
    final outPath = "${_pathController.text}.svg";
    final success = _bridge.writeSvgToFile(_handle!, outPath);
    setState(() {
        _statusMessage = success ? "SVG saved to $outPath" : "Failed to save SVG";
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final fgColor = _isDarkMode ? Colors.white : Colors.black;
    final sidebarColor = _isDarkMode ? const Color(0xFF2D2D2D) : Colors.grey[200];
    final sidebarTextColor = _isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: _sidebarWidth,
            child: Container(
              color: sidebarColor,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Controls", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: sidebarTextColor)),
                  const SizedBox(height: 20),
                  
                  // Theme Toggle
                  Row(
                    children: [
                      Text("Dark Mode", style: TextStyle(color: sidebarTextColor)),
                      const Spacer(),
                      Switch(
                        value: _isDarkMode,
                        onChanged: (val) {
                          setState(() {
                            _isDarkMode = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _pathController,
                    style: TextStyle(color: sidebarTextColor),
                    decoration: InputDecoration(
                      labelText: "XML File Path",
                      labelStyle: TextStyle(color: sidebarTextColor.withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: sidebarTextColor.withOpacity(0.3))),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: sidebarTextColor)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _loadFile,
                      icon: const Icon(Icons.file_open),
                      label: const Text("Load & Render"),
                    ),
                  ),
                  const SizedBox(height: 10),
                   SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _downloadSvg,
                      icon: const Icon(Icons.download),
                      label: const Text("Download SVG"),
                    ),
                  ),
                  const Spacer(),
                  const Divider(),
                  Text("Status: $_statusMessage", style: TextStyle(fontSize: 12, color: sidebarTextColor.withOpacity(0.7))),
                ],
              ),
            ),
          ),
          // Divider
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (details) {
              setState(() {
                _sidebarWidth += details.delta.dx;
                if (_sidebarWidth < 100) _sidebarWidth = 100;
                if (_sidebarWidth > 500) _sidebarWidth = 500;
              });
            },
            child: Container(
              width: 8,
              color: _isDarkMode ? Colors.black : Colors.grey[400],
              child: Center(
                child: Icon(Icons.drag_handle, size: 12, color: sidebarTextColor),
              ),
            ),
          ),
          // Main Canvas Area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Gestion du Layout automatique
                if (_handle != null && constraints.maxWidth > 0 && (constraints.maxWidth - _lastLayoutWidth).abs() > 1.0) {
                  // On doit différer l'exécution du layout pour ne pas bloquer le build actuel
                  // ou modifier l'état pendant le build.
                  // Utilisons addPostFrameCallback ou exécutons la logique "pure" C++ sans setState
                  // Puis forçons le repaint.
                  
                  // Option: Exécuter le C++ layout ici (c'est synchrone et rapide pour peu de pages)
                  // _bridge.layout(_handle!, constraints.maxWidth);
                  // _lastLayoutWidth = constraints.maxWidth;
                  // _commands = ...
                  // _commandCount = ...
                  
                  // MAIS: Si on fait ça, il faut s'assurer que le CustomPainter utilise les nouvelles valeurs.
                  // Comme CustomPainter prend les pointeurs, ça devrait aller.
                  
                  // Faisons-le proprement:
                  _lastLayoutWidth = constraints.maxWidth;
                  _bridge.layout(_handle!, _lastLayoutWidth);
                  _commands = _bridge.getRenderCommands(_handle!, _countPtr!);
                  _commandCount = _countPtr!.value;
                  
                  // Pas de setState, mais on retourne un widget qui utilise ces nouvelles valeurs.
                }

                return ClipRect( // Clip pour ne pas dessiner hors de la zone
                  child: Container(
                    color: bgColor,
                    child: CustomPaint(
                      painter: ScorePainter(
                        commands: _commands,
                        commandCount: _commandCount,
                        handle: _handle,
                        bridge: _bridge,
                        isDarkMode: _isDarkMode, // Passer le thème au painter
                      ),
                      size: Size.infinite, // Remplit tout l'espace disponible
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
