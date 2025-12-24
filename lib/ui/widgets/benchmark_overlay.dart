import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/bridge.dart';

class BenchmarkOverlay extends StatelessWidget {
  final ValueListenable<bool> visible;
  final ValueListenable<MXMLPipelineBench?> lastBenchmark;
  final ValueListenable<double> lastPaintTimeMs;
  final ValueListenable<double> currentFps;

  const BenchmarkOverlay({
    super.key,
    required this.visible,
    required this.lastBenchmark,
    required this.lastPaintTimeMs,
    required this.currentFps,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 25,
      top: 50,
      child: ValueListenableBuilder<bool>(
        valueListenable: visible,
        builder: (context, isVisible, _) {
          if (!isVisible) return const SizedBox.shrink();

          return IgnorePointer(
            ignoring: true,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10.0),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Benchmarks",
                        style: _textStyle(context)
                            .copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<MXMLPipelineBench?>(
                      valueListenable: lastBenchmark,
                      builder: (context, bench, _) {
                        if (bench == null) return const SizedBox.shrink();
                        return Column(
                          children: [
                            _buildBenchItem(context, "Total Pipeline",
                                bench.pipelineTotalMs,
                                isTotal: true),
                            const Divider(color: Colors.white24),
                            _buildBenchSection(context, "Input",
                                bench.inputXmlLoadMs + bench.inputModelBuildMs),
                            _buildBenchItem(
                                context, "  XML Load", bench.inputXmlLoadMs),
                            _buildBenchItem(context, "  Model Build",
                                bench.inputModelBuildMs),
                            _buildBenchSection(
                                context, "Layout", bench.layoutTotalMs),
                            _buildBenchItem(
                                context, "  Metrics", bench.layoutMetricsMs),
                            _buildBenchItem(context, "  Line Breaking",
                                bench.layoutLineBreakingMs),
                            _buildBenchSection(
                                context, "Render", bench.renderCommandsMs),
                            _buildBenchSection(context, "Export",
                                bench.exportSerializeSvgMs),
                          ],
                        );
                      },
                    ),
                    const Divider(color: Colors.white24),
                    ValueListenableBuilder<double>(
                      valueListenable: lastPaintTimeMs,
                      builder: (context, ms, _) {
                        return _buildBenchItem(context, "Flutter Paint", ms,
                            isTotal: true);
                      },
                    ),
                    const Divider(color: Colors.white24),
                    ValueListenableBuilder<double>(
                      valueListenable: currentFps,
                      builder: (context, fps, _) {
                        return _buildBenchItem(context, "Real FPS", fps,
                            isTotal: true, unit: "fps");
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TextStyle _textStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 10,
            color: Colors.white,
          );

  Widget _buildBenchSection(BuildContext context, String label, double ms) {
    final style = _textStyle(context).copyWith(fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text("${ms.toStringAsFixed(2)} ms", style: style),
        ],
      ),
    );
  }

  Widget _buildBenchItem(BuildContext context, String label, double value,
      {bool isTotal = false, String unit = "ms"}) {
    final baseStyle = _textStyle(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: baseStyle.copyWith(color: Colors.white70)),
          Text("${value.toStringAsFixed(2)} $unit",
              style: baseStyle.copyWith(
                  color: isTotal ? Colors.greenAccent : Colors.white,
                  fontWeight:
                      isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}