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

    // Petit délai pour laisser l'UI se mettre à jour
    Future.delayed(const Duration(milliseconds: 50), () {
      final path = _pathController.text;
      final success = _bridge.loadFile(_handle!, path);

      setState(() {
        if (success) {
          _statusMessage = "Loaded: $path";
          _performLayout();
        } else {
          _statusMessage = "Failed to load: $path";
          _isLoading = false;
        }
      });
    });
  }

  void _performLayout() {
    if (_handle == null) return;
    
    // On demande le layout avec une largeur arbitraire (ex: 1000) 
    // ou mieux: on attend que le LayoutBuilder nous donne la largeur.
    // Ici on va faire un layout initial.
    // Note: Pour un rendu "Zero-Copy", on doit re-calculer le layout si la vue change.
    // Mais pour l'instant, faisons le layout une fois.
    
    // Layout infini ou largeur fixe ? Essayons 800 pour commencer.
    _bridge.layout(_handle!, 1000.0);
    
    _commands = _bridge.getRenderCommands(_handle!, _countPtr!);
    _commandCount = _countPtr!.value;
    
    setState(() {
      _isLoading = false;
      _statusMessage = "Rendered $_commandCount commands";
    });
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
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: _sidebarWidth,
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Controls", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _pathController,
                    decoration: const InputDecoration(
                      labelText: "XML File Path",
                      border: OutlineInputBorder(),
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
                  Text("Status: $_statusMessage", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
          // Divider (Resizable Handle)
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
              color: Colors.grey[400],
              child: const Center(
                child: Icon(Icons.drag_handle, size: 12, color: Colors.white),
              ),
            ),
          ),
          // Main Canvas Area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Si on voulait être réactif, on pourrait appeler layout() ici avec constraints.maxWidth
                // Mais attention aux boucles de build infinies.
                // Pour l'instant on utilise le layout calculé précédemment.
                return Container(
                  color: Colors.white,
                  child: InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    minScale: 0.1,
                    maxScale: 5.0,
                    child: CustomPaint(
                      size: Size(1000, 2000), // Taille virtuelle du canvas
                      painter: ScorePainter(
                        commands: _commands,
                        commandCount: _commandCount,
                        handle: _handle,
                        bridge: _bridge,
                      ),
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
