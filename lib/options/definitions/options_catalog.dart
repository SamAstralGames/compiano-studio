import '../../core/bridge.dart';
import '../options.dart';
import 'options_colors.dart';
import 'options_global.dart';
import 'options_layout.dart';
import 'options_line_breaking.dart';
import 'options_notation.dart';
import 'options_performance.dart';
import 'options_rendering.dart';

// Build the full ordered list of option sections.
List<OptionSection> buildOptionSections(MXMLBridge bridge) {
  return [
    buildRenderingOptions(bridge),
    buildLayoutOptions(bridge),
    buildLineBreakingOptions(bridge),
    buildNotationOptions(bridge),
    buildColorOptions(bridge),
    buildPerformanceOptions(bridge),
    buildGlobalOptions(bridge),
  ];
}
