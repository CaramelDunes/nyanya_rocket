import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class RocketPainter extends CustomPainter {
  const RocketPainter(this.color);

  factory RocketPainter.fromPlayerColor(PlayerColor? color) {
    switch (color) {
      case PlayerColor.Blue:
        return RocketPainter(Colors.blue);

      case PlayerColor.Red:
        return RocketPainter(Colors.red);

      case PlayerColor.Yellow:
        return RocketPainter(Colors.yellow);

      case PlayerColor.Green:
        return RocketPainter(Colors.green);

      default:
        return RocketPainter(Colors.grey);
    }
  }

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = RadialGradient(
      radius: 0.3,
      colors: [color, color.withAlpha(128)],
    );

    canvas.drawCircle(rect.center, size.shortestSide * 0.45,
        Paint()..shader = gradient.createShader(rect));
    canvas.drawCircle(
        rect.center,
        size.shortestSide * 0.45,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.shortestSide * 0.05);
  }

  @override
  bool shouldRepaint(RocketPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
