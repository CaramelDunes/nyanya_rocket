import 'package:flutter/painting.dart';

abstract class CanvasRiveAnimation {
  void draw(Canvas canvas, Size size, double x, double y, int frameNb,
      [Paint? paint]);
}
