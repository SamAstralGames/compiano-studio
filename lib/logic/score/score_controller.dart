import 'dart:ffi' as ffi;

import 'dart:ui';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import '../../core/bridge.dart';
import '../../core/ffi/mxml_types.dart'; // Import explicite pour les types C
import '../models/render_commands.dart';

// Controleur partage pour le rendu de partitions via FFI.
class ScoreController {
  final MXMLBridge _bridge = MXMLBridge();
  final ValueNotifier<int> renderVersion = ValueNotifier<int>(0);
  final ValueNotifier<bool> leftbarOpen = ValueNotifier<bool>(true);
  final ValueNotifier<double> leftbarOpacity = ValueNotifier<double>(0.5);
  final ValueNotifier<double> leftbarWidthRatio = ValueNotifier<double>(0.2);

  ffi.Pointer<MXMLHandle>? _handle;
  ffi.Pointer<MXMLOptions>? _options;
  // On ne stocke plus le pointeur de commandes pour l'UI, mais une liste Dart.
  List<RenderCommand> _renderCommands = [];

  bool _ready = false;
  bool _loadedOk = false;
  String? _loadedPath;

  int _commandCount = 0;
  double _contentHeight = 0.0;
  double _lastLayoutWidth = 0.0;

  ScoreController() {
    // Initialise le bridge et les objets FFI au demarrage.
    _initializeBridge();
  }

  // Acces au bridge pour les appels FFI bas niveau.
  MXMLBridge get bridge => _bridge;

  // Acces au handle FFI courant.
  ffi.Pointer<MXMLHandle>? get handle => _handle;

  // Acces aux options FFI courantes.
  ffi.Pointer<MXMLOptions>? get options => _options;

  // Indique si le bridge est pret a etre utilise.
  bool get ready => _ready;

  // Indique si un fichier a ete charge avec succes.
  bool get loadedOk => _loadedOk;

  // Chemin du fichier charge.
  String? get loadedPath => _loadedPath;

  // Commandes de rendu converties (Safe for UI).
  List<RenderCommand> get renderCommands => _renderCommands;

  // Nombre de commandes disponibles.
  int get commandCount => _commandCount;

  // Hauteur du contenu calculee par le moteur.
  double get contentHeight => _contentHeight;

  // Derniere largeur de layout utilisee.
  double get lastLayoutWidth => _lastLayoutWidth;

  // Initialise le bridge et les ressources FFI.
  void _initializeBridge() {
    try {
      // Garantit le chargement des symboles FFI.
      MXMLBridge.initialize();
      _handle = _bridge.create();
      _options = _bridge.optionsCreate();
      _bridge.optionsApplyStandard(_options!);
      _ready = true;
    } catch (e) {
      // En cas d'erreur, on laisse ready a false.
      _ready = false;
    }
  }

  // Charge un fichier MusicXML depuis le disque.
  bool loadFile(String path) {
    // Ne rien faire si le handle est absent.
    if (_handle == null) return false;
    final ok = _bridge.loadFile(_handle!, path);
    _loadedPath = path;
    _loadedOk = ok;
    return ok;
  }

  // Lance le layout et rafraichit le front buffer.
  void layout(double width, {bool useOptions = true}) {
    // Stoppe si le handle n'est pas pret ou largeur invalide.
    if (_handle == null || width <= 0) return;

    _lastLayoutWidth = width;

    // Applique le layout avec options si possible.
    if (useOptions && _options != null) {
      _bridge.layoutWithOptions(_handle!, width, _options!);
    } else {
      _bridge.layout(_handle!, width);
    }

    // Conversion immediate C++ -> Dart (Model)
    // Cela libere le thread UI de faire des appels FFI pendant le paint().
    final countPtr = calloc<ffi.Size>();
    try {
      final cmdsPtr = _bridge.getRenderCommands(_handle!, countPtr);
      _commandCount = countPtr.value;
      _contentHeight = _bridge.getHeight(_handle!);
      _renderCommands = _convertCommands(cmdsPtr, _commandCount);
    } finally {
      // Libere le pointeur temporaire.
      calloc.free(countPtr);
    }

    // Notifie les observers qu'un nouveau buffer est disponible.
    renderVersion.value++;
  }

  // Convertit le buffer C en objets Dart.
  List<RenderCommand> _convertCommands(ffi.Pointer<MXMLRenderCommandC> cmdsPtr, int count) {
    if (cmdsPtr == ffi.nullptr || count == 0) return [];
    
    final list = <RenderCommand>[];
    for (int i = 0; i < count; i++) {
      final cmd = cmdsPtr.elementAt(i).ref;
      switch (cmd.type) {
        case MXMLRenderCommandTypeC.MXML_LINE:
          final data = cmd.data.line;
          list.add(RenderLine(
            p1: Offset(data.p1.x, data.p1.y),
            p2: Offset(data.p2.x, data.p2.y),
            thickness: data.thickness,
          ));
          break;
        case MXMLRenderCommandTypeC.MXML_GLYPH:
          final data = cmd.data.glyph;
          // On recupere le codepoint ici, pas dans le paint() !
          final cp = _bridge.getGlyphCodepoint(_handle!, data.id);
          list.add(RenderGlyph(
            codepoint: cp,
            pos: Offset(data.pos.x, data.pos.y),
            scale: data.scale,
            id: data.id,
          ));
          break;
        case MXMLRenderCommandTypeC.MXML_TEXT:
          final data = cmd.data.text;
          // On recupere la string ici.
          final text = _bridge.getString(_handle!, data.textId);
          list.add(RenderText(
            text: text,
            pos: Offset(data.pos.x, data.pos.y),
            fontSize: data.fontSize,
            isItalic: data.italic == 1,
          ));
          break;
        case MXMLRenderCommandTypeC.MXML_DEBUG_RECT:
          final data = cmd.data.debugRect;
          list.add(RenderDebugRect(
            rect: Rect.fromLTWH(data.rect.x, data.rect.y, data.rect.width, data.rect.height),
            strokeWidth: data.strokeWidth,
            hasFill: data.fillId != 0,
          ));
          break;
      }
    }
    return list;
  }

  // Libere les ressources FFI et les listeners.
  void dispose() {
    // Detruit les objets natifs si ils existent.
    if (_handle != null) {
      _bridge.destroy(_handle!);
    }
    if (_options != null) {
      _bridge.optionsDestroy(_options!);
    }
    renderVersion.dispose();
    leftbarOpen.dispose();
    leftbarOpacity.dispose();
    leftbarWidthRatio.dispose();
  }

  // Met a jour l'etat d'ouverture de la leftbar.
  void setLeftbarOpen(bool isOpen) {
    leftbarOpen.value = isOpen;
  }

  // Inverse l'etat d'ouverture de la leftbar.
  void toggleLeftbar() {
    setLeftbarOpen(!leftbarOpen.value);
  }

  // Met a jour la transparence de la leftbar.
  void setLeftbarOpacity(double opacity) {
    leftbarOpacity.value = opacity.clamp(0.0, 1.0);
  }

  // Met a jour la largeur relative de la leftbar.
  void setLeftbarWidthRatio(double ratio) {
    leftbarWidthRatio.value = ratio.clamp(0.0, 1.0);
  }
}
