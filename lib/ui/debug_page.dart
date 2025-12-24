import 'package:flutter/material.dart';

import '../logic/play/play_controller.dart';
import 'widgets/console.dart';
import 'widgets/front_buffer.dart';

// Debug console page with a REPL-like command interface.
class DebugPage extends StatefulWidget {
  final PlayController playController;

  const DebugPage({super.key, required this.playController});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  // UI constants.
  static const double _pagePadding = 12.0;
  static const double _inputSpacing = 8.0;
  static const double _outputLineSpacing = 4.0;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  // Acces rapide au PlayController partage.
  PlayController get _playController => widget.playController;

  @override
  void initState() {
    super.initState();
    // Scrolle la console quand une nouvelle ligne arrive.
    _playController.consoleLines.addListener(_scrollConsoleToBottom);
  }

  @override
  void dispose() {
    _playController.consoleLines.removeListener(_scrollConsoleToBottom);
    _scrollController.dispose();
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_pagePadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: console output + input.
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _playController.consoleLines,
              builder: (context, outputLines, _) {
                return ConsoleWidget(
                  outputLines: outputLines,
                  scrollController: _scrollController,
                  inputController: _inputController,
                  focusNode: _inputFocusNode,
                  onSubmitted: _submitCommand,
                  onSend: () => _submitCommand(_inputController.text),
                  padding: const EdgeInsets.all(_pagePadding),
                  lineSpacing: _outputLineSpacing,
                  inputSpacing: _inputSpacing,
                  hintText: "Enter command (help for list)",
                );
              },
            ),
          ),
          const SizedBox(width: _inputSpacing),
          // Right: frontbuffer text output.
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _playController.frontBufferLines,
              builder: (context, frontBufferLines, _) {
                return FrontBufferWidget(
                  lines: frontBufferLines,
                  title: "FrontBuffer",
                  padding: const EdgeInsets.all(_pagePadding),
                  lineSpacing: _outputLineSpacing,
                  onWidthChanged: _playController.updateLayoutWidth,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Scrolle la console en bas apres ajout.
  void _scrollConsoleToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // Envoie une commande au PlayController.
  void _submitCommand(String line) {
    _playController.executeCommand(line);
    _inputController.clear();
    _inputFocusNode.requestFocus();
  }
}
