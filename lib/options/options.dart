import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import '../core/bridge.dart';


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

