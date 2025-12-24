import 'dart:async';
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
  // final ValueNotifier<bool> benchmarkOverlayVisible = ValueNotifier<bool>(kDebugMode);
  final ValueNotifier<bool> benchmarkOverlayVisible = ValueNotifier<bool>(true);
  final ValueNotifier<MXMLPipelineBench?> lastBenchmark = ValueNotifier<MXMLPipelineBench?>(null);
  final ValueNotifier<double> lastPaintTimeMs = ValueNotifier<double>(0.0);
  final ValueNotifier<double> playbackCursorY = ValueNotifier<double>(0.0);
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);

  ffi.Pointer<MXMLHandle>? _handle;
  ffi.Pointer<MXMLOptions>? _options;
  // On ne stocke plus le pointeur de commandes pour l'UI, mais une liste Dart.
  List<RenderCommand> _allRenderCommands = [];
  List<RenderCommand> _visibleRenderCommands = [];

  bool _ready = false;
  bool _loadedOk = false;
  String? _loadedPath;
  String? _initializationError;
  bool _spatialIndexingEnabled = false; // Default to false (Standard behavior)

  int _commandCount = 0;
  double _contentHeight = 0.0;
  double _lastLayoutWidth = 0.0;
  double _availableWidth = 0.0;
  Timer? _playbackTimer;

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

  // Message d'erreur si l'initialisation a echoue.
  String? get initializationError => _initializationError;

  // Indique si le spatial indexing est actif.
  bool get spatialIndexingEnabled => _spatialIndexingEnabled;

  // Commandes de rendu converties (Safe for UI).
  List<RenderCommand> get renderCommands => _visibleRenderCommands;

  // Nombre de commandes disponibles.
  int get commandCount => _commandCount;

  // Hauteur du contenu calculee par le moteur.
  double get contentHeight => _contentHeight;

  // Derniere largeur de layout utilisee.
  double get lastLayoutWidth => _lastLayoutWidth;

  // Largeur disponible actuelle (mise a jour par l'UI).
  double get availableWidth => _availableWidth;

  // Initialise le bridge et les ressources FFI.
  void _initializeBridge() {
    print("[ScoreController] Initializing bridge...");
    try {
      // Garantit le chargement des symboles FFI.
      MXMLBridge.initialize();
      print("[ScoreController] Bridge symbols loaded. Creating handles...");
      _handle = _bridge.create();
      _options = _bridge.optionsCreate();
      _bridge.optionsApplyStandard(_options!);
      _ready = true;
      print("[ScoreController] Initialization complete. Engine Ready.");
    } catch (e, stack) {
      print("[ScoreController] FATAL INIT ERROR: $e\n$stack");
      // En cas d'erreur, on laisse ready a false.
      _ready = false;
      _initializationError = e.toString();
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

  // Met a jour la taille disponible pour le rendu (appele par l'UI).
  void updateCanvasSize(double width) {
    _availableWidth = width;
  }

  // Active ou desactive l'optimisation spatiale (Chunking).
  void setSpatialIndexing(bool enabled) {
    _spatialIndexingEnabled = enabled;
  }

  // Lance le layout et rafraichit le front buffer.
  // Si width n'est pas fourni, utilise la derniere taille connue (_availableWidth).
  void layout({double? width, bool useOptions = true}) {
    try {
      final targetWidth = width ?? _availableWidth;

      // Stoppe si le handle n'est pas pret ou largeur invalide.
      // On verifie aussi si un fichier est bien charge pour eviter de layout le vide.
      if (_handle == null || !_loadedOk || targetWidth <= 0) return;

      _lastLayoutWidth = targetWidth;

      // Applique le layout avec options si possible.
      if (useOptions && _options != null) {
        _bridge.layoutWithOptions(_handle!, targetWidth, _options!);
      } else {
        _bridge.layout(_handle!, targetWidth);
      }

      // Conversion immediate C++ -> Dart (Model)
      // Cela libere le thread UI de faire des appels FFI pendant le paint().
      final countPtr = calloc<ffi.Size>();
      try {
        // Si le C++ gere le chunking, on ne recupere pas tout ici.
        if (_bridge.supportsSpatialIndexing && _spatialIndexingEnabled) {
          _contentHeight = _bridge.getHeight(_handle!);
          _allRenderCommands = []; // Inutile en mode C++
          _visibleRenderCommands = []; // Sera peuple par updateVisibleWindow
          _commandCount = 0;
        } else {
          // Mode Dart (Safeguard) : On recupere tout et on filtre localement
          final cmdsPtr = _bridge.getRenderCommands(_handle!, countPtr);
          _commandCount = countPtr.value;
          _contentHeight = _bridge.getHeight(_handle!);
          _allRenderCommands = _convertCommands(cmdsPtr, _commandCount);
          // Par defaut, on affiche tout (sera filtre par l'UI via updateVisibleWindow)
          _visibleRenderCommands = List.from(_allRenderCommands);
        }

        if (_contentHeight <= 0.0 && kDebugMode) {
          debugPrint('[ScoreController] WARNING: Engine returned height=0.0. Scroll might be broken.');
        }
      } finally {
        // Libere le pointeur temporaire.
        calloc.free(countPtr);
      }

      // Log centralise : s'affiche que le layout vienne de l'UI ou de la Console.
      if (kDebugMode) {
        debugPrint(
          '[ScoreController] layout width=${targetWidth.toStringAsFixed(1)} '
          'height=${_contentHeight.toStringAsFixed(1)} '
          'count=$_commandCount '
          'handle=0x${_handle!.address.toRadixString(16)}'
        );
      }
    } catch (e, stack) {
      debugPrint("[ScoreController] Layout Error: $e\n$stack");
    }

    // Si l'overlay de bench est actif, on recupere les stats immediatement.
    if (benchmarkOverlayVisible.value) {
      _refreshBenchmark();
    }

    // Notifie les observers qu'un nouveau buffer est disponible.
    renderVersion.value++;
  }

  // Convertit le buffer C en objets Dart.
  List<RenderCommand> _convertCommands(ffi.Pointer<MXMLRenderCommandC> cmdsPtr, int count) {
    if (cmdsPtr == ffi.nullptr || count == 0) {
      // if (kDebugMode) debugPrint("[ScoreController] _convertCommands: 0 commands or null ptr");
      return [];
    }
    
    // if (kDebugMode) debugPrint("[ScoreController] _convertCommands: processing $count commands");
    
    final list = <RenderCommand>[];
    for (int i = 0; i < count; i++) {
      final cmd = cmdsPtr.elementAt(i).ref;
      switch (cmd.type) {
        case MXMLRenderCommandTypeC.MXML_LINE:
          final data = cmd.data.line;
          // if (kDebugMode) debugPrint("[$i] LINE p1=(${data.p1.x},${data.p1.y}) p2=(${data.p2.x},${data.p2.y}) th=${data.thickness}");
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
          // if (kDebugMode) debugPrint("[$i] GLYPH id=${data.id} cp=$cp pos=(${data.pos.x},${data.pos.y}) scale=${data.scale}");
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
          // if (kDebugMode) debugPrint("[$i] TEXT id=${data.textId} text='$text' pos=(${data.pos.x},${data.pos.y}) size=${data.fontSize}");
          list.add(RenderText(
            text: text,
            pos: Offset(data.pos.x, data.pos.y),
            fontSize: data.fontSize,
            isItalic: data.italic == 1,
          ));
          break;
        case MXMLRenderCommandTypeC.MXML_DEBUG_RECT:
          final data = cmd.data.debugRect;
          // if (kDebugMode) debugPrint("[$i] RECT (${data.rect.x},${data.rect.y},${data.rect.width},${data.rect.height})");
          list.add(RenderDebugRect(
            rect: Rect.fromLTWH(data.rect.x, data.rect.y, data.rect.width, data.rect.height),
            strokeWidth: data.strokeWidth,
            hasFill: data.fillId != 0,
          ));
          break;
        default:
          // if (kDebugMode) debugPrint("[$i] UNKNOWN type=${cmd.type}");
          break;
      }
    }
    return list;
  }

  // Met a jour la fenetre visible pour le Culling (Chunking).
  void updateVisibleWindow(double scrollY, double viewportHeight) {
    try {
      // Mode C++ (Prioritaire si disponible)
      if (_bridge.supportsSpatialIndexing && _spatialIndexingEnabled) {
        if (_handle == null) return;
        
        _bridge.setViewport(_handle!, scrollY, viewportHeight);
        
        // On recupere uniquement les commandes visibles depuis le moteur
        final countPtr = calloc<ffi.Size>();
        try {
          final cmdsPtr = _bridge.getRenderCommands(_handle!, countPtr);
          _visibleRenderCommands = _convertCommands(cmdsPtr, countPtr.value);
        } finally {
          calloc.free(countPtr);
        }
        renderVersion.value++;
        return;
      }

      // Mode Dart (Fallback / Safeguard)
      if (_allRenderCommands.isEmpty) return;

      // Marge de securite (buffer) pour eviter les artefacts en bord d'ecran.
      const double buffer = 500.0;
      final double min = scrollY - buffer;
      final double max = scrollY + viewportHeight + buffer;

      // Filtrage lineaire : Rapide et preserve le Z-order (essentiel pour la musique).
      final filtered = _allRenderCommands.where((cmd) {
        final double y = switch (cmd) {
          RenderLine l => l.p1.dy, // On prend un point arbitraire, suffisant avec le buffer
          RenderGlyph g => g.pos.dy,
          RenderText t => t.pos.dy,
          RenderDebugRect r => r.rect.top,
        };
        return y >= min && y <= max;
      }).toList();

      // Optimisation : Ne repaint que si le nombre d'elements change significativement ou si on scroll.
      // Ici on force le repaint car on est en train de scroller.
      _visibleRenderCommands = filtered;
      
      renderVersion.value++;
    } catch (e, stack) {
      debugPrint("[ScoreController] UpdateViewport Error: $e\n$stack");
    }
  }

  // Trouve le glyphe sous la position donnee (Hit Testing).
  RenderGlyph? findGlyphAt(Offset position) {
    // On parcourt en inverse pour trouver celui dessine par dessus (Z-order).
    // On cherche uniquement dans les commandes visibles pour l'optimisation.
    for (final cmd in _visibleRenderCommands.reversed) {
      if (cmd is RenderGlyph) {
        // Heuristique : On considere une zone de touche autour du point d'ancrage.
        // Le scale * 4.0 correspond a la taille de police utilisee dans le Painter.
        final double hitSize = (cmd.scale.abs() * 4.0); 
        final double halfSize = hitSize / 2.0;
        
        // On verifie si le point est dans un carre centre sur la note.
        if ((position.dx - cmd.pos.dx).abs() < halfSize && 
            (position.dy - cmd.pos.dy).abs() < halfSize) {
          return cmd;
        }
      }
    }
    return null;
  }

  // Rafraichit les donnees de benchmark depuis le moteur.
  void _refreshBenchmark() {
    if (_handle != null) {
      lastBenchmark.value = _bridge.getPipelineBench(_handle!);
    }
  }

  // --- Playback Logic ---

  // Convertit un temps (tick) en position verticale (pixels).
  double getVerticalPositionForTick(int tick) {
    // TODO: Utiliser le bridge C++ (mxml_get_tick_y) quand disponible.
    // Pour l'instant, on retourne une valeur arbitraire pour ne pas bloquer.
    return 0.0;
  }

  void togglePlayback() {
    if (isPlaying.value) {
      pause();
    } else {
      play();
    }
  }

  void play() {
    if (isPlaying.value) return;
    isPlaying.value = true;
    
    // Simulation de lecture (scroll vertical)
    // 60fps -> ~16ms
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      // Avance de 3 pixels par frame (vitesse arbitraire pour demo)
      double nextY = playbackCursorY.value + 3.0;
      
      // Boucle si on depasse la fin
      if (_contentHeight > 0 && nextY > _contentHeight) {
        nextY = 0.0;
      }
      playbackCursorY.value = nextY;
    });
  }

  void pause() {
    isPlaying.value = false;
    _playbackTimer?.cancel();
    _playbackTimer = null;
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
    _playbackTimer?.cancel();
    renderVersion.dispose();
    leftbarOpen.dispose();
    leftbarOpacity.dispose();
    leftbarWidthRatio.dispose();
    benchmarkOverlayVisible.dispose();
    lastBenchmark.dispose();
    lastPaintTimeMs.dispose();
    playbackCursorY.dispose();
    isPlaying.dispose();
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

  // Active ou desactive l'overlay de benchmark.
  void setBenchmarkOverlayVisible(bool visible) {
    benchmarkOverlayVisible.value = visible;
    if (visible) _refreshBenchmark();
  }
}
