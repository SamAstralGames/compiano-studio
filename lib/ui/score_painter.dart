import 'dart:ffi' as ffi;
import 'package:flutter/material.dart';
import '../core/bridge.dart';

class ScorePainter extends CustomPainter {
  final ffi.Pointer<MXMLRenderCommandC>? commands;
  final int commandCount;
  final ffi.Pointer<MXMLHandle>? handle; // Pour récupérer les strings
  final MXMLBridge bridge;

  ScorePainter({
    required this.commands,
    required this.commandCount,
    required this.handle,
    required this.bridge,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (commands == null || commandCount == 0 || handle == null) {
      // Dessiner un placeholder si vide
      final paint = Paint()..color = Colors.grey.withOpacity(0.2);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      return;
    }

    // Fond blanc
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.white);

    // Itération sur les commandes
    for (int i = 0; i < commandCount; i++) {
      final cmd = commands!.elementAt(i).ref;

      switch (cmd.type) {
        case MXMLRenderCommandTypeC.MXML_LINE:
          _drawLine(canvas, cmd.data.line);
          break;
        case MXMLRenderCommandTypeC.MXML_GLYPH:
          // TODO: Implémenter le rendu des glyphes (nécessite Font)
          // Pour l'instant on dessine un petit cercle rouge pour debugger
           _drawDebugPoint(canvas, cmd.data.glyph.pos, Colors.red);
          break;
        case MXMLRenderCommandTypeC.MXML_TEXT:
          _drawText(canvas, cmd.data.text);
          break;
        case MXMLRenderCommandTypeC.MXML_DEBUG_RECT:
          _drawDebugRect(canvas, cmd.data.debugRect);
          break;
        // case MXMLRenderCommandTypeC.MXML_PATH:
        //   _drawPath(canvas, cmd.data.path);
        //   break;
      }
    }
  }

  void _drawLine(Canvas canvas, MXMLLineDataC line) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = line.thickness
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(line.p1.x, line.p1.y),
      Offset(line.p2.x, line.p2.y),
      paint,
    );
  }

  void _drawDebugPoint(Canvas canvas, MXMLPointC pos, Color color) {
     canvas.drawCircle(Offset(pos.x, pos.y), 2.0, Paint()..color = color);
  }

  void _drawText(Canvas canvas, MXMLTextDataC textCmd) {
    final text = bridge.getString(handle!, textCmd.textId);
    if (text.isEmpty) return;

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: textCmd.fontSize,
      fontStyle: textCmd.italic == 1 ? FontStyle.italic : FontStyle.normal,
      fontFamily: 'Serif', // Fallback
    );

    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    // mXML position is usually baseline or top-left depending on element.
    // Assuming baseline for text here, but might need adjustment.
    // Let's draw at position for now.
    textPainter.paint(canvas, Offset(textCmd.pos.x, textCmd.pos.y - textCmd.fontSize)); 
  }

  void _drawDebugRect(Canvas canvas, MXMLDebugRectDataC rectCmd) {
    final rect = Rect.fromLTWH(
        rectCmd.rect.x, rectCmd.rect.y, rectCmd.rect.width, rectCmd.rect.height);
    
    // Fill
    if (rectCmd.fillId != 0) { // 0 = null/transparent assumption for ID? Or verify
       // Simuler couleur debug semi-transparente bleue
       canvas.drawRect(rect, Paint()..color = Colors.blue.withOpacity(0.1));
    }

    // Stroke
    if (rectCmd.strokeWidth > 0) {
       canvas.drawRect(rect, Paint()
         ..color = Colors.blue
         ..style = PaintingStyle.stroke
         ..strokeWidth = rectCmd.strokeWidth);
    }
  }

  @override
  bool shouldRepaint(covariant ScorePainter oldDelegate) {
    return oldDelegate.commands != commands || oldDelegate.commandCount != commandCount;
  }
}
