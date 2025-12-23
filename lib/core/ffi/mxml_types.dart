import 'dart:ffi';

// Handle opaque pour l'instance du convertisseur.
base class MXMLHandle extends Opaque {}

// Handle opaque pour les options.
base class MXMLOptions extends Opaque {}

// Types de base.
typedef MXMLStringId = Uint32;
typedef MXMLGlyphId = Uint16;

// Structs.
base class MXMLPointC extends Struct {
  @Float()
  external double x;

  @Float()
  external double y;
}

base class MXMLRectC extends Struct {
  @Float()
  external double x;

  @Float()
  external double y;

  @Float()
  external double width;

  @Float()
  external double height;
}

// Structures de donnees des commandes.
base class MXMLGlyphDataC extends Struct {
  @Uint16()
  external int id;

  external MXMLPointC pos;

  @Float()
  external double scale;
}

base class MXMLLineDataC extends Struct {
  external MXMLPointC p1;
  external MXMLPointC p2;

  @Float()
  external double thickness;
}

base class MXMLTextDataC extends Struct {
  @Uint32()
  external int textId;

  external MXMLPointC pos;

  @Float()
  external double fontSize;

  @Int8()
  external int italic; // 1 = true, 0 = false
}

base class MXMLDebugRectDataC extends Struct {
  external MXMLRectC rect;

  @Uint32()
  external int cssClassId;

  @Uint32()
  external int strokeId;

  @Float()
  external double strokeWidth;

  @Uint32()
  external int fillId;

  @Float()
  external double opacity;
}

base class MXMLPathDataC extends Struct {
  @Uint32()
  external int dId;

  @Uint32()
  external int cssClassId;

  @Uint32()
  external int fillId;

  @Float()
  external double opacity;
}

// Benchmarks pipeline (millisecondes), regroupes par layer.
base class MXMLPipelineBenchC extends Struct {
  @Float()
  external double inputXmlLoadMs;

  @Float()
  external double inputModelBuildMs;

  @Float()
  external double inputTotalMs;

  @Float()
  external double layoutMetricsMs;

  @Float()
  external double layoutLineBreakingMs;

  @Float()
  external double layoutTotalMs;

  @Float()
  external double renderCommandsMs;

  @Float()
  external double exportSerializeSvgMs;

  @Float()
  external double pipelineTotalMs;
}

// Enum simulation.
class MXMLRenderCommandTypeC {
  static const int MXML_GLYPH = 0;
  static const int MXML_LINE = 1;
  static const int MXML_TEXT = 2;
  static const int MXML_DEBUG_RECT = 3;
  static const int MXML_PATH = 4;
}

// Union pour RenderCommand.
base class MXMLRenderCommandUnion extends Union {
  external MXMLGlyphDataC glyph;
  external MXMLLineDataC line;
  external MXMLTextDataC text;
  external MXMLDebugRectDataC debugRect;
  external MXMLPathDataC path;
}

base class MXMLRenderCommandC extends Struct {
  @Uint8()
  external int type;

  external MXMLRenderCommandUnion data;
}

// Conteneur Dart pour les benchmarks pipeline.
class MXMLPipelineBench {
  final double inputXmlLoadMs;
  final double inputModelBuildMs;
  final double inputTotalMs;
  final double layoutMetricsMs;
  final double layoutLineBreakingMs;
  final double layoutTotalMs;
  final double renderCommandsMs;
  final double exportSerializeSvgMs;
  final double pipelineTotalMs;

  // Construit une copie Dart depuis la struct C.
  MXMLPipelineBench({
    required this.inputXmlLoadMs,
    required this.inputModelBuildMs,
    required this.inputTotalMs,
    required this.layoutMetricsMs,
    required this.layoutLineBreakingMs,
    required this.layoutTotalMs,
    required this.renderCommandsMs,
    required this.exportSerializeSvgMs,
    required this.pipelineTotalMs,
  });

  // Convertit la struct C en copie Dart pour eviter de garder un pointeur.
  static MXMLPipelineBench fromC(MXMLPipelineBenchC bench) {
    return MXMLPipelineBench(
      inputXmlLoadMs: bench.inputXmlLoadMs,
      inputModelBuildMs: bench.inputModelBuildMs,
      inputTotalMs: bench.inputTotalMs,
      layoutMetricsMs: bench.layoutMetricsMs,
      layoutLineBreakingMs: bench.layoutLineBreakingMs,
      layoutTotalMs: bench.layoutTotalMs,
      renderCommandsMs: bench.renderCommandsMs,
      exportSerializeSvgMs: bench.exportSerializeSvgMs,
      pipelineTotalMs: bench.pipelineTotalMs,
    );
  }
}
