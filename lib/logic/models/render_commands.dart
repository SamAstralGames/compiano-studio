import 'dart:ui';

/// Classe de base pour toutes les commandes de rendu (Pure Dart).
sealed class RenderCommand {}

class RenderLine extends RenderCommand {
  final Offset p1;
  final Offset p2;
  final double thickness;

  RenderLine({required this.p1, required this.p2, required this.thickness});
}

class RenderGlyph extends RenderCommand {
  final int codepoint;
  final Offset pos;
  final double scale;
  final int id; // Pour debug

  RenderGlyph({
    required this.codepoint,
    required this.pos,
    required this.scale,
    required this.id,
  });
}

class RenderText extends RenderCommand {
  final String text;
  final Offset pos;
  final double fontSize;
  final bool isItalic;

  RenderText({
    required this.text,
    required this.pos,
    required this.fontSize,
    required this.isItalic,
  });
}

class RenderDebugRect extends RenderCommand {
  final Rect rect;
  final double strokeWidth;
  final bool hasFill;

  RenderDebugRect({required this.rect, required this.strokeWidth, required this.hasFill});
}