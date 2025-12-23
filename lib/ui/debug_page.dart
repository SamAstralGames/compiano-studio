import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

import '../core/bridge.dart';
import '../logic/score/score_controller.dart';
import '../options/definitions/options_catalog.dart';
import '../options/options.dart';

// Debug console page with a REPL-like command interface.
class DebugPage extends StatefulWidget {
  final ScoreController controller;

  const DebugPage({super.key, required this.controller});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  // UI constants.
  static const double _pagePadding = 12.0;
  static const double _inputSpacing = 8.0;
  static const double _outputLineSpacing = 4.0;
  static const int _maxOutputLines = 400;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();

  bool _ready = false;
  String _statusMessage = "Initializing...";
  double _lastLayoutWidth = 0.0;

  // Acces rapide au controleur partage.
  ScoreController get _controller => widget.controller;

  // Acces rapide au bridge FFI.
  MXMLBridge get _bridge => _controller.bridge;

  // Acces rapide au handle courant.
  ffi.Pointer<MXMLHandle>? get _handle => _controller.handle;

  // Acces rapide aux options courantes.
  ffi.Pointer<MXMLOptions>? get _options => _controller.options;

  final List<String> _outputLines = [];
  final List<String> _frontBufferLines = [];

  late final List<OptionSection> _optionSections = buildOptionSections(_bridge);
  late final Map<String, OptionItem> _optionItemsByKey = _buildOptionIndex();

  final Map<String, bool> _boolValues = {};
  final Map<String, int> _intValues = {};
  final Map<String, double> _doubleValues = {};
  final Map<String, String> _stringValues = {};
  final Map<String, String> _stringListValues = {};

  final Map<String, bool> _defaultBoolValues = {};
  final Map<String, int> _defaultIntValues = {};
  final Map<String, double> _defaultDoubleValues = {};
  final Map<String, String> _defaultStringValues = {};
  final Map<String, String> _defaultStringListValues = {};

