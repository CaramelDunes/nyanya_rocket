import 'package:flutter/painting.dart';

abstract class CanvasRiveAnimation {
  void drawUnit(Canvas canvas, int frameNb,
      [Paint? paint]);
}
