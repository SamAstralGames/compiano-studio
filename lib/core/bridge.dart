import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// --- Type Definitions ---

// Handle opaque pour l'instance du convertisseur
base class MXMLHandle extends Opaque {}

// Types de base
typedef MXMLStringId = Uint32;
typedef MXMLGlyphId = Uint16;

// Structs
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

// Structures de données des commandes
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

// Enum simulation
class MXMLRenderCommandTypeC {
  static const int MXML_GLYPH = 0;
  static const int MXML_LINE = 1;
  static const int MXML_TEXT = 2;
  static const int MXML_DEBUG_RECT = 3;
  static const int MXML_PATH = 4;
}

// Union pour RenderCommand
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

// --- FFI Signatures ---

// mXMLHandle* mxml_create();
typedef mxml_create_func = Pointer<MXMLHandle> Function();
typedef MxmlCreate = Pointer<MXMLHandle> Function();

// void mxml_destroy(mXMLHandle* handle);
typedef mxml_destroy_func = Void Function(Pointer<MXMLHandle>);
typedef MxmlDestroy = void Function(Pointer<MXMLHandle>);

// int mxml_load_file(mXMLHandle* handle, const char* path);
typedef mxml_load_file_func = Int32 Function(Pointer<MXMLHandle>, Pointer<Utf8>);
typedef MxmlLoadFile = int Function(Pointer<MXMLHandle>, Pointer<Utf8>);

// void mxml_layout(mXMLHandle* handle, float width);
typedef mxml_layout_func = Void Function(Pointer<MXMLHandle>, Float);
typedef MxmlLayout = void Function(Pointer<MXMLHandle>, double);

// float mxml_get_height(mXMLHandle* handle);
typedef mxml_get_height_func = Float Function(Pointer<MXMLHandle>);
typedef MxmlGetHeight = double Function(Pointer<MXMLHandle>);

// const mXMLRenderCommandC* mxml_get_render_commands(mXMLHandle* handle, size_t* count);
typedef mxml_get_render_commands_func = Pointer<MXMLRenderCommandC> Function(Pointer<MXMLHandle>, Pointer<Size>);
typedef MxmlGetRenderCommands = Pointer<MXMLRenderCommandC> Function(Pointer<MXMLHandle>, Pointer<Size>);

// const char* mxml_get_string(mXMLHandle* handle, mXMLStringId id);
typedef mxml_get_string_func = Pointer<Utf8> Function(Pointer<MXMLHandle>, Uint32);
typedef MxmlGetString = Pointer<Utf8> Function(Pointer<MXMLHandle>, int);

// int mxml_write_svg_to_file(mXMLHandle* handle, const char* filepath);
typedef mxml_write_svg_to_file_func = Int32 Function(Pointer<MXMLHandle>, Pointer<Utf8>);
typedef MxmlWriteSvgToFile = int Function(Pointer<MXMLHandle>, Pointer<Utf8>);


class MXMLBridge {
  static late final DynamicLibrary _dylib;
  
  static late final MxmlCreate _create;
  static late final MxmlDestroy _destroy;
  static late final MxmlLoadFile _loadFile;
  static late final MxmlLayout _layout;
  static late final MxmlGetHeight _getHeight;
  static late final MxmlGetRenderCommands _getRenderCommands;
  static late final MxmlGetString _getString;
  static late final MxmlWriteSvgToFile _writeSvgToFile;

  static bool _initialized = false;

  static void initialize() {
    if (_initialized) return;

    if (Platform.isLinux) {
      _dylib = DynamicLibrary.open('libmxmlconverter.so');
    } else if (Platform.isAndroid) {
      _dylib = DynamicLibrary.open('libmxmlconverter.so');
    } else if (Platform.isMacOS || Platform.isIOS) {
      _dylib = DynamicLibrary.open('libmxmlconverter.dylib'); 
    } else if (Platform.isWindows) {
      _dylib = DynamicLibrary.open('mxmlconverter.dll');
    } else {
      throw UnsupportedError('Platform not supported');
    }

    _create = _dylib.lookupFunction<mxml_create_func, MxmlCreate>('mxml_create');
    _destroy = _dylib.lookupFunction<mxml_destroy_func, MxmlDestroy>('mxml_destroy');
    _loadFile = _dylib.lookupFunction<mxml_load_file_func, MxmlLoadFile>('mxml_load_file');
    _layout = _dylib.lookupFunction<mxml_layout_func, MxmlLayout>('mxml_layout');
    _getHeight = _dylib.lookupFunction<mxml_get_height_func, MxmlGetHeight>('mxml_get_height');
    _getRenderCommands = _dylib.lookupFunction<mxml_get_render_commands_func, MxmlGetRenderCommands>('mxml_get_render_commands');
    _getString = _dylib.lookupFunction<mxml_get_string_func, MxmlGetString>('mxml_get_string');
    _writeSvgToFile = _dylib.lookupFunction<mxml_write_svg_to_file_func, MxmlWriteSvgToFile>('mxml_write_svg_to_file');

    _initialized = true;
  }

  // --- Public Dart API ---

  Pointer<MXMLHandle> create() {
    return _create();
  }

  void destroy(Pointer<MXMLHandle> handle) {
    _destroy(handle);
  }

  bool loadFile(Pointer<MXMLHandle> handle, String path) {
    final pathPtr = path.toNativeUtf8();
    try {
      final result = _loadFile(handle, pathPtr);
      return result != 0;
    } finally {
      calloc.free(pathPtr);
    }
  }

  void layout(Pointer<MXMLHandle> handle, double width) {
    _layout(handle, width);
  }

  double getHeight(Pointer<MXMLHandle> handle) {
    return _getHeight(handle);
  }

  Pointer<MXMLRenderCommandC> getRenderCommands(Pointer<MXMLHandle> handle, Pointer<Size> countOut) {
    return _getRenderCommands(handle, countOut);
  }
  
  String getString(Pointer<MXMLHandle> handle, int id) {
    final ptr = _getString(handle, id);
    if (ptr == nullptr) return "";
    return ptr.toDartString();
  }

  bool writeSvgToFile(Pointer<MXMLHandle> handle, String filepath) {
    final pathPtr = filepath.toNativeUtf8();
    try {
      final result = _writeSvgToFile(handle, pathPtr);
      return result != 0;
    } finally {
      calloc.free(pathPtr);
    }
  }
}