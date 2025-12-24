import 'package:flutter/material.dart';

// Console widget: output panel + input row.
class ConsoleWidget extends StatelessWidget {
  final List<String> outputLines;
  final ScrollController scrollController;
  final TextEditingController inputController;
  final FocusNode? focusNode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSend;
  final EdgeInsets padding;
  final double lineSpacing;
  final double inputSpacing;
  final String hintText;

  const ConsoleWidget({
    super.key,
    required this.outputLines,
    required this.scrollController,
    required this.inputController,
    this.focusNode,
    required this.onSubmitted,
    required this.onSend,
    required this.padding,
    required this.lineSpacing,
    required this.inputSpacing,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    // Empile la sortie de console et la zone d'entree.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildOutputPanel(context)),
        SizedBox(height: inputSpacing),
        _buildInputRow(),
      ],
    );
  }

  // Construit la liste des sorties console.
  Widget _buildOutputPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListView.separated(
        controller: scrollController,
        padding: padding,
        itemCount: outputLines.length,
        itemBuilder: (context, index) {
          return Text(
            outputLines[index],
            style: const TextStyle(fontFamily: "monospace"),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: lineSpacing);
        },
      ),
    );
  }

  // Construit la zone d'entree et le bouton d'envoi.
  Widget _buildInputRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: inputController,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: hintText,
            ),
            onSubmitted: onSubmitted,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: onSend,
        ),
      ],
    );
  }
}
