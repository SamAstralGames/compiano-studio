import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

import '../../core/bridge.dart';
import '../score/score_controller.dart';
import '../../options/definitions/options_catalog.dart';
import '../../options/options.dart';

// Donnees minimales d'une requete de lecture.
class PlayRequest {
  final String path;
  final int requestId;

  PlayRequest({
    required this.path,
    required this.requestId,
  });
}

// Controleur de lecture qui emet des requetes vers l'UI.
class PlayController {
  static const int _maxOutputLines = 400;

  final ScoreController _scoreController;
  final ValueNotifier<PlayRequest?> playRequests = ValueNotifier<PlayRequest?>(null);
  final ValueNotifier<List<String>> consoleLines = ValueNotifier<List<String>>(<String>[]);
  final ValueNotifier<List<String>> frontBufferLines = ValueNotifier<List<String>>(<String>[]);
  final ValueNotifier<String> statusMessage = ValueNotifier<String>("Initializing...");

  bool _ready = false;
  double _lastLayoutWidth = 0.0;
  int _nextRequestId = 0;

  // Acces rapide au bridge FFI.
  MXMLBridge get _bridge => _scoreController.bridge;

  // Acces rapide au handle courant.
  ffi.Pointer<MXMLHandle>? get _handle => _scoreController.handle;

  // Acces rapide aux options courantes.
  ffi.Pointer<MXMLOptions>? get _options => _scoreController.options;

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

  PlayController({required ScoreController scoreController})
      : _scoreController = scoreController {
    // Initialise l'etat de la console et des options.
    _initializeBridge();
  }

  // Demande de lancer un morceau par son chemin.
  void requestPlay(String path) {
    // On incremente l'id pour forcer la notification meme si le path est identique.
    _nextRequestId += 1;
    playRequests.value = PlayRequest(path: path, requestId: _nextRequestId);
  }

  // Met a jour la largeur de layout pour les commandes.
  void updateLayoutWidth(double width) {
    // Ignore les largeurs invalides.
    if (width <= 0) {
      return;
    }
    _lastLayoutWidth = width;
  }

  // Execute une commande console et publie les sorties.
  void executeCommand(String line) {
    final trimmed = line.trim();
    // Ignore les commandes vides.
    if (trimmed.isEmpty) {
      return;
    }
    _appendOutput("> $trimmed");
    _executeCommand(trimmed);
  }

  // Libere les resources du controller.
  void dispose() {
    playRequests.dispose();
    consoleLines.dispose();
    frontBufferLines.dispose();
    statusMessage.dispose();
  }

  // Initialise le bridge et les options.
  void _initializeBridge() {
    try {
      // Reutilise le controleur partage.
      if (_scoreController.ready) {
        _reloadOptionsFromBridge();
        _cacheDefaultsFromCurrent();
        _ready = true;
        statusMessage.value = "Ready";
        _appendOutput("Ready. Type 'help' to list commands.");
      } else {
        statusMessage.value = "Initialization failed";
        _appendOutput(statusMessage.value);
      }
    } catch (e) {
      statusMessage.value = "Initialization failed: $e";
      _appendOutput(statusMessage.value);
    }
  }

  // Construit un index rapide pour retrouver un item d'option.
  Map<String, OptionItem> _buildOptionIndex() {
    final output = <String, OptionItem>{};
    // Indexe chaque option pour les acces rapides.
    for (final section in _optionSections) {
      for (final item in section.items) {
        output[item.key] = item;
      }
    }
    return output;
  }

  // Ajoute une ligne a la sortie console.
  void _appendOutput(String line) {
    final updated = List<String>.from(consoleLines.value)..add(line);
    // Garde la sortie bornee.
    if (updated.length > _maxOutputLines) {
      updated.removeRange(0, updated.length - _maxOutputLines);
    }
    consoleLines.value = updated;
  }

