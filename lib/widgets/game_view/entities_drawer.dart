import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EntitiesDrawer {
  static final List<String> directions = ['right', 'up', 'left', 'down'];

  static Widget entityView(EntityType entityType, Direction direction) {
    switch (entityType) {
      case EntityType.Cat:
        return FlareActor(
          'assets/animations/cat_${directions[direction.index]}.flr',
          isPaused: true,
        );
        break;

      case EntityType.Mouse:
        return FlareActor(
          'assets/animations/mouse_${directions[direction.index]}.flr',
          isPaused: true,
        );
        break;

      default:
        return Container(
          color: Colors.transparent,
        );
    }
  }
}
