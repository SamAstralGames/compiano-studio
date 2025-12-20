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

// Types de valeur d'option.
enum OptionValueType { boolean, integer, decimal, text, textList }

// Definition d'une option avec getters/setters FFI.
class OptionItem {
  final String key;
  final String label;
  final OptionValueType type;
  final String? hint;
  final bool Function(ffi.Pointer<MXMLOptions>)? boolGetter;
  final void Function(ffi.Pointer<MXMLOptions>, bool)? boolSetter;
  final int Function(ffi.Pointer<MXMLOptions>)? intGetter;
  final void Function(ffi.Pointer<MXMLOptions>, int)? intSetter;
  final double Function(ffi.Pointer<MXMLOptions>)? doubleGetter;
  final void Function(ffi.Pointer<MXMLOptions>, double)? doubleSetter;
  final String Function(ffi.Pointer<MXMLOptions>)? stringGetter;
  final void Function(ffi.Pointer<MXMLOptions>, String)? stringSetter;
  final List<String> Function(ffi.Pointer<MXMLOptions>)? stringListGetter;
  final void Function(ffi.Pointer<MXMLOptions>, List<String>)? stringListSetter;

  const OptionItem({
    required this.key,
    required this.label,
    required this.type,
    this.hint,
    this.boolGetter,
    this.boolSetter,
    this.intGetter,
    this.intSetter,
    this.doubleGetter,
    this.doubleSetter,
    this.stringGetter,
    this.stringSetter,
    this.stringListGetter,
    this.stringListSetter,
  });
}

// Regroupe les options par section.
class OptionSection {
  final String name;
  final List<OptionItem> items;

  const OptionSection({required this.name, required this.items});
}