  @override
  void initState() {
    super.initState();
    // Initialize the bridge and create FFI objects.
    _initializeBridge();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_pagePadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: console output + input.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildOutputPanel()),
                const SizedBox(height: _inputSpacing),
                _buildInputRow(),
              ],
            ),
          ),
          const SizedBox(width: _inputSpacing),
          // Right: frontbuffer text output.
          Expanded(child: _buildFrontBufferPanel()),
        ],
      ),
    );
  }

  // Build the console output list.
  Widget _buildOutputPanel() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(_pagePadding),
        itemCount: _outputLines.length,
        itemBuilder: (context, index) {
          return Text(
            _outputLines[index],
            style: const TextStyle(fontFamily: "monospace"),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: _outputLineSpacing);
        },
      ),
    );
  }

  // Build the input row with text field and send button.
  Widget _buildInputRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _inputController,
            decoration: const InputDecoration(
              hintText: "Enter command (help for list)",
            ),
            onSubmitted: _runCommandLine,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            _runCommandLine(_inputController.text);
          },
        ),
      ],
    );
  }

  // Build the frontbuffer text panel.
  Widget _buildFrontBufferPanel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Track width for layout calls.
        if (constraints.maxWidth > 0) {
          _lastLayoutWidth = constraints.maxWidth;
        }
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(_pagePadding),
                child: Text(
                  "FrontBuffer",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _frontBufferLines.isEmpty
                    ? const Center(child: Text("No frontbuffer data."))
                    : ListView.separated(
                        padding: const EdgeInsets.all(_pagePadding),
                        itemCount: _frontBufferLines.length,
                        itemBuilder: (context, index) {
                          return Text(
                            _frontBufferLines[index],
                            style: const TextStyle(fontFamily: "monospace"),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: _outputLineSpacing);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Initialize the bridge and preload options state.
  void _initializeBridge() {
    try {
      // Reutilise le controleur partage.
      if (_controller.ready) {
        _reloadOptionsFromBridge();
        _cacheDefaultsFromCurrent();
        _ready = true;
        _statusMessage = "Ready";
        _appendOutput("Ready. Type 'help' to list commands.");
      } else {
        _statusMessage = "Initialization failed";
        _appendOutput(_statusMessage);
      }
    } catch (e) {
      _statusMessage = "Initialization failed: $e";
      _appendOutput(_statusMessage);
    }
  }

  // Build a quick index from option key to item.
  Map<String, OptionItem> _buildOptionIndex() {
    final output = <String, OptionItem>{};
    // Index every option item for quick lookup.
    for (final section in _optionSections) {
      for (final item in section.items) {
        output[item.key] = item;
      }
    }
    return output;
  }

  // Append a line to the console output.
  void _appendOutput(String line) {
    setState(() {
      _outputLines.add(line);
      // Keep the output list bounded.
      if (_outputLines.length > _maxOutputLines) {
        _outputLines.removeRange(0, _outputLines.length - _maxOutputLines);
      }
    });
    // Scroll to bottom after the frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // Execute the current input line as a command.
  void _runCommandLine(String line) {
    final trimmed = line.trim();
    // Skip empty commands.
    if (trimmed.isEmpty) {
      return;
    }
    _appendOutput("> $trimmed");
    _inputController.clear();
    _executeCommand(trimmed);
  }

  // Execute a parsed command line.
  void _executeCommand(String line) {
    // Guard against missing bridge initialization.
    if (!_ready) {
      _appendOutput(_statusMessage);
      return;
    }
    final tokens = _tokenize(line);
    // Stop if tokenization yields nothing.
    if (tokens.isEmpty) {
      return;
    }
    final command = tokens.first;
    // Route commands to handlers.
    switch (command) {
      case "help":
        _printHelp();
        return;
      case "load":
        _handleLoad(tokens);
        return;
      case "set":
        _handleSet(tokens);
        return;
      case "unset":
        _handleUnset(tokens);
        return;
      case "show":
        _handleShow(tokens);
        return;
      case "state":
        _handleState();
        return;
      case "process":
        _handleProcess();
        return;
      case "getPipelineBench":
        _handlePipelineBench();
        return;
      case "writeSVG":
        _handleWriteSvg(tokens);
        return;
      case "getRenderCommandCount":
        _handleRenderCommandCount();
        return;
      default:
        _appendOutput("Unknown command: $command");
        return;
    }
  }

  // Split a command line into tokens (basic whitespace split).
  List<String> _tokenize(String line) {
    // Normalize whitespace and split into tokens.
    return line.trim().split(RegExp(r"\s+"));
  }

  // Print supported commands.
  void _printHelp() {
    _appendOutput("Commands:");
    _appendOutput("  help");
    _appendOutput("  load <path>");
    _appendOutput("  set <option> <value>");
    _appendOutput("  unset <option>");
    _appendOutput("  show options");
    _appendOutput("  state");
    _appendOutput("  process");
    _appendOutput("  getPipelineBench");
    _appendOutput("  writeSVG <path>");
    _appendOutput("  getRenderCommandCount");
  }

  // Handle the load command.
  void _handleLoad(List<String> tokens) {
    // Ensure the path is provided.
    if (tokens.length < 2) {
      _appendOutput("Usage: load <path>");
      return;
    }
    final path = tokens.sublist(1).join(" ");
    // Guard against missing handle.
    if (_handle == null) {
      _appendOutput("Error: handle not initialized.");
      return;
    }
    final ok = _controller.loadFile(path);
    _appendOutput("Loaded: $path ok=${ok ? 1 : 0}");
  }

  // Handle the set command.
  void _handleSet(List<String> tokens) {
    // Require a key and a value.
    if (tokens.length < 3) {
      _appendOutput("Usage: set <option> <value>");
      return;
    }
    final key = tokens[1];
    final valueText = tokens.sublist(2).join(" ");
    final item = _optionItemsByKey[key];
    // Ensure the option exists.
    if (item == null) {
      _appendOutput("Unknown option: $key");
      return;
    }
    // Guard against missing options pointer.
    if (_options == null) {
      _appendOutput("Error: options not initialized.");
      return;
    }
    // Apply by type.
    switch (item.type) {
      case OptionValueType.boolean:
        final parsed = _parseBool(valueText);
        // Reject invalid boolean values.
        if (parsed == null) {
          _appendOutput("Invalid boolean (use 0/1/true/false).");
          return;
        }
        _boolValues[key] = parsed;
        item.boolSetter!(_options!, parsed);
        break;
      case OptionValueType.integer:
        final parsed = int.tryParse(valueText.trim());
        // Reject invalid integer values.
        if (parsed == null) {
          _appendOutput("Invalid integer.");
          return;
        }
        _intValues[key] = parsed;
        item.intSetter!(_options!, parsed);
        break;
      case OptionValueType.decimal:
        final parsed = double.tryParse(valueText.trim());
        // Reject invalid decimal values.
        if (parsed == null) {
          _appendOutput("Invalid decimal.");
          return;
        }
        _doubleValues[key] = parsed;
        item.doubleSetter!(_options!, parsed);
        break;
      case OptionValueType.text:
        final trimmed = valueText.trim();
        _stringValues[key] = trimmed;
        item.stringSetter!(_options!, trimmed);
        break;
      case OptionValueType.textList:
        final list = _parseStringList(valueText);
        _stringListValues[key] = list.join(", ");
        item.stringListSetter!(_options!, list);
        break;
    }
    _appendOutput("OptionSet: $key");
  }

  // Handle the unset command.
  void _handleUnset(List<String> tokens) {
    // Require an option key.
    if (tokens.length < 2) {
      _appendOutput("Usage: unset <option>");
      return;
    }
    final key = tokens[1];
    final item = _optionItemsByKey[key];
    // Ensure the option exists.
    if (item == null) {
      _appendOutput("Unknown option: $key");
      return;
    }
    // Guard against missing options pointer.
    if (_options == null) {
      _appendOutput("Error: options not initialized.");
      return;
    }
    // Restore the default value by type.
    switch (item.type) {
      case OptionValueType.boolean:
        final value = _defaultBoolValues[key];
        if (value == null) return;
        _boolValues[key] = value;
        item.boolSetter!(_options!, value);
        break;
      case OptionValueType.integer:
        final value = _defaultIntValues[key];
        if (value == null) return;
        _intValues[key] = value;
        item.intSetter!(_options!, value);
        break;
      case OptionValueType.decimal:
        final value = _defaultDoubleValues[key];
        if (value == null) return;
        _doubleValues[key] = value;
        item.doubleSetter!(_options!, value);
        break;
      case OptionValueType.text:
        final value = _defaultStringValues[key];
        if (value == null) return;
        _stringValues[key] = value;
        item.stringSetter!(_options!, value);
        break;
      case OptionValueType.textList:
        final value = _defaultStringListValues[key];
        if (value == null) return;
        _stringListValues[key] = value;
        item.stringListSetter!(_options!, _parseStringList(value));
        break;
    }
    _appendOutput("OptionUnset: $key");
  }

  // Handle the show command.
  void _handleShow(List<String> tokens) {
    // Only "show options" is supported.
    if (tokens.length < 2 || tokens[1] != "options") {
      _appendOutput("Usage: show options");
      return;
    }
    _appendOutput("Options:");
    // Print each option in order.
    for (final section in _optionSections) {
      _appendOutput("[${section.name}]");
      for (final item in section.items) {
        final value = _optionValueToString(item);
        _appendOutput("  ${item.key}=$value");
      }
    }
  }

  // Handle the state command.
  void _handleState() {
    final path = _controller.loadedPath ?? "";
    final loaded = _controller.loadedOk ? "1" : "0";
    _appendOutput("Loaded: $path ok=$loaded");
    _appendOutput("LayoutWidth: ${_lastLayoutWidth.toStringAsFixed(2)}");
  }

  // Handle the process command.
  void _handleProcess() {
    if ( _handle == null ) {
      _appendOutput("Error: handle not initialized.");
      return;
    }
    // Ensure a file is loaded.
    if (!_controller.loadedOk ) {
      _appendOutput("No file loaded. Use 'load <path>' first.");
      return;
    }
    if ( _options == null ) {
      _appendOutput("Error: options not initialized.");
      return;
    }
    // Ensure we have a usable layout width.
    if (_lastLayoutWidth <= 0) {
      _appendOutput("Invalid layout width. Resize the window and retry.");
      return;
    }
    _controller.layout(_lastLayoutWidth, useOptions: true);
    final count = _refreshFrontBuffer();
    _appendOutput("Processed: ok=1 commands=$count");
  }

  // Handle the getPipelineBench command.
  void _handlePipelineBench() {
    // Guard against missing handle.
    if (_handle == null) {
      _appendOutput("Error: handle not initialized.");
      return;
    }
    final bench = _bridge.getPipelineBench(_handle!);
    // Print empty line if no bench is available.
    if (bench == null) {
      _appendOutput("PipelineBench:");
      return;
    }
    _appendOutput(
      "PipelineBench: "
      "${bench.inputXmlLoadMs} "
      "${bench.inputModelBuildMs} "
      "${bench.layoutMetricsMs} "
      "${bench.layoutLineBreakingMs} "
      "${bench.layoutTotalMs} "
      "${bench.renderCommandsMs} "
      "${bench.exportSerializeSvgMs} "
      "${bench.pipelineTotalMs}",
    );
  }

  // Handle the writeSVG command.
  void _handleWriteSvg(List<String> tokens) {
    // Require a path argument.
    if (tokens.length < 2) {
      _appendOutput("Usage: writeSVG <path>");
      return;
    }
    // Guard against missing handle.
    if (_handle == null) {
      _appendOutput("Error: handle not initialized.");
      return;
    }
    final path = tokens.sublist(1).join(" ");
    final ok = _bridge.writeSvgToFile(_handle!, path);
    _appendOutput("WroteSVG: $path ok=${ok ? 1 : 0}");
  }

  // Handle the getRenderCommandCount command.
  void _handleRenderCommandCount() {
    // Guard against missing handle.
    if (_handle == null) {
      _appendOutput("Error: handle not initialized.");
      return;
    }
    final count = _getRenderCommandCountInternal();
    _appendOutput("RenderCommands: $count");
  }

  // Refresh the frontbuffer dump lines from the current render commands.
  int _refreshFrontBuffer() {
    // Guard against missing handle.
    if (_handle == null) {
      return 0;
    }
    final countPtr = calloc<ffi.Size>();
    final commandsPtr = _bridge.getRenderCommands(_handle!, countPtr);
    final count = countPtr.value;
    calloc.free(countPtr);
    final lines = <String>[];
    // Header line for quick context.
    lines.add("FrontBuffer: $count commands");
    // Iterate and format every render command.
    for (var i = 0; i < count; i++) {
      final cmd = commandsPtr.elementAt(i).ref;
      lines.add(_formatRenderCommand(i, cmd));
    }
    setState(() {
      _frontBufferLines
        ..clear()
        ..addAll(lines);
    });
    return count;
  }

  // Read the render command count through FFI.
  int _getRenderCommandCountInternal() {
    // Guard against missing handle.
    if (_handle == null) {
      return 0;
    }
    final countPtr = calloc<ffi.Size>();
    _bridge.getRenderCommands(_handle!, countPtr);
    final count = countPtr.value;
    calloc.free(countPtr);
    return count;
  }

  // Reload local option values from the bridge.
  void _reloadOptionsFromBridge() {
    // Skip if options are not ready.
    if (_options == null) return;
    // Walk all options and refresh local cache.
    for (final section in _optionSections) {
      for (final item in section.items) {
        switch (item.type) {
          case OptionValueType.boolean:
            _boolValues[item.key] = item.boolGetter!(_options!);
            break;
          case OptionValueType.integer:
            _intValues[item.key] = item.intGetter!(_options!);
            break;
          case OptionValueType.decimal:
            _doubleValues[item.key] = item.doubleGetter!(_options!);
            break;
          case OptionValueType.text:
            _stringValues[item.key] = item.stringGetter!(_options!);
            break;
          case OptionValueType.textList:
            _stringListValues[item.key] =
                item.stringListGetter!(_options!).join(", ");
            break;
        }
      }
    }
  }

  // Cache default values from the current state.
  void _cacheDefaultsFromCurrent() {
    // Copy current values into default caches.
    _defaultBoolValues
      ..clear()
      ..addAll(_boolValues);
    _defaultIntValues
      ..clear()
      ..addAll(_intValues);
    _defaultDoubleValues
      ..clear()
      ..addAll(_doubleValues);
    _defaultStringValues
      ..clear()
      ..addAll(_stringValues);
    _defaultStringListValues
      ..clear()
      ..addAll(_stringListValues);
  }

  // Convert an option value to a display string.
  String _optionValueToString(OptionItem item) {
    switch (item.type) {
      case OptionValueType.boolean:
        return (_boolValues[item.key] ?? false) ? "1" : "0";
      case OptionValueType.integer:
        return (_intValues[item.key] ?? 0).toString();
      case OptionValueType.decimal:
        return (_doubleValues[item.key] ?? 0.0).toString();
      case OptionValueType.text:
        return _stringValues[item.key] ?? "";
      case OptionValueType.textList:
        return _stringListValues[item.key] ?? "";
    }
  }

  // Format a render command into a readable line.
  String _formatRenderCommand(int index, MXMLRenderCommandC cmd) {
    // Guard against missing handle.
    if (_handle == null) {
      return "[$index] <invalid handle>";
    }
    switch (cmd.type) {
      case MXMLRenderCommandTypeC.MXML_GLYPH:
        final glyph = cmd.data.glyph;
        final codepoint = _bridge.getGlyphCodepoint(_handle!, glyph.id);
        return "[$index] GLYPH id=${glyph.id} codepoint=${_formatCodepoint(codepoint)} "
            "pos=${_formatPoint(glyph.pos)} scale=${glyph.scale}";
      case MXMLRenderCommandTypeC.MXML_LINE:
        final line = cmd.data.line;
        return "[$index] LINE p1=${_formatPoint(line.p1)} p2=${_formatPoint(line.p2)} "
            "thickness=${line.thickness}";
      case MXMLRenderCommandTypeC.MXML_TEXT:
        final text = cmd.data.text;
        final content = _sanitizeText(_bridge.getString(_handle!, text.textId));
        return "[$index] TEXT id=${text.textId} text=\"$content\" pos=${_formatPoint(text.pos)} "
            "size=${text.fontSize} italic=${text.italic}";
      case MXMLRenderCommandTypeC.MXML_DEBUG_RECT:
        final rect = cmd.data.debugRect;
        final css = _sanitizeText(_bridge.getString(_handle!, rect.cssClassId));
        final stroke = _sanitizeText(_bridge.getString(_handle!, rect.strokeId));
        final fill = _sanitizeText(_bridge.getString(_handle!, rect.fillId));
        return "[$index] DEBUG_RECT rect=${_formatRect(rect.rect)} css=\"$css\" "
            "stroke=\"$stroke\" strokeWidth=${rect.strokeWidth} fill=\"$fill\" "
            "opacity=${rect.opacity}";
      case MXMLRenderCommandTypeC.MXML_PATH:
        final path = cmd.data.path;
        final d = _sanitizeText(_bridge.getString(_handle!, path.dId));
        final css = _sanitizeText(_bridge.getString(_handle!, path.cssClassId));
        final fill = _sanitizeText(_bridge.getString(_handle!, path.fillId));
        return "[$index] PATH d=\"$d\" css=\"$css\" fill=\"$fill\" opacity=${path.opacity}";
      default:
        return "[$index] UNKNOWN type=${cmd.type}";
    }
  }

  // Format a point as a short tuple.
  String _formatPoint(MXMLPointC point) {
    return "(${point.x}, ${point.y})";
  }

  // Format a rect as a short tuple.
  String _formatRect(MXMLRectC rect) {
    return "(${rect.x}, ${rect.y}, ${rect.width}, ${rect.height})";
  }

  // Format a codepoint as hex.
  String _formatCodepoint(int codepoint) {
    final hex = codepoint.toRadixString(16).toUpperCase().padLeft(4, "0");
    return "U+$hex";
  }

  // Sanitize text for single-line display.
  String _sanitizeText(String input) {
    return input
        .replaceAll("\n", "\\n")
        .replaceAll("\r", "\\r")
        .replaceAll("\"", "\\\"");
  }

  // Parse a bool from common inputs.
  bool? _parseBool(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == "1" || normalized == "true") return true;
    if (normalized == "0" || normalized == "false") return false;
    return null;
  }

  // Parse a comma-separated list of strings.
  List<String> _parseStringList(String text) {
    final parts = text.split(",");
    final output = <String>[];
    // Trim and collect non-empty parts.
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isNotEmpty) {
        output.add(trimmed);
      }
    }
    return output;
  }
}
