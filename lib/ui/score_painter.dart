import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../logic/models/render_commands.dart';

class ScorePainter extends CustomPainter {
  // Memoise les dernieres infos loggees pour eviter le spam.
  static int? _lastLoggedCommandCount;

  // Plus de pointeurs ici ! Seulement des objets Dart.
  final List<RenderCommand> commands;
  final bool isDarkMode;

  ScorePainter({
    required this.commands,
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

    if (commands.isEmpty) {
      return;
    }

    // Itération sur les commandes
    for (final cmd in commands) {
      switch (cmd) {
        case RenderLine():
          _drawLine(canvas, cmd, mainColor);
          break;
        case RenderGlyph():
          _drawGlyph(canvas, cmd, mainColor);
          break;
        case RenderText():
          _drawText(canvas, cmd, mainColor);
          break;
        case RenderDebugRect():
          _drawDebugRect(canvas, cmd);
          break;
      }
    }
  }

  void _drawLine(Canvas canvas, RenderLine line, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = line.thickness
      ..style = PaintingStyle.stroke;

    canvas.drawLine(line.p1, line.p2, paint);
  }

  void _drawGlyph(Canvas canvas, RenderGlyph glyphCmd, Color color) {
    if (glyphCmd.codepoint == 0) {
      // Fallback debug
      canvas.drawCircle(glyphCmd.pos, 2.0, Paint()..color = Colors.red);
      return;
    }

    final char = String.fromCharCode(glyphCmd.codepoint);
    
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
    canvas.translate(glyphCmd.pos.dx, glyphCmd.pos.dy);
    
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

  void _drawText(Canvas canvas, RenderText textCmd, Color color) {
    if (textCmd.text.isEmpty) return;

    final textStyle = TextStyle(
      color: color,
      fontSize: textCmd.fontSize,
      fontStyle: textCmd.isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily: 'Serif', // Fallback
    );

    final textSpan = TextSpan(text: textCmd.text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    // mXML position is usually baseline or top-left depending on element.
    // Assuming baseline for text here, but might need adjustment.
    // Let's draw at position for now.
    textPainter.paint(canvas, Offset(textCmd.pos.dx, textCmd.pos.dy - textCmd.fontSize)); 
  }

  void _drawDebugRect(Canvas canvas, RenderDebugRect rectCmd) {
    // Fill
    if (rectCmd.hasFill) { 
       // Simuler couleur debug semi-transparente bleue
       canvas.drawRect(rectCmd.rect, Paint()..color = Colors.blue.withOpacity(0.1));
    }

    // Stroke
    if (rectCmd.strokeWidth > 0) {
       canvas.drawRect(rectCmd.rect, Paint()
         ..color = Colors.blue
         ..style = PaintingStyle.stroke
         ..strokeWidth = rectCmd.strokeWidth);
    }
  }

  @override
  bool shouldRepaint(covariant ScorePainter oldDelegate) {
    // Comparaison simple de référence de liste (la liste est recréée à chaque layout)
    return oldDelegate.commands != commands ||
           oldDelegate.isDarkMode != isDarkMode;
  }

  // Log les valeurs utiles uniquement si elles changent.
  void _logDiagnostics() {
    if (!kDebugMode) return;
    
    final int commandCountValue = commands.length;
    final bool hasChanged = _lastLoggedCommandCount != commandCountValue;

    if (!hasChanged) return;

    _lastLoggedCommandCount = commandCountValue;
    debugPrint('[ScorePainter] count=$commandCountValue');
  }
}