// Presets disponibles.
enum PresetType { standard, piano, pianoPedagogic, compact, print }

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
  static const double _optionSectionBottomPadding = 12.0;
  static const double _optionSectionTitleSpacing = 6.0;
  static const double _optionItemVerticalPadding = 6.0;
  static const double _optionFieldSpacing = 4.0;
  static const double _optionFieldHorizontalPadding = 8.0;
  static const double _optionFieldVerticalPadding = 6.0;
  static const double _optionsHeaderSpacing = 8.0;
  static const double _presetButtonSpacing = 6.0;
  final ScrollController _sidebarScrollController = ScrollController();
  
  // Layout State
  double _lastLayoutWidth = 0.0;
  double _contentHeight = 0.0;
  
  // Benchmarks
  int _reprocessCount = 0;
  double _lastProcessTimeMs = 0.0;
  MXMLPipelineBench? _pipelineBench;
  List<BenchLayer> _benchLayers = const [];
  
  // Options
  ffi.Pointer<MXMLOptions>? _options;
  bool _optionsReady = false;
  final Map<String, bool> _boolValues = {};
  final Map<String, int> _intValues = {};
  final Map<String, double> _doubleValues = {};
  final Map<String, String> _stringValues = {};
  final Map<String, String> _stringListValues = {};
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, String> _previousTextValues = {};
  late final List<OptionSection> _optionSections = _buildOptionSections();

  @override
  void initState() {
    super.initState();
    try {
      MXMLBridge.initialize();
      _handle = _bridge.create();
      _countPtr = calloc<ffi.Size>();
      // Initialise les options avec le preset standard.
      _options = _bridge.optionsCreate();
      _bridge.optionsApplyStandard(_options!);
      _bridge.setColorsDarkMode(_options!, _isDarkMode);
      _reloadOptionsFromBridge();
      _optionsReady = true;
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
    if (_options != null) {
      _bridge.optionsDestroy(_options!);
    }
    if (_countPtr != null) {
      calloc.free(_countPtr!);
    }
    // Nettoie les controllers de texte.
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    // Nettoie les focus nodes.
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    _sidebarScrollController.dispose();
    _pathController.dispose();
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
    // Stoppe si le handle n'est pas pret ou largeur invalide.
    if (_handle == null || width <= 0) return;
    
    _lastLayoutWidth = width;

    final stopwatch = Stopwatch()..start();
    // Utilise les options si elles sont disponibles.
    if (_options != null) {
      _bridge.layoutWithOptions(_handle!, width, _options!);
    } else {
      _bridge.layout(_handle!, width);
    }
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

  // Applique des changements d'options et relance le process si possible.
  void _applyWithProcess(VoidCallback applyChanges) {
    // Si le handle est absent, on applique seulement l'etat local.
    if (_handle == null) {
      setState(applyChanges);
      return;
    }
    // Si la largeur n'est pas encore connue, on evite le process.
    if (_lastLayoutWidth <= 0) {
      setState(applyChanges);
      return;
    }
    setState(() {
      applyChanges();
      _performLayout(_lastLayoutWidth);
    });
  }

  // Recharge les valeurs depuis la C-API.
  void _reloadOptionsFromBridge() {
    // On stoppe si les options ne sont pas disponibles.
    if (_options == null) return;
    // On boucle sur toutes les sections/options pour rafraichir l'etat.
    for (final section in _optionSections) {
      for (final item in section.items) {
        if (item.type == OptionValueType.boolean) {
          final value = item.boolGetter!(_options!);
          _boolValues[item.key] = value;
          // Synchronise l'etat du theme avec l'option.
          if (item.key == "colors_dark_mode") {
            _isDarkMode = value;
          }
        } else if (item.type == OptionValueType.integer) {
          final value = item.intGetter!(_options!);
          _intValues[item.key] = value;
          _setControllerText(item.key, value.toString());
        } else if (item.type == OptionValueType.decimal) {
          final value = item.doubleGetter!(_options!);
          _doubleValues[item.key] = value;
          _setControllerText(item.key, value.toString());
        } else if (item.type == OptionValueType.text) {
          final value = item.stringGetter!(_options!);
          _stringValues[item.key] = value;
          _setControllerText(item.key, value);
        } else if (item.type == OptionValueType.textList) {
          final value = item.stringListGetter!(_options!).join(", ");
          _stringListValues[item.key] = value;
          _setControllerText(item.key, value);
        }
      }
    }
  }

  // Met a jour le texte d'un controller en gardant l'historique.
  void _setControllerText(String key, String value) {
    final controller = _textControllers.putIfAbsent(key, () => TextEditingController());
    controller.text = value;
    _previousTextValues[key] = value;
  }

  // Parse une liste de strings a partir d'un texte.
  List<String> _parseStringList(String text) {
    final parts = text.split(",");
    final output = <String>[];
    // On nettoie chaque element et on ignore les vides.
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isNotEmpty) {
        output.add(trimmed);
      }
    }
    return output;
  }

  // Valide et applique une option numerique.
  void _commitNumberOption(OptionItem item, String text, bool isInt) {
    // On stoppe si les options ne sont pas disponibles.
    if (_options == null) return;
    final trimmed = text.trim();
    final previous = _previousTextValues[item.key] ?? "";
    if (trimmed.isEmpty) {
      // Si vide, on restaure la derniere valeur.
      _setControllerText(item.key, previous);
      return;
    }
    if (isInt) {
      final parsed = int.tryParse(trimmed);
      if (parsed == null) {
        // Si invalide, on restaure et on ne process pas.
        _setControllerText(item.key, previous);
        return;
      }
      _applyWithProcess(() {
        _intValues[item.key] = parsed;
        _previousTextValues[item.key] = trimmed;
        item.intSetter!(_options!, parsed);
      });
      return;
    }
    final parsed = double.tryParse(trimmed);
    if (parsed == null) {
      // Si invalide, on restaure et on ne process pas.
      _setControllerText(item.key, previous);
      return;
    }
    _applyWithProcess(() {
      _doubleValues[item.key] = parsed;
      _previousTextValues[item.key] = trimmed;
      item.doubleSetter!(_options!, parsed);
    });
  }

  // Applique une option texte simple.
  void _commitStringOption(OptionItem item, String text) {
    // On stoppe si les options ne sont pas disponibles.
    if (_options == null) return;
    final trimmed = text.trim();
    _applyWithProcess(() {
      _stringValues[item.key] = trimmed;
      _previousTextValues[item.key] = trimmed;
      item.stringSetter!(_options!, trimmed);
    });
  }

  // Applique une option texte liste.
  void _commitStringListOption(OptionItem item, String text) {
    // On stoppe si les options ne sont pas disponibles.
    if (_options == null) return;
    final trimmed = text.trim();
    final list = trimmed.isEmpty ? <String>[] : _parseStringList(trimmed);
    _applyWithProcess(() {
      _stringListValues[item.key] = trimmed;
      _previousTextValues[item.key] = trimmed;
      item.stringListSetter!(_options!, list);
    });
  }

  // Applique un preset d'options.
  void _applyPreset(PresetType preset) {
    // On stoppe si les options ne sont pas disponibles.
    if (_options == null) return;
    _applyWithProcess(() {
      // Selection du preset a appliquer.
      if (preset == PresetType.standard) {
        _bridge.optionsApplyStandard(_options!);
      } else if (preset == PresetType.piano) {
        _bridge.optionsApplyPiano(_options!);
      } else if (preset == PresetType.pianoPedagogic) {
        _bridge.optionsApplyPianoPedagogic(_options!);
      } else if (preset == PresetType.compact) {
        _bridge.optionsApplyCompact(_options!);
      } else if (preset == PresetType.print) {
        _bridge.optionsApplyPrint(_options!);
      }
      _bridge.setColorsDarkMode(_options!, _isDarkMode);
      _reloadOptionsFromBridge();
    });
  }

  // Met a jour le theme et l'option dark mode.
  void _handleDarkModeChanged(bool value) {
    _applyWithProcess(() {
      _isDarkMode = value;
      // Met a jour l'option si disponible.
      if (_options != null) {
        _bridge.setColorsDarkMode(_options!, value);
        _boolValues["colors_dark_mode"] = value;
      }
    });
  }

  // Construit le widget tree des options.
  Widget _buildOptionsTree(Color textColor) {
    // Si les options ne sont pas prêtes, on affiche un message.
    if (!_optionsReady) {
      return Text(
        "Options not ready",
        style: TextStyle(fontSize: _benchTextSize, color: textColor.withOpacity(0.7)),
      );
    }

    final sections = <Widget>[];
    // On ajoute chaque section dans l'ordre du header.
    for (final section in _optionSections) {
      sections.add(_buildOptionSection(section, textColor));
    }

    return ExpansionTile(
      title: Text("Options", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      children: [
        _buildPresetButtons(textColor),
        const SizedBox(height: _optionsHeaderSpacing),
        Column(children: sections),
      ],
    );
  }

  // Construit l'entete et les items d'une section.
  Widget _buildOptionSection(OptionSection section, Color textColor) {
    final items = <Widget>[];
    // On ajoute chaque option de la section.
    for (final item in section.items) {
      items.add(_buildOptionItem(item, textColor));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: _optionSectionBottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.name, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: _optionSectionTitleSpacing),
          Column(children: items),
        ],
      ),
    );
  }

  // Construit un widget pour une option.
  Widget _buildOptionItem(OptionItem item, Color textColor) {
    // Selection du widget selon le type d'option.
    if (item.type == OptionValueType.boolean) {
      final value = _boolValues[item.key] ?? false;
      return CheckboxListTile(
        value: value,
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(item.label, style: TextStyle(color: textColor, fontSize: _benchTextSize)),
        onChanged: (next) {
          // On ignore les updates null.
          if (next == null) return;
          if (_options == null) return;
          _applyWithProcess(() {
            _boolValues[item.key] = next;
            // Synchronise le theme si besoin.
            if (item.key == "colors_dark_mode") {
              _isDarkMode = next;
            }
            item.boolSetter!(_options!, next);
          });
        },
      );
    }

    if (item.type == OptionValueType.integer) {
      return _buildTextFieldOption(item, textColor, isInt: true);
    }

    if (item.type == OptionValueType.decimal) {
      return _buildTextFieldOption(item, textColor, isInt: false);
    }

    if (item.type == OptionValueType.text) {
      return _buildTextFieldOption(item, textColor, isInt: null);
    }

    // textList
    return _buildTextFieldOption(item, textColor, isInt: null, isList: true);
  }

  // Construit un TextField pour option texte/numerique.
  Widget _buildTextFieldOption(
    OptionItem item,
    Color textColor, {
    required bool? isInt,
    bool isList = false,
  }) {
    final controller = _textControllers.putIfAbsent(item.key, () => TextEditingController());
    final focusNode = _focusNodes.putIfAbsent(item.key, () => FocusNode());
    final keyboardType = isInt == null
        ? TextInputType.text
        : TextInputType.numberWithOptions(decimal: !isInt, signed: true);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _optionItemVerticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.label, style: TextStyle(color: textColor, fontSize: _benchTextSize)),
          const SizedBox(height: _optionFieldSpacing),
          Focus(
            focusNode: focusNode,
            onFocusChange: (hasFocus) {
              // On commit a la perte de focus.
              if (hasFocus) return;
              if (isInt != null) {
                _commitNumberOption(item, controller.text, isInt);
              } else if (isList) {
                _commitStringListOption(item, controller.text);
              } else {
                _commitStringOption(item, controller.text);
              }
            },
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(color: textColor, fontSize: _benchTextSize),
              decoration: InputDecoration(
                hintText: item.hint,
                isDense: true,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor.withOpacity(0.3))),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor)),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: _optionFieldHorizontalPadding,
                  vertical: _optionFieldVerticalPadding,
                ),
              ),
              onSubmitted: (_) {
                // On commit lors de l'envoi.
                if (isInt != null) {
                  _commitNumberOption(item, controller.text, isInt);
                } else if (isList) {
                  _commitStringListOption(item, controller.text);
                } else {
                  _commitStringOption(item, controller.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Construit les boutons de preset.
  Widget _buildPresetButtons(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Presets", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        const SizedBox(height: _optionSectionTitleSpacing),
        Wrap(
          spacing: _presetButtonSpacing,
          runSpacing: _presetButtonSpacing,
          children: [
            ElevatedButton(
              onPressed: () => _applyPreset(PresetType.standard),
              child: const Text("Standard"),
            ),
            ElevatedButton(
              onPressed: () => _applyPreset(PresetType.piano),
              child: const Text("Piano"),
            ),
            ElevatedButton(
              onPressed: () => _applyPreset(PresetType.pianoPedagogic),
              child: const Text("Piano Pedagogic"),
            ),
            ElevatedButton(
              onPressed: () => _applyPreset(PresetType.compact),
              child: const Text("Compact"),
            ),
            ElevatedButton(
              onPressed: () => _applyPreset(PresetType.print),
              child: const Text("Print"),
            ),
          ],
        ),
      ],
    );
  }

  // Construit la liste des sections d'options.
  List<OptionSection> _buildOptionSections() {
    return [
      OptionSection(
        name: "Rendering Options",
        items: [
          OptionItem(
            key: "rendering_draw_title",
            label: "Draw Title",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawTitle,
            boolSetter: _bridge.setRenderingDrawTitle,
          ),
          OptionItem(
            key: "rendering_draw_part_names",
            label: "Draw Part Names",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawPartNames,
            boolSetter: _bridge.setRenderingDrawPartNames,
          ),
          OptionItem(
            key: "rendering_draw_measure_numbers",
            label: "Draw Measure Numbers",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawMeasureNumbers,
            boolSetter: _bridge.setRenderingDrawMeasureNumbers,
          ),
          OptionItem(
            key: "rendering_draw_measure_numbers_only_at_system_start",
            label: "Draw Measure Numbers Only At System Start",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawMeasureNumbersOnlyAtSystemStart,
            boolSetter: _bridge.setRenderingDrawMeasureNumbersOnlyAtSystemStart,
          ),
          OptionItem(
            key: "rendering_draw_measure_numbers_begin",
            label: "Draw Measure Numbers Begin",
            type: OptionValueType.integer,
            intGetter: _bridge.getRenderingDrawMeasureNumbersBegin,
            intSetter: _bridge.setRenderingDrawMeasureNumbersBegin,
          ),
          OptionItem(
            key: "rendering_measure_number_interval",
            label: "Measure Number Interval",
            type: OptionValueType.integer,
            intGetter: _bridge.getRenderingMeasureNumberInterval,
            intSetter: _bridge.setRenderingMeasureNumberInterval,
          ),
          OptionItem(
            key: "rendering_draw_time_signatures",
            label: "Draw Time Signatures",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawTimeSignatures,
            boolSetter: _bridge.setRenderingDrawTimeSignatures,
          ),
          OptionItem(
            key: "rendering_draw_key_signatures",
            label: "Draw Key Signatures",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawKeySignatures,
            boolSetter: _bridge.setRenderingDrawKeySignatures,
          ),
          OptionItem(
            key: "rendering_draw_fingerings",
            label: "Draw Fingerings",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawFingerings,
            boolSetter: _bridge.setRenderingDrawFingerings,
          ),
          OptionItem(
            key: "rendering_draw_slurs",
            label: "Draw Slurs",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawSlurs,
            boolSetter: _bridge.setRenderingDrawSlurs,
          ),
          OptionItem(
            key: "rendering_draw_pedals",
            label: "Draw Pedals",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawPedals,
            boolSetter: _bridge.setRenderingDrawPedals,
          ),
          OptionItem(
            key: "rendering_draw_dynamics",
            label: "Draw Dynamics",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawDynamics,
            boolSetter: _bridge.setRenderingDrawDynamics,
          ),
          OptionItem(
            key: "rendering_draw_wedges",
            label: "Draw Wedges",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawWedges,
            boolSetter: _bridge.setRenderingDrawWedges,
          ),
          OptionItem(
            key: "rendering_draw_lyrics",
            label: "Draw Lyrics",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawLyrics,
            boolSetter: _bridge.setRenderingDrawLyrics,
          ),
          OptionItem(
            key: "rendering_draw_credits",
            label: "Draw Credits",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawCredits,
            boolSetter: _bridge.setRenderingDrawCredits,
          ),
          OptionItem(
            key: "rendering_draw_composer",
            label: "Draw Composer",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawComposer,
            boolSetter: _bridge.setRenderingDrawComposer,
          ),
          OptionItem(
            key: "rendering_draw_lyricist",
            label: "Draw Lyricist",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getRenderingDrawLyricist,
            boolSetter: _bridge.setRenderingDrawLyricist,
          ),
        ],
      ),
      OptionSection(
        name: "Layout Options",
        items: [
          OptionItem(
            key: "layout_page_format",
            label: "Page Format",
            type: OptionValueType.text,
            stringGetter: _bridge.getLayoutPageFormat,
            stringSetter: _bridge.setLayoutPageFormat,
          ),
          OptionItem(
            key: "layout_use_fixed_canvas",
            label: "Use Fixed Canvas",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getLayoutUseFixedCanvas,
            boolSetter: _bridge.setLayoutUseFixedCanvas,
          ),
          OptionItem(
            key: "layout_fixed_canvas_width",
            label: "Fixed Canvas Width",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLayoutFixedCanvasWidth,
            doubleSetter: _bridge.setLayoutFixedCanvasWidth,
          ),
          OptionItem(
            key: "layout_fixed_canvas_height",
            label: "Fixed Canvas Height",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLayoutFixedCanvasHeight,
            doubleSetter: _bridge.setLayoutFixedCanvasHeight,
          ),
          OptionItem(
            key: "layout_page_height",
            label: "Page Height",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLayoutPageHeight,
            doubleSetter: _bridge.setLayoutPageHeight,
          ),
          OptionItem(
            key: "layout_page_margin_left_staff_spaces",
            label: "Page Margin Left (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLayoutPageMarginLeftStaffSpaces,
            doubleSetter: _bridge.setLayoutPageMarginLeftStaffSpaces,
          ),
          OptionItem(
            key: "layout_page_margin_right_staff_spaces",
            label: "Page Margin Right (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLayoutPageMarginRightStaffSpaces,
            doubleSetter: _bridge.setLayoutPageMarginRightStaffSpaces,
          ),
          OptionItem(
            key: "layout_page_margin_top_staff_spaces",
            label: "Page Margin Top (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLayoutPageMarginTopStaffSpaces,
            doubleSetter: _bridge.setLayoutPageMarginTopStaffSpaces,
          ),
          OptionItem(
            key: "layout_page_margin_bottom_staff_spaces",
            label: "Page Margin Bottom (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLayoutPageMarginBottomStaffSpaces,
            doubleSetter: _bridge.setLayoutPageMarginBottomStaffSpaces,
          ),
          OptionItem(
            key: "layout_system_spacing_min_staff_spaces",
            label: "System Spacing Min (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLayoutSystemSpacingMinStaffSpaces,
            doubleSetter: _bridge.setLayoutSystemSpacingMinStaffSpaces,
          ),
          OptionItem(
            key: "layout_system_spacing_multi_staff_min_staff_spaces",
            label: "System Spacing Multi Staff Min (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLayoutSystemSpacingMultiStaffMinStaffSpaces,
            doubleSetter: _bridge.setLayoutSystemSpacingMultiStaffMinStaffSpaces,
          ),
          OptionItem(
            key: "layout_new_system_from_xml",
            label: "New System From XML",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getLayoutNewSystemFromXml,
            boolSetter: _bridge.setLayoutNewSystemFromXml,
          ),
          OptionItem(
            key: "layout_new_page_from_xml",
            label: "New Page From XML",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getLayoutNewPageFromXml,
            boolSetter: _bridge.setLayoutNewPageFromXml,
          ),
          OptionItem(
            key: "layout_fill_empty_measures_with_whole_rest",
            label: "Fill Empty Measures With Whole Rest",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getLayoutFillEmptyMeasuresWithWholeRest,
            boolSetter: _bridge.setLayoutFillEmptyMeasuresWithWholeRest,
          ),
        ],
      ),
      OptionSection(
        name: "Line Breaking Options",
        items: [
          OptionItem(
            key: "line_breaking_justification_ratio_min",
            label: "Justification Ratio Min",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingJustificationRatioMin,
            doubleSetter: _bridge.setLineBreakingJustificationRatioMin,
          ),
          OptionItem(
            key: "line_breaking_justification_ratio_max",
            label: "Justification Ratio Max",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingJustificationRatioMax,
            doubleSetter: _bridge.setLineBreakingJustificationRatioMax,
          ),
          OptionItem(
            key: "line_breaking_justification_ratio_target",
            label: "Justification Ratio Target",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingJustificationRatioTarget,
            doubleSetter: _bridge.setLineBreakingJustificationRatioTarget,
          ),
          OptionItem(
            key: "line_breaking_justification_ratio_soft_min",
            label: "Justification Ratio Soft Min",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingJustificationRatioSoftMin,
            doubleSetter: _bridge.setLineBreakingJustificationRatioSoftMin,
          ),
          OptionItem(
            key: "line_breaking_justification_ratio_soft_max",
            label: "Justification Ratio Soft Max",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingJustificationRatioSoftMax,
            doubleSetter: _bridge.setLineBreakingJustificationRatioSoftMax,
          ),
          OptionItem(
            key: "line_breaking_weight_ratio",
            label: "Weight Ratio",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingWeightRatio,
            doubleSetter: _bridge.setLineBreakingWeightRatio,
          ),
          OptionItem(
            key: "line_breaking_weight_tight",
            label: "Weight Tight",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingWeightTight,
            doubleSetter: _bridge.setLineBreakingWeightTight,
          ),
          OptionItem(
            key: "line_breaking_weight_loose",
            label: "Weight Loose",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingWeightLoose,
            doubleSetter: _bridge.setLineBreakingWeightLoose,
          ),
          OptionItem(
            key: "line_breaking_weight_last_under",
            label: "Weight Last Under",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingWeightLastUnder,
            doubleSetter: _bridge.setLineBreakingWeightLastUnder,
          ),
          OptionItem(
            key: "line_breaking_cost_power",
            label: "Cost Power",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingCostPower,
            doubleSetter: _bridge.setLineBreakingCostPower,
          ),
          OptionItem(
            key: "line_breaking_stretch_last_system",
            label: "Stretch Last System",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getLineBreakingStretchLastSystem,
            boolSetter: _bridge.setLineBreakingStretchLastSystem,
          ),
          OptionItem(
            key: "line_breaking_last_line_max_underfill",
            label: "Last Line Max Underfill",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingLastLineMaxUnderfill,
            doubleSetter: _bridge.setLineBreakingLastLineMaxUnderfill,
          ),
          OptionItem(
            key: "line_breaking_target_measures_per_system",
            label: "Target Measures Per System",
            type: OptionValueType.integer,
            intGetter: _bridge.getLineBreakingTargetMeasuresPerSystem,
            intSetter: _bridge.setLineBreakingTargetMeasuresPerSystem,
          ),
          OptionItem(
            key: "line_breaking_weight_count",
            label: "Weight Count",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingWeightCount,
            doubleSetter: _bridge.setLineBreakingWeightCount,
          ),
          OptionItem(
            key: "line_breaking_bonus_final_bar",
            label: "Bonus Final Bar",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingBonusFinalBar,
            doubleSetter: _bridge.setLineBreakingBonusFinalBar,
          ),
          OptionItem(
            key: "line_breaking_bonus_double_bar",
            label: "Bonus Double Bar",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingBonusDoubleBar,
            doubleSetter: _bridge.setLineBreakingBonusDoubleBar,
          ),
          OptionItem(
            key: "line_breaking_bonus_phras_end",
            label: "Bonus Phras End",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingBonusPhrasEnd,
            doubleSetter: _bridge.setLineBreakingBonusPhrasEnd,
          ),
          OptionItem(
            key: "line_breaking_bonus_rehearsal_mark",
            label: "Bonus Rehearsal Mark",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingBonusRehearsalMark,
            doubleSetter: _bridge.setLineBreakingBonusRehearsalMark,
          ),
          OptionItem(
            key: "line_breaking_penalty_hairpin_across",
            label: "Penalty Hairpin Across",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingPenaltyHairpinAcross,
            doubleSetter: _bridge.setLineBreakingPenaltyHairpinAcross,
          ),
          OptionItem(
            key: "line_breaking_penalty_slur_across",
            label: "Penalty Slur Across",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingPenaltySlurAcross,
            doubleSetter: _bridge.setLineBreakingPenaltySlurAcross,
          ),
          OptionItem(
            key: "line_breaking_penalty_lyrics_hyphen",
            label: "Penalty Lyrics Hyphen",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingPenaltyLyricsHyphen,
            doubleSetter: _bridge.setLineBreakingPenaltyLyricsHyphen,
          ),
          OptionItem(
            key: "line_breaking_penalty_tie_across",
            label: "Penalty Tie Across",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingPenaltyTieAcross,
            doubleSetter: _bridge.setLineBreakingPenaltyTieAcross,
          ),
          OptionItem(
            key: "line_breaking_penalty_clef_change",
            label: "Penalty Clef Change",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingPenaltyClefChange,
            doubleSetter: _bridge.setLineBreakingPenaltyClefChange,
          ),
          OptionItem(
            key: "line_breaking_penalty_key_time_change",
            label: "Penalty Key Time Change",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingPenaltyKeyTimeChange,
            doubleSetter: _bridge.setLineBreakingPenaltyKeyTimeChange,
          ),
          OptionItem(
            key: "line_breaking_penalty_tempo_text",
            label: "Penalty Tempo Text",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getLineBreakingPenaltyTempoText,
            doubleSetter: _bridge.setLineBreakingPenaltyTempoText,
          ),
          OptionItem(
            key: "line_breaking_enable_two_pass_optimization",
            label: "Enable Two Pass Optimization",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getLineBreakingEnableTwoPassOptimization,
            boolSetter: _bridge.setLineBreakingEnableTwoPassOptimization,
          ),
          OptionItem(
            key: "line_breaking_enable_break_features",
            label: "Enable Break Features",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getLineBreakingEnableBreakFeatures,
            boolSetter: _bridge.setLineBreakingEnableBreakFeatures,
          ),
          OptionItem(
            key: "line_breaking_max_measures_per_line",
            label: "Max Measures Per Line",
            type: OptionValueType.integer,
            intGetter: _bridge.getLineBreakingMaxMeasuresPerLine,
            intSetter: _bridge.setLineBreakingMaxMeasuresPerLine,
          ),
        ],
      ),
      OptionSection(
        name: "Notation Options",
        items: [
          OptionItem(
            key: "notation_auto_beam",
            label: "Auto Beam",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getNotationAutoBeam,
            boolSetter: _bridge.setNotationAutoBeam,
          ),
          OptionItem(
            key: "notation_tuplets_bracketed",
            label: "Tuplets Bracketed",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getNotationTupletsBracketed,
            boolSetter: _bridge.setNotationTupletsBracketed,
          ),
          OptionItem(
            key: "notation_triplets_bracketed",
            label: "Triplets Bracketed",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getNotationTripletsBracketed,
            boolSetter: _bridge.setNotationTripletsBracketed,
          ),
          OptionItem(
            key: "notation_tuplets_ratioed",
            label: "Tuplets Ratioed",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getNotationTupletsRatioed,
            boolSetter: _bridge.setNotationTupletsRatioed,
          ),
          OptionItem(
            key: "notation_align_rests",
            label: "Align Rests",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getNotationAlignRests,
            boolSetter: _bridge.setNotationAlignRests,
          ),
          OptionItem(
            key: "notation_set_wanted_stem_direction_by_xml",
            label: "Set Wanted Stem Direction By XML",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getNotationSetWantedStemDirectionByXml,
            boolSetter: _bridge.setNotationSetWantedStemDirectionByXml,
          ),
          OptionItem(
            key: "notation_slur_lift_sample_count",
            label: "Slur Lift Sample Count",
            type: OptionValueType.integer,
            intGetter: _bridge.getNotationSlurLiftSampleCount,
            intSetter: _bridge.setNotationSlurLiftSampleCount,
          ),
          OptionItem(
            key: "notation_fingering_position",
            label: "Fingering Position",
            type: OptionValueType.text,
            stringGetter: _bridge.getNotationFingeringPosition,
            stringSetter: _bridge.setNotationFingeringPosition,
          ),
          OptionItem(
            key: "notation_fingering_inside_stafflines",
            label: "Fingering Inside Stafflines",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getNotationFingeringInsideStafflines,
            boolSetter: _bridge.setNotationFingeringInsideStafflines,
          ),
          OptionItem(
            key: "notation_fingering_y_offset_staff_spaces",
            label: "Fingering Y Offset (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationFingeringYOffsetStaffSpaces,
            doubleSetter: _bridge.setNotationFingeringYOffsetStaffSpaces,
          ),
          OptionItem(
            key: "notation_fingering_font_size",
            label: "Fingering Font Size",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationFingeringFontSize,
            doubleSetter: _bridge.setNotationFingeringFontSize,
          ),
          OptionItem(
            key: "notation_pedal_y_offset_staff_spaces",
            label: "Pedal Y Offset (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationPedalYOffsetStaffSpaces,
            doubleSetter: _bridge.setNotationPedalYOffsetStaffSpaces,
          ),
          OptionItem(
            key: "notation_pedal_line_thickness_staff_spaces",
            label: "Pedal Line Thickness (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationPedalLineThicknessStaffSpaces,
            doubleSetter: _bridge.setNotationPedalLineThicknessStaffSpaces,
          ),
          OptionItem(
            key: "notation_pedal_text_font_size",
            label: "Pedal Text Font Size",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationPedalTextFontSize,
            doubleSetter: _bridge.setNotationPedalTextFontSize,
          ),
          OptionItem(
            key: "notation_pedal_text_to_line_start_staff_spaces",
            label: "Pedal Text To Line Start (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationPedalTextToLineStartStaffSpaces,
            doubleSetter: _bridge.setNotationPedalTextToLineStartStaffSpaces,
          ),
          OptionItem(
            key: "notation_pedal_line_to_end_symbol_gap_staff_spaces",
            label: "Pedal Line To End Symbol Gap (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationPedalLineToEndSymbolGapStaffSpaces,
            doubleSetter: _bridge.setNotationPedalLineToEndSymbolGapStaffSpaces,
          ),
          OptionItem(
            key: "notation_pedal_change_notch_height_staff_spaces",
            label: "Pedal Change Notch Height (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationPedalChangeNotchHeightStaffSpaces,
            doubleSetter: _bridge.setNotationPedalChangeNotchHeightStaffSpaces,
          ),
          OptionItem(
            key: "notation_dynamics_y_offset_staff_spaces",
            label: "Dynamics Y Offset (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationDynamicsYOffsetStaffSpaces,
            doubleSetter: _bridge.setNotationDynamicsYOffsetStaffSpaces,
          ),
          OptionItem(
            key: "notation_dynamics_font_size",
            label: "Dynamics Font Size",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationDynamicsFontSize,
            doubleSetter: _bridge.setNotationDynamicsFontSize,
          ),
          OptionItem(
            key: "notation_wedge_y_offset_staff_spaces",
            label: "Wedge Y Offset (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationWedgeYOffsetStaffSpaces,
            doubleSetter: _bridge.setNotationWedgeYOffsetStaffSpaces,
          ),
          OptionItem(
            key: "notation_wedge_height_staff_spaces",
            label: "Wedge Height (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationWedgeHeightStaffSpaces,
            doubleSetter: _bridge.setNotationWedgeHeightStaffSpaces,
          ),
          OptionItem(
            key: "notation_wedge_line_thickness_staff_spaces",
            label: "Wedge Line Thickness (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationWedgeLineThicknessStaffSpaces,
            doubleSetter: _bridge.setNotationWedgeLineThicknessStaffSpaces,
          ),
          OptionItem(
            key: "notation_wedge_inset_from_ends_staff_spaces",
            label: "Wedge Inset From Ends (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationWedgeInsetFromEndsStaffSpaces,
            doubleSetter: _bridge.setNotationWedgeInsetFromEndsStaffSpaces,
          ),
          OptionItem(
            key: "notation_lyrics_y_offset_staff_spaces",
            label: "Lyrics Y Offset (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationLyricsYOffsetStaffSpaces,
            doubleSetter: _bridge.setNotationLyricsYOffsetStaffSpaces,
          ),
          OptionItem(
            key: "notation_lyrics_font_size",
            label: "Lyrics Font Size",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationLyricsFontSize,
            doubleSetter: _bridge.setNotationLyricsFontSize,
          ),
          OptionItem(
            key: "notation_lyrics_hyphen_min_gap_staff_spaces",
            label: "Lyrics Hyphen Min Gap (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationLyricsHyphenMinGapStaffSpaces,
            doubleSetter: _bridge.setNotationLyricsHyphenMinGapStaffSpaces,
          ),
          OptionItem(
            key: "notation_articulation_offset_staff_spaces",
            label: "Articulation Offset (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationArticulationOffsetStaffSpaces,
            doubleSetter: _bridge.setNotationArticulationOffsetStaffSpaces,
          ),
          OptionItem(
            key: "notation_articulation_stack_gap_staff_spaces",
            label: "Articulation Stack Gap (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationArticulationStackGapStaffSpaces,
            doubleSetter: _bridge.setNotationArticulationStackGapStaffSpaces,
          ),
          OptionItem(
            key: "notation_articulation_line_thickness_staff_spaces",
            label: "Articulation Line Thickness (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationArticulationLineThicknessStaffSpaces,
            doubleSetter: _bridge.setNotationArticulationLineThicknessStaffSpaces,
          ),
          OptionItem(
            key: "notation_tenuto_length_staff_spaces",
            label: "Tenuto Length (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationTenutoLengthStaffSpaces,
            doubleSetter: _bridge.setNotationTenutoLengthStaffSpaces,
          ),
          OptionItem(
            key: "notation_accent_width_staff_spaces",
            label: "Accent Width (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationAccentWidthStaffSpaces,
            doubleSetter: _bridge.setNotationAccentWidthStaffSpaces,
          ),
          OptionItem(
            key: "notation_accent_height_staff_spaces",
            label: "Accent Height (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationAccentHeightStaffSpaces,
            doubleSetter: _bridge.setNotationAccentHeightStaffSpaces,
          ),
          OptionItem(
            key: "notation_marcato_width_staff_spaces",
            label: "Marcato Width (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationMarcatoWidthStaffSpaces,
            doubleSetter: _bridge.setNotationMarcatoWidthStaffSpaces,
          ),
          OptionItem(
            key: "notation_marcato_height_staff_spaces",
            label: "Marcato Height (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationMarcatoHeightStaffSpaces,
            doubleSetter: _bridge.setNotationMarcatoHeightStaffSpaces,
          ),
          OptionItem(
            key: "notation_staccato_dot_scale",
            label: "Staccato Dot Scale",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationStaccatoDotScale,
            doubleSetter: _bridge.setNotationStaccatoDotScale,
          ),
          OptionItem(
            key: "notation_fermata_y_offset_staff_spaces",
            label: "Fermata Y Offset (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationFermataYOffsetStaffSpaces,
            doubleSetter: _bridge.setNotationFermataYOffsetStaffSpaces,
          ),
          OptionItem(
            key: "notation_fermata_dot_to_arc_staff_spaces",
            label: "Fermata Dot To Arc (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationFermataDotToArcStaffSpaces,
            doubleSetter: _bridge.setNotationFermataDotToArcStaffSpaces,
          ),
          OptionItem(
            key: "notation_fermata_width_staff_spaces",
            label: "Fermata Width (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationFermataWidthStaffSpaces,
            doubleSetter: _bridge.setNotationFermataWidthStaffSpaces,
          ),
          OptionItem(
            key: "notation_fermata_height_staff_spaces",
            label: "Fermata Height (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationFermataHeightStaffSpaces,
            doubleSetter: _bridge.setNotationFermataHeightStaffSpaces,
          ),
          OptionItem(
            key: "notation_fermata_thickness_start_staff_spaces",
            label: "Fermata Thickness Start (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationFermataThicknessStartStaffSpaces,
            doubleSetter: _bridge.setNotationFermataThicknessStartStaffSpaces,
          ),
          OptionItem(
            key: "notation_fermata_thickness_mid_staff_spaces",
            label: "Fermata Thickness Mid (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationFermataThicknessMidStaffSpaces,
            doubleSetter: _bridge.setNotationFermataThicknessMidStaffSpaces,
          ),
          OptionItem(
            key: "notation_fermata_dot_scale",
            label: "Fermata Dot Scale",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationFermataDotScale,
            doubleSetter: _bridge.setNotationFermataDotScale,
          ),
          OptionItem(
            key: "notation_ornament_y_offset_staff_spaces",
            label: "Ornament Y Offset (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationOrnamentYOffsetStaffSpaces,
            doubleSetter: _bridge.setNotationOrnamentYOffsetStaffSpaces,
          ),
          OptionItem(
            key: "notation_ornament_stack_gap_staff_spaces",
            label: "Ornament Stack Gap (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationOrnamentStackGapStaffSpaces,
            doubleSetter: _bridge.setNotationOrnamentStackGapStaffSpaces,
          ),
          OptionItem(
            key: "notation_ornament_font_size",
            label: "Ornament Font Size",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationOrnamentFontSize,
            doubleSetter: _bridge.setNotationOrnamentFontSize,
          ),
          OptionItem(
            key: "notation_staff_distance_staff_spaces",
            label: "Staff Distance (Staff Spaces)",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getNotationStaffDistanceStaffSpaces,
            doubleSetter: _bridge.setNotationStaffDistanceStaffSpaces,
          ),
        ],
      ),
      OptionSection(
        name: "Color Options",
        items: [
          OptionItem(
            key: "colors_dark_mode",
            label: "Dark Mode",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getColorsDarkMode,
            boolSetter: _bridge.setColorsDarkMode,
          ),
          OptionItem(
            key: "colors_default_color_music",
            label: "Default Color Music",
            type: OptionValueType.text,
            stringGetter: _bridge.getColorsDefaultColorMusic,
            stringSetter: _bridge.setColorsDefaultColorMusic,
          ),
          OptionItem(
            key: "colors_default_color_notehead",
            label: "Default Color Notehead",
            type: OptionValueType.text,
            stringGetter: _bridge.getColorsDefaultColorNotehead,
            stringSetter: _bridge.setColorsDefaultColorNotehead,
          ),
          OptionItem(
            key: "colors_default_color_stem",
            label: "Default Color Stem",
            type: OptionValueType.text,
            stringGetter: _bridge.getColorsDefaultColorStem,
            stringSetter: _bridge.setColorsDefaultColorStem,
          ),
          OptionItem(
            key: "colors_default_color_rest",
            label: "Default Color Rest",
            type: OptionValueType.text,
            stringGetter: _bridge.getColorsDefaultColorRest,
            stringSetter: _bridge.setColorsDefaultColorRest,
          ),
          OptionItem(
            key: "colors_default_color_label",
            label: "Default Color Label",
            type: OptionValueType.text,
            stringGetter: _bridge.getColorsDefaultColorLabel,
            stringSetter: _bridge.setColorsDefaultColorLabel,
          ),
          OptionItem(
            key: "colors_default_color_title",
            label: "Default Color Title",
            type: OptionValueType.text,
            stringGetter: _bridge.getColorsDefaultColorTitle,
            stringSetter: _bridge.setColorsDefaultColorTitle,
          ),
          OptionItem(
            key: "colors_coloring_enabled",
            label: "Coloring Enabled",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getColorsColoringEnabled,
            boolSetter: _bridge.setColorsColoringEnabled,
          ),
          OptionItem(
            key: "colors_coloring_mode",
            label: "Coloring Mode",
            type: OptionValueType.text,
            stringGetter: _bridge.getColorsColoringMode,
            stringSetter: _bridge.setColorsColoringMode,
          ),
          OptionItem(
            key: "colors_color_stems_like_noteheads",
            label: "Color Stems Like Noteheads",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getColorsColorStemsLikeNoteheads,
            boolSetter: _bridge.setColorsColorStemsLikeNoteheads,
          ),
          OptionItem(
            key: "colors_coloring_set_custom",
            label: "Coloring Set Custom (comma separated)",
            type: OptionValueType.textList,
            stringListGetter: _bridge.getColorsCustomSet,
            stringListSetter: _bridge.setColorsCustomSet,
            hint: "e.g. #ff0000, #00ff00",
          ),
        ],
      ),
      OptionSection(
        name: "Performance Options",
        items: [
          OptionItem(
            key: "performance_enable_glyph_cache",
            label: "Enable Glyph Cache",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getPerformanceEnableGlyphCache,
            boolSetter: _bridge.setPerformanceEnableGlyphCache,
          ),
          OptionItem(
            key: "performance_enable_spatial_indexing",
            label: "Enable Spatial Indexing",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getPerformanceEnableSpatialIndexing,
            boolSetter: _bridge.setPerformanceEnableSpatialIndexing,
          ),
          OptionItem(
            key: "performance_sky_bottom_line_batch_min_measures",
            label: "Sky Bottom Line Batch Min Measures",
            type: OptionValueType.integer,
            intGetter: _bridge.getPerformanceSkyBottomLineBatchMinMeasures,
            intSetter: _bridge.setPerformanceSkyBottomLineBatchMinMeasures,
          ),
          OptionItem(
            key: "performance_svg_precision",
            label: "SVG Precision",
            type: OptionValueType.integer,
            intGetter: _bridge.getPerformanceSvgPrecision,
            intSetter: _bridge.setPerformanceSvgPrecision,
          ),
          OptionItem(
            key: "performance_bench_enable",
            label: "Bench Enable",
            type: OptionValueType.boolean,
            boolGetter: _bridge.getPerformanceBenchEnable,
            boolSetter: _bridge.setPerformanceBenchEnable,
          ),
        ],
      ),
      OptionSection(
        name: "Global Options",
        items: [
          OptionItem(
            key: "global_backend",
            label: "Backend",
            type: OptionValueType.text,
            stringGetter: _bridge.getBackend,
            stringSetter: _bridge.setBackend,
          ),
          OptionItem(
            key: "global_zoom",
            label: "Zoom",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getZoom,
            doubleSetter: _bridge.setZoom,
          ),
          OptionItem(
            key: "global_sheet_maximum_width",
            label: "Sheet Maximum Width",
            type: OptionValueType.decimal,
            doubleGetter: _bridge.getSheetMaximumWidth,
            doubleSetter: _bridge.setSheetMaximumWidth,
          ),
        ],
      ),
    ];
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
                          _handleDarkModeChanged(val);
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
                      const SizedBox(height: 10),
                      _buildOptionsTree(sidebarTextColor),
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
