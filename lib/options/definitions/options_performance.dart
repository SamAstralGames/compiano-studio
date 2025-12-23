import '../../core/bridge.dart';
import '../options.dart';

// Build the Performance options section.
OptionSection buildPerformanceOptions(MXMLBridge bridge) {
  return OptionSection(
    name: "Performance Options",
    items: [
      OptionItem(
        key: "performance_enable_glyph_cache",
        label: "Enable Glyph Cache",
        type: OptionValueType.boolean,
        boolGetter: bridge.getPerformanceEnableGlyphCache,
        boolSetter: bridge.setPerformanceEnableGlyphCache,
      ),
      OptionItem(
        key: "performance_enable_spatial_indexing",
        label: "Enable Spatial Indexing",
        type: OptionValueType.boolean,
        boolGetter: bridge.getPerformanceEnableSpatialIndexing,
        boolSetter: bridge.setPerformanceEnableSpatialIndexing,
      ),
      OptionItem(
        key: "performance_sky_bottom_line_batch_min_measures",
        label: "Sky Bottom Line Batch Min Measures",
        type: OptionValueType.integer,
        intGetter: bridge.getPerformanceSkyBottomLineBatchMinMeasures,
        intSetter: bridge.setPerformanceSkyBottomLineBatchMinMeasures,
      ),
      OptionItem(
        key: "performance_svg_precision",
        label: "SVG Precision",
        type: OptionValueType.integer,
        intGetter: bridge.getPerformanceSvgPrecision,
        intSetter: bridge.setPerformanceSvgPrecision,
      ),
      OptionItem(
        key: "performance_bench_enable",
        label: "Bench Enable",
        type: OptionValueType.boolean,
        boolGetter: bridge.getPerformanceBenchEnable,
        boolSetter: bridge.setPerformanceBenchEnable,
      ),
    ],
  );
}
