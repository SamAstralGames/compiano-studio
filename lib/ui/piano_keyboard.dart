import 'package:flutter/material.dart';

class PianoKeyboard extends StatelessWidget {
  // On reçoit l'ensemble des notes actives (ex: {60, 64, 67} pour un accord de Do Majeur)
  final Set<int> activeNotes;
  final int firstKey;
  final int lastKey;

  const PianoKeyboard({
    super.key,
    this.activeNotes = const {},
    this.firstKey = 21, // Par défaut A0 (Piano 88 touches)
    this.lastKey = 108, // Par défaut C8
  });

  // Helper statique accessible de l'extérieur pour les calculs de layout
  static bool isBlackKey(int note) {
    final int keyInOctave = note % 12;
    return [1, 3, 6, 8, 10].contains(keyInOctave);
  }

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder nous donne la largeur disponible pour dessiner le clavier
    return LayoutBuilder(
      builder: (context, constraints) {
        // On utilise la hauteur max disponible (imposée par le parent), 
        // sinon on fallback sur 160 si infini.
        final double height = constraints.maxHeight.isFinite ? constraints.maxHeight : 160.0;

        return CustomPaint(
          size: Size(constraints.maxWidth, height),
          painter: _PianoPainter(
            activeNotes: activeNotes,
            firstKey: firstKey,
            lastKey: lastKey,
          ),
        );
      },
    );
  }
}

class _PianoPainter extends CustomPainter {
  final Set<int> activeNotes;
  final int firstKey;
  final int lastKey;

  _PianoPainter({
    required this.activeNotes,
    required this.firstKey,
    required this.lastKey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final whiteKeyPaint = Paint()..color = Colors.white;
    final blackKeyPaint = Paint()..color = Colors.black;
    final activePaint = Paint()..color = Colors.redAccent; // Couleur quand appuyé
    final linePaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    // 1. Compter combien de touches blanches on a au total pour calculer la largeur
    int whiteKeyCount = 0;
    for (int i = firstKey; i <= lastKey; i++) {
      if (!PianoKeyboard.isBlackKey(i)) whiteKeyCount++;
    }

    final whiteKeyWidth = size.width / whiteKeyCount;
    final blackKeyHeight = size.height * 0.6;
    final blackKeyWidth = whiteKeyWidth * 0.65;

    // 2. Dessiner les touches BLANCHES
    int currentWhiteKeyIndex = 0;
    for (int note = firstKey; note <= lastKey; note++) {
      if (PianoKeyboard.isBlackKey(note)) continue;

      final left = currentWhiteKeyIndex * whiteKeyWidth;
      final rect = Rect.fromLTWH(left, 0, whiteKeyWidth, size.height);

      // Si la note est active, on la colorie, sinon blanc
      canvas.drawRect(rect, activeNotes.contains(note) ? activePaint : whiteKeyPaint);
      // Bordure
      canvas.drawLine(Offset(left, 0), Offset(left, size.height), linePaint);
      
      currentWhiteKeyIndex++;
    }
    // Dernière ligne à droite
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), linePaint);

    // 3. Dessiner les touches NOIRES (par dessus)
    currentWhiteKeyIndex = 0;
    for (int note = firstKey; note <= lastKey; note++) {
      if (!PianoKeyboard.isBlackKey(note)) {
        currentWhiteKeyIndex++;
        continue;
      }

      // Une touche noire est positionnée sur la séparation de la touche blanche précédente
      // currentWhiteKeyIndex a déjà été incrémenté par la touche blanche précédente
      final left = (currentWhiteKeyIndex * whiteKeyWidth) - (blackKeyWidth / 2);
      final rect = Rect.fromLTWH(left, 0, blackKeyWidth, blackKeyHeight);

      canvas.drawRect(rect, activeNotes.contains(note) ? activePaint : blackKeyPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PianoPainter oldDelegate) {
    return oldDelegate.activeNotes != activeNotes;
  }
}