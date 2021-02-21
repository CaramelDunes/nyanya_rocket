import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

Path arrowPath(double bodyHeightRatio, double bodyWidthRatio) {
  Path p = Path();

  // Draw up arrow, starting from top point.
  p.moveTo(0.5, 0);
  p.lineTo(1, 1 - bodyHeightRatio);
  p.lineTo(0.5 + bodyWidthRatio / 2, 1 - bodyHeightRatio);
  p.lineTo(0.5 + bodyWidthRatio / 2, 1);
  p.lineTo(0.5 - bodyWidthRatio / 2, 1);
  p.lineTo(0.5 - bodyWidthRatio / 2, 1 - bodyHeightRatio);
  p.lineTo(0, 1 - bodyHeightRatio);
  p.lineTo(0.5, 0);

  return p;
}

class ArrowPainter extends CustomPainter {
  const ArrowPainter(this.color);

  factory ArrowPainter.fromPlayerColor(PlayerColor? color) {
    switch (color) {
      case PlayerColor.Blue:
        return ArrowPainter(Colors.blue);

      case PlayerColor.Red:
        return ArrowPainter(Colors.red);

      case PlayerColor.Yellow:
        return ArrowPainter(Colors.yellow);

      case PlayerColor.Green:
        return ArrowPainter(Colors.green);

      default:
        return ArrowPainter(Colors.grey);
    }
  }

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bodyHeightRatio = 0.6;
    final bodyWidthRatio = 0.5;

    final arrow = arrowPath(bodyHeightRatio, bodyWidthRatio);

    final arrowHeightRatio = 0.75;
    final arrowWidthRatio = 0.65;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(4.0));

    canvas.drawRRect(rrect, Paint()..color = color);
    canvas.drawRRect(
        rrect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.02 * size.shortestSide
          ..color = Colors.black);

    canvas.save();

    canvas.translate(size.width * (1 - arrowWidthRatio) / 2,
        size.height * (1 - arrowHeightRatio) / 2);
    canvas.scale(size.width * arrowWidthRatio, size.height * arrowHeightRatio);
    canvas.drawPath(arrow, Paint()..color = Colors.white);
    canvas.drawPath(
        arrow,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.05);

    canvas.restore();
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
