import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../core/bridge.dart';
import 'score_painter.dart';

// Donnée élémentaire d'un benchmark.
class BenchItem {
  final String label;
  final double valueMs;

  const BenchItem({required this.label, required this.valueMs});
}

// Layer du pipeline avec ses benchmarks.
class BenchLayer {
  final String name;
  final List<BenchItem> items;

  const BenchLayer({required this.name, required this.items});
}

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
  static const double _benchTextSize = 12.0;
  final ScrollController _sidebarScrollController = ScrollController();
  
  // Layout State
  double _lastLayoutWidth = 0.0;
  double _contentHeight = 0.0;
  
  // Benchmarks
  int _reprocessCount = 0;
  double _lastProcessTimeMs = 0.0;
  MXMLPipelineBench? _pipelineBench;
  List<BenchLayer> _benchLayers = const [];

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
    _sidebarScrollController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml', 'musicxml', 'mxl'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _pathController.text = result.files.single.path!;
        });
        _loadFile();
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error picking file: $e";
      });
    }
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
    
    _lastLayoutWidth = width;

    final stopwatch = Stopwatch()..start();
    _bridge.layout(_handle!, width);
    stopwatch.stop();
    
    _commands = _bridge.getRenderCommands(_handle!, _countPtr!);
    _commandCount = _countPtr!.value;
    _contentHeight = _bridge.getHeight(_handle!);
    
    _lastProcessTimeMs = stopwatch.elapsedMicroseconds / 1000.0;
    _reprocessCount++;
    _updatePipelineBench();
  }
  
  void _downloadSvg() {
    if (_handle == null) return;
    final outPath = "${_pathController.text}.svg";
    final success = _bridge.writeSvgToFile(_handle!, outPath);
    setState(() {
        _statusMessage = success ? "SVG saved to $outPath" : "Failed to save SVG";
    });
  }

  Widget _buildBenchRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: _benchTextSize, color: color.withOpacity(0.7))),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: _benchTextSize, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // Construit les layers de benchmarks a partir des donnees C.
  List<BenchLayer> _buildBenchLayers(MXMLPipelineBench bench) {
    return [
      BenchLayer(
        name: "Input",
        items: [
          BenchItem(label: "XML Load", valueMs: bench.inputXmlLoadMs),
          BenchItem(label: "Model Build", valueMs: bench.inputModelBuildMs),
          BenchItem(label: "Input Total", valueMs: bench.inputTotalMs),
        ],
      ),
      BenchLayer(
        name: "Layout",
        items: [
          BenchItem(label: "Metrics", valueMs: bench.layoutMetricsMs),
          BenchItem(label: "Line Breaking", valueMs: bench.layoutLineBreakingMs),
          BenchItem(label: "Layout Total", valueMs: bench.layoutTotalMs),
        ],
      ),
      BenchLayer(
        name: "Render",
        items: [
          BenchItem(label: "Commands", valueMs: bench.renderCommandsMs),
        ],
      ),
      BenchLayer(
        name: "Export",
        items: [
          BenchItem(label: "Serialize SVG", valueMs: bench.exportSerializeSvgMs),
        ],
      ),
      BenchLayer(
        name: "Pipeline",
        items: [
          BenchItem(label: "Pipeline Total", valueMs: bench.pipelineTotalMs),
        ],
      ),
    ];
  }

  // Met a jour le cache local des benchmarks pipeline.
  void _updatePipelineBench() {
    // On stoppe si le handle est indisponible.
    if (_handle == null) return;
    final bench = _bridge.getPipelineBench(_handle!);
    // Si la lib ne renvoie rien, on garde l'etat actuel.
    if (bench == null) return;
    _pipelineBench = bench;
    _benchLayers = _buildBenchLayers(bench);
  }

  // Construit l'arborescence UI des benchmarks.
  Widget _buildBenchTree(Color textColor) {
    // Si aucune donnee, on montre un placeholder.
    if (_pipelineBench == null || _benchLayers.isEmpty) {
      return Text(
        "No pipeline bench data",
        style: TextStyle(fontSize: _benchTextSize, color: textColor.withOpacity(0.7)),
      );
    }

    final tiles = <Widget>[];
    // On ajoute un tile par layer dans l'ordre du pipeline.
    for (final layer in _benchLayers) {
      tiles.add(
        ExpansionTile(
          title: Text(layer.name, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          children: [
            // On liste les items du layer.
            for (final item in layer.items)
              _buildBenchRow(item.label, "${item.valueMs.toStringAsFixed(2)} ms", textColor),
          ],
        ),
      );
    }

    return Column(children: tiles);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
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
              child: Scrollbar(
                controller: _sidebarScrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _sidebarScrollController,
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

                      // Open File Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _pickFile,
                          icon: const Icon(Icons.folder_open),
                          label: const Text("Open MusicXML"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isDarkMode ? Colors.blueGrey[700] : Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      TextField(
                        controller: _pathController,
                        style: TextStyle(color: sidebarTextColor, fontSize: 12),
                        decoration: InputDecoration(
                          labelText: "File Path",
                          labelStyle: TextStyle(color: sidebarTextColor.withOpacity(0.7)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: sidebarTextColor.withOpacity(0.3))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: sidebarTextColor)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _loadFile,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Reload"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _downloadSvg,
                          icon: const Icon(Icons.download),
                          label: const Text("Download SVG"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      Text("Pipeline Benchmarks", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: sidebarTextColor)),
                      const SizedBox(height: 10),
                      _buildBenchRow("Reprocess Count", "$_reprocessCount", sidebarTextColor),
                      _buildBenchRow("Last Pipeline", "${_lastProcessTimeMs.toStringAsFixed(2)} ms", sidebarTextColor),
                      const SizedBox(height: 10),
                      _buildBenchTree(sidebarTextColor),
                      const SizedBox(height: 20),
                      const Divider(),
                      Text("Status: $_statusMessage", style: TextStyle(fontSize: 12, color: sidebarTextColor.withOpacity(0.7))),
                    ],
                  ),
                ),
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
                if (_handle != null && constraints.maxWidth > 0 && (constraints.maxWidth - _lastLayoutWidth).abs() > 1.0) {
                  _performLayout(constraints.maxWidth);
                  
                  // Planifier une mise à jour de l'UI (Sidebar stats) après la frame courante
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {});
                    }
                  });
                }

                return ClipRect(
                  child: Container(
                    color: bgColor,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: CustomPaint(
                        painter: ScorePainter(
                          commands: _commands,
                          commandCount: _commandCount,
                          handle: _handle,
                          bridge: _bridge,
                          isDarkMode: _isDarkMode,
                        ),
                        size: Size(constraints.maxWidth, _contentHeight > 0 ? _contentHeight : constraints.maxHeight),
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
