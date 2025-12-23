import '../../core/bridge.dart';
import '../options.dart';

// Build the Global options section.
OptionSection buildGlobalOptions(MXMLBridge bridge) {
  return OptionSection(
    name: "Global Options",
    items: [
      OptionItem(
        key: "global_backend",
        label: "Backend",
        type: OptionValueType.text,
        stringGetter: bridge.getBackend,
        stringSetter: bridge.setBackend,
      ),
      OptionItem(
        key: "global_zoom",
        label: "Zoom",
        type: OptionValueType.decimal,
        doubleGetter: bridge.getZoom,
        doubleSetter: bridge.setZoom,
      ),
      OptionItem(
        key: "global_sheet_maximum_width",
        label: "Sheet Maximum Width",
        type: OptionValueType.decimal,
        doubleGetter: bridge.getSheetMaximumWidth,
        doubleSetter: bridge.setSheetMaximumWidth,
      ),
    ],
  );
}