  // Execute une ligne de commande parsee.
  void _executeCommand(String line) {
    // Stoppe si le bridge n'est pas pret.
    if (!_ready) {
      _appendOutput(statusMessage.value);
      return;
    }
    final tokens = _tokenize(line);
    // Stoppe si aucun token n'est present.
    if (tokens.isEmpty) {
      return;
    }
    final command = tokens.first;
    // Route les commandes vers les handlers.
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

  // Decoupe une ligne en tokens.
  List<String> _tokenize(String line) {
    // Normalise les espaces et split.
    return line.trim().split(RegExp(r"\s+"));
  }

  // Affiche la liste des commandes supportees.
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

  // Traite la commande load.
  void _handleLoad(List<String> tokens) {
    // Verifie qu'un chemin est fourni.
    if (tokens.length < 2) {
      _appendOutput("Usage: load <path>");
      return;
    }
    final path = tokens.sublist(1).join(" ");
    // Verifie le handle.
    if (_handle == null) {
      _appendOutput("Error: handle not initialized.");
      return;
    }
    final ok = _scoreController.loadFile(path);
    _appendOutput("Loaded: $path ok=${ok ? 1 : 0}");
  }

  // Traite la commande set.
  void _handleSet(List<String> tokens) {
    // Verifie la presence de la cle et la valeur.
    if (tokens.length < 3) {
      _appendOutput("Usage: set <option> <value>");
      return;
    }
    final key = tokens[1];
    final valueText = tokens.sublist(2).join(" ");
    final item = _optionItemsByKey[key];
    // Verifie que l'option existe.
    if (item == null) {
      _appendOutput("Unknown option: $key");
      return;
    }
    // Verifie le pointeur options.
    if (_options == null) {
      _appendOutput("Error: options not initialized.");
      return;
    }
    // Applique selon le type.
    switch (item.type) {
      case OptionValueType.boolean:
        final parsed = _parseBool(valueText);
        // Rejette les booleens invalides.
        if (parsed == null) {
          _appendOutput("Invalid boolean (use 0/1/true/false).");
          return;
        }
        _boolValues[key] = parsed;
        item.boolSetter!(_options!, parsed);
        break;
      case OptionValueType.integer:
        final parsed = int.tryParse(valueText.trim());
        // Rejette les entiers invalides.
        if (parsed == null) {
          _appendOutput("Invalid integer.");
          return;
        }
        _intValues[key] = parsed;
        item.intSetter!(_options!, parsed);
        break;
      case OptionValueType.decimal:
        final parsed = double.tryParse(valueText.trim());
        // Rejette les decimaux invalides.
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

  // Traite la commande unset.
  void _handleUnset(List<String> tokens) {
    // Verifie la presence de la cle.
    if (tokens.length < 2) {
      _appendOutput("Usage: unset <option>");
      return;
    }
    final key = tokens[1];
    final item = _optionItemsByKey[key];
    // Verifie que l'option existe.
    if (item == null) {
      _appendOutput("Unknown option: $key");
      return;
    }
    // Verifie le pointeur options.
    if (_options == null) {
      _appendOutput("Error: options not initialized.");
      return;
    }
    // Restaure la valeur par defaut selon le type.
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

  // Traite la commande show.
  void _handleShow(List<String> tokens) {
    // Seul "show options" est supporte.
    if (tokens.length < 2 || tokens[1] != "options") {
      _appendOutput("Usage: show options");
      return;
    }
    _appendOutput("Options:");
    // Affiche les options dans l'ordre.
    for (final section in _optionSections) {
      _appendOutput("[${section.name}]");
      for (final item in section.items) {
        final value = _optionValueToString(item);
        _appendOutput("  ${item.key}=$value");
      }
    }
  }

  // Traite la commande state.
  void _handleState() {
    final path = _scoreController.loadedPath ?? "";
    final loaded = _scoreController.loadedOk ? "1" : "0";
    _appendOutput("Loaded: $path ok=$loaded");
    _appendOutput("LayoutWidth: ${_lastLayoutWidth.toStringAsFixed(2)}");
  }

  // Traite la commande process.
  void _handleProcess() {
    if (_handle == null) {
      _appendOutput("Error: handle not initialized.");
      return;
    }
    // Verifie qu'un fichier est charge.
    if (!_scoreController.loadedOk) {
      _appendOutput("No file loaded. Use 'load <path>' first.");
      return;
    }
    if (_options == null) {
      _appendOutput("Error: options not initialized.");
      return;
    }
    // Verifie la largeur de layout.
    if (_lastLayoutWidth <= 0) {
      _appendOutput("Invalid layout width. Resize the window and retry.");
      return;
    }
    _scoreController.layout(_lastLayoutWidth, useOptions: true);
    final count = _refreshFrontBuffer();
    _appendOutput("Processed: ok=1 commands=$count");
  }

  // Traite la commande getPipelineBench.
  void _handlePipelineBench() {
    // Verifie le handle.
    if (_handle == null) {
      _appendOutput("Error: handle not initialized.");
      return;
    }
    final bench = _bridge.getPipelineBench(_handle!);
    // Affiche une ligne vide si absent.
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

  // Traite la commande writeSVG.
  void _handleWriteSvg(List<String> tokens) {
    // Verifie la presence d'un chemin.
    if (tokens.length < 2) {
      _appendOutput("Usage: writeSVG <path>");
      return;
    }
    // Verifie le handle.
    if (_handle == null) {
      _appendOutput("Error: handle not initialized.");
      return;
    }
    final path = tokens.sublist(1).join(" ");
    final ok = _bridge.writeSvgToFile(_handle!, path);
    _appendOutput("WroteSVG: $path ok=${ok ? 1 : 0}");
  }

  // Traite la commande getRenderCommandCount.
  void _handleRenderCommandCount() {
    // Verifie le handle.
    if (_handle == null) {
      _appendOutput("Error: handle not initialized.");
      return;
    }
    final count = _getRenderCommandCountInternal();
    _appendOutput("RenderCommands: $count");
  }

  // Rafraichit les lignes du front buffer.
  int _refreshFrontBuffer() {
    // Verifie le handle.
    if (_handle == null) {
      return 0;
    }
    final countPtr = calloc<ffi.Size>();
    final commandsPtr = _bridge.getRenderCommands(_handle!, countPtr);
    final count = countPtr.value;
    calloc.free(countPtr);
    final lines = <String>[];
    // Header de contexte.
    lines.add("FrontBuffer: $count commands");
    // Itere et formate chaque commande.
    for (var i = 0; i < count; i++) {
      final cmd = commandsPtr.elementAt(i).ref;
      lines.add(_formatRenderCommand(i, cmd));
    }
    frontBufferLines.value = lines;
    return count;
  }

  // Lit le nombre de commandes via FFI.
  int _getRenderCommandCountInternal() {
    // Verifie le handle.
    if (_handle == null) {
      return 0;
    }
    final countPtr = calloc<ffi.Size>();
    _bridge.getRenderCommands(_handle!, countPtr);
    final count = countPtr.value;
    calloc.free(countPtr);
    return count;
  }

  // Recharge les options depuis le bridge.
  void _reloadOptionsFromBridge() {
    // Skip si options absentes.
    if (_options == null) return;
    // Parcourt les options et rafraichit le cache.
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

  // Met en cache les valeurs par defaut.
  void _cacheDefaultsFromCurrent() {
    // Copie les valeurs courantes dans les caches.
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

  // Convertit une valeur d'option en string.
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

  // Formate une commande de rendu en ligne lisible.
  String _formatRenderCommand(int index, MXMLRenderCommandC cmd) {
    // Verifie le handle.
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

  // Formate un point en tuple court.
  String _formatPoint(MXMLPointC point) {
    return "(${point.x}, ${point.y})";
  }

  // Formate un rectangle en tuple court.
  String _formatRect(MXMLRectC rect) {
    return "(${rect.x}, ${rect.y}, ${rect.width}, ${rect.height})";
  }

  // Formate un codepoint en hex.
  String _formatCodepoint(int codepoint) {
    final hex = codepoint.toRadixString(16).toUpperCase().padLeft(4, "0");
    return "U+$hex";
  }

  // Nettoie une string pour affichage mono-ligne.
  String _sanitizeText(String input) {
    return input
        .replaceAll("\n", "\\n")
        .replaceAll("\r", "\\r")
        .replaceAll("\"", "\\\"");
  }

  // Parse un bool depuis les formats courants.
  bool? _parseBool(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == "1" || normalized == "true") return true;
    if (normalized == "0" || normalized == "false") return false;
    return null;
  }

  // Parse une liste de strings separees par des virgules.
  List<String> _parseStringList(String text) {
    final parts = text.split(",");
    final output = <String>[];
    // Trim et collecte les elements non vides.
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isNotEmpty) {
        output.add(trimmed);
      }
    }
    return output;
  }

}
