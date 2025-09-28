import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParticlePainter extends CustomPainter {
  final double progress;

  ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 50; i++) {
      final x = (size.width * 0.1) + (math.sin(progress * 2 * math.pi + i) * size.width * 0.8);
      final y = (size.height * 0.1) + (math.cos(progress * 2 * math.pi + i * 0.7) * size.height * 0.8);
      final radius = 2 + (math.sin(progress * 4 * math.pi + i) * 2);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
