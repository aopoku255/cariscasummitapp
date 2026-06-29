import 'package:flutter/material.dart';

class QRScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cornerLength = 30.0;
    const strokeWidth = 4.0;
    const radius = 12.0;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Top-left corner
    canvas.drawLine(
        Offset(0, radius), Offset(0, cornerLength), paint); // vertical
    canvas.drawLine(
        Offset(radius, 0), Offset(cornerLength, 0), paint); // horizontal

    // Top-right
    canvas.drawLine(
        Offset(size.width, radius), Offset(size.width, cornerLength), paint);
    canvas.drawLine(Offset(size.width - radius, 0),
        Offset(size.width - cornerLength, 0), paint);

    // Bottom-left
    canvas.drawLine(Offset(0, size.height - radius),
        Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(Offset(radius, size.height),
        Offset(cornerLength, size.height), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width, size.height - radius),
        Offset(size.width, size.height - cornerLength), paint);
    canvas.drawLine(Offset(size.width - radius, size.height),
        Offset(size.width - cornerLength, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
