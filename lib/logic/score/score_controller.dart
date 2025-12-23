import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import '../../core/bridge.dart';

// Controleur partage pour le rendu de partitions via FFI.
class ScoreController {
  final MXMLBridge _bridge = MXMLBridge();
  final ValueNotifier<int> renderVersion = ValueNotifier<int>(0);

  ffi.Pointer<MXMLHandle>? _handle;
  ffi.Pointer<MXMLOptions>? _options;
  ffi.Pointer<MXMLRenderCommandC>? _commands;

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

  // Commandes de rendu courantes.
  ffi.Pointer<MXMLRenderCommandC>? get commands => _commands;

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

    final countPtr = calloc<ffi.Size>();
    try {
      _commands = _bridge.getRenderCommands(_handle!, countPtr);
      _commandCount = countPtr.value;
      _contentHeight = _bridge.getHeight(_handle!);
    } finally {
      // Libere le pointeur temporaire.
      calloc.free(countPtr);
    }

    // Notifie les observers qu'un nouveau buffer est disponible.
    renderVersion.value++;
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
  }
}
