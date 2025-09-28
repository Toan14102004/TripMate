import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final double progress;

  WavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    
    for (int i = 0; i < 3; i++) {
      path.reset();
      final waveHeight = 30 + (i * 10);
      final frequency = 0.02 + (i * 0.005);
      
      path.moveTo(0, size.height * 0.3 + (i * 50));
      
      for (double x = 0; x <= size.width; x++) {
        final y = size.height * 0.3 + (i * 50) + 
                 math.sin((x * frequency) + (progress * 2) + (i * 0.5)) * waveHeight;
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}