import 'dart:ffi' as ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/bridge.dart';

class ScorePainter extends CustomPainter {
  // Memoise les dernieres infos loggees pour eviter le spam.
  static int? _lastLoggedCommandCount;
  static int? _lastLoggedCommandsAddress;
  static int? _lastLoggedHandleAddress;
  static int? _lastLoggedFirstType;

  final ffi.Pointer<MXMLRenderCommandC>? commands;
  final int commandCount;
  final ffi.Pointer<MXMLHandle>? handle; // Pour récupérer les strings
  final MXMLBridge bridge;
  final bool isDarkMode;

  ScorePainter({
    required this.commands,
    required this.commandCount,
    required this.handle,
    required this.bridge,
    required Listenable repaint,
    this.isDarkMode = false,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    // Fond géré par le Container parent (ou dessiné ici si besoin)
    // Pour être sûr, on ne dessine pas de fond ici pour laisser la transparence, 
    // ou on dessine le bgColor si on veut. Le Container l'a déjà.
    
    // Couleur principale (Lignes, Texte)
    final mainColor = isDarkMode ? Colors.white : Colors.black;

    // Log synthétique sans boucle pour éviter le spam.
    _logDiagnostics();

    if (commands == null || commandCount == 0 || handle == null) {
      return;
    }

    // Itération sur les commandes
    for (int i = 0; i < commandCount; i++) {
      final cmd = commands!.elementAt(i).ref;

      switch (cmd.type) {
        case MXMLRenderCommandTypeC.MXML_LINE:
          _drawLine(canvas, cmd.data.line, mainColor);
          break;
        case MXMLRenderCommandTypeC.MXML_GLYPH:
          _drawGlyph(canvas, cmd.data.glyph, mainColor);
          break;
        case MXMLRenderCommandTypeC.MXML_TEXT:
          _drawText(canvas, cmd.data.text, mainColor);
          break;
        case MXMLRenderCommandTypeC.MXML_DEBUG_RECT:
          _drawDebugRect(canvas, cmd.data.debugRect);
          break;
      }
    }
  }

  void _drawLine(Canvas canvas, MXMLLineDataC line, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = line.thickness
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(line.p1.x, line.p1.y),
      Offset(line.p2.x, line.p2.y),
      paint,
    );
  }

  void _drawGlyph(Canvas canvas, MXMLGlyphDataC glyphCmd, Color color) {
    final codepoint = bridge.getGlyphCodepoint(handle!, glyphCmd.id);
    if (codepoint == 0) {
      // Fallback debug
      canvas.drawCircle(Offset(glyphCmd.pos.x, glyphCmd.pos.y), 2.0, Paint()..color = Colors.red);
      return;
    }

    final char = String.fromCharCode(codepoint);
    
    // Le scale est souvent utilisé pour la taille en pixels. 
    // SMuFL Bravura : 1 staff space = 1/4 em. 
    // Si scale = taille en pixels d'un staff space ? Ou facteur global ?
    // Supposons que glyphCmd.scale est la taille de la fonte en pixels ou un facteur.
    // Dans mxml-svg-backend: scale(arg.scale, -arg.scale).
    // Si arg.scale est grand (ex: 20), c'est la taille.
    
    // Testons avec scale directement comme fontSize.
    // Attention: SMuFL glyphs are usually designed for 1000 units per em.
    // Il faut probablement ajuster la taille.
    // Si le moteur C++ envoie la taille en pixels, on l'utilise.
    
    final textStyle = TextStyle(
      fontFamily: 'Bravura',
      fontSize: glyphCmd.scale.abs() * 4.0, // Facteur empirique, SMuFL est souvent petit. A ajuster.
      color: color,
      height: 1.0, // Important pour le positionnement précis
    );

    final textSpan = TextSpan(text: char, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Gestion de l'inversion Y (si scale < 0)
    // Dans mxml-svg-backend: transform="translate(x, y) scale(s, -s)"
    // Cela signifie que l'origine SVG est en bas (ou haut inversé).
    
    canvas.save();
    canvas.translate(glyphCmd.pos.x, glyphCmd.pos.y);
    
    // Si scale est négatif, le moteur demande un flip Y.
    // En Flutter, Y est vers le bas.
    // Si le moteur C++ fonctionne en Y vers le haut (Cartésien), et que Flutter est Y vers le bas :
    // il faut probablement inverser.
    
    if (glyphCmd.scale < 0) {
       canvas.scale(1.0, -1.0);
    }
    
    // SMuFL origin is the baseline of the staff.
    // TextPainter draws from top-left of the bounding box usually, but can position at baseline.
    // We want to draw at (0,0) relative to the translated position.
    // Offset correction might be needed depending on TextPainter alignment.
    // Try centering for now or drawing at 0,0 - metrics.ascent
    
    // offset to align baseline to 0,0
    // textPainter.paint(canvas, Offset(0, -textPainter.computeDistanceToActualBaseline(TextBaseline.alphabetic)));
    
    // Pour l'instant, dessinons à 0,0 et voyons. 
    // Le SVG backend fait translate(x, y). Donc (x,y) est l'origine du glyphe.
    textPainter.paint(canvas, Offset.zero); // Offset(-textPainter.width / 2, -textPainter.height / 2) ?
    
    canvas.restore();
  }

  void _drawText(Canvas canvas, MXMLTextDataC textCmd, Color color) {
    final text = bridge.getString(handle!, textCmd.textId);
    if (text.isEmpty) return;

    final textStyle = TextStyle(
      color: color,
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
    return oldDelegate.commands != commands || 
           oldDelegate.commandCount != commandCount ||
           oldDelegate.isDarkMode != isDarkMode;
  }

  // Log les valeurs utiles uniquement si elles changent.
  void _logDiagnostics() {
    if (!kDebugMode) return;

    final int commandCountValue = commandCount;
    final int commandsAddress = commands == null ? 0 : commands!.address;
    final int handleAddress = handle == null ? 0 : handle!.address;
    final bool isNullPointer = commands != null && commands == ffi.nullptr;
    int? firstType;

    // On lit seulement la premiere commande, pas de boucle.
    if (commands != null && commandCount > 0) {
      firstType = commands!.ref.type;
    }

    final bool hasChanged = _lastLoggedCommandCount != commandCountValue ||
        _lastLoggedCommandsAddress != commandsAddress ||
        _lastLoggedHandleAddress != handleAddress ||
        _lastLoggedFirstType != firstType;

    if (!hasChanged) return;

    _lastLoggedCommandCount = commandCountValue;
    _lastLoggedCommandsAddress = commandsAddress;
    _lastLoggedHandleAddress = handleAddress;
    _lastLoggedFirstType = firstType;

    debugPrint(
      '[ScorePainter] count=$commandCountValue commands=0x${commandsAddress.toRadixString(16)} '
      'handle=0x${handleAddress.toRadixString(16)} firstType=${firstType ?? -1} '
      'isNullPtr=$isNullPointer',
    );
  }
}
