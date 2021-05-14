import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

extension PlayerColorColor on PlayerColor {
  Color get color {
    switch (this) {
      case PlayerColor.Blue:
        return Colors.blue;
      case PlayerColor.Red:
        return Colors.red;
      case PlayerColor.Green:
        return Colors.green;
      case PlayerColor.Yellow:
        return Colors.yellow;
    }
  }
}
