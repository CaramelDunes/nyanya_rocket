import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EntityView extends StatelessWidget {
  final Entity entity;
  final BoxConstraints constraints;

  EntityView(this.entity, this.constraints);

  @override
  Widget build(BuildContext context) {
    switch (entity.runtimeType) {
      case Cat:
        return Positioned(
            top: 0,
            left: 0,
            width: constraints.maxWidth / 12,
            height: constraints.maxHeight / 9,
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth / 120),
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ));
        break;

      default:
        return Container(
          color: Colors.transparent,
        );
    }
  }
}
