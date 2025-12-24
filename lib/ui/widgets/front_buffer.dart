import 'package:flutter/material.dart';

// Front buffer widget: affiche des lignes et remonte la largeur disponible.
class FrontBufferWidget extends StatelessWidget {
  final List<String> lines;
  final String title;
  final EdgeInsets padding;
  final double lineSpacing;
  final ValueChanged<double>? onWidthChanged;

  const FrontBufferWidget({
    super.key,
    required this.lines,
    required this.title,
    required this.padding,
    required this.lineSpacing,
    this.onWidthChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Mesure la largeur pour l'usage du layout FFI si necessaire.
    return LayoutBuilder(
      builder: (context, constraints) {
        // Remonte la largeur si elle est exploitable.
        if (constraints.maxWidth > 0 && onWidthChanged != null) {
          onWidthChanged!(constraints.maxWidth);
        }
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: padding,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: lines.isEmpty
                    ? const Center(child: Text("No frontbuffer data."))
                    : ListView.separated(
                        padding: padding,
                        itemCount: lines.length,
                        itemBuilder: (context, index) {
                          return Text(
                            lines[index],
                            style: const TextStyle(fontFamily: "monospace"),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: lineSpacing);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
