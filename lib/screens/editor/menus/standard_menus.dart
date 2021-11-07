import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/editor/widgets/editor_placer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class StandardMenus {
  static const EditorMenu mice = EditorMenu(subMenu: <EditorTool>[
    EditorTool(
        type: ToolType.entity,
        entityType: EntityType.Mouse,
        direction: Direction.Right),
    EditorTool(
        type: ToolType.entity,
        entityType: EntityType.Mouse,
        direction: Direction.Up),
    EditorTool(
        type: ToolType.entity,
        entityType: EntityType.Mouse,
        direction: Direction.Left),
    EditorTool(
        type: ToolType.entity,
        entityType: EntityType.Mouse,
        direction: Direction.Down),
  ]);

  static const EditorMenu cats = EditorMenu(subMenu: <EditorTool>[
    EditorTool(
        type: ToolType.entity,
        entityType: EntityType.Cat,
        direction: Direction.Right),
    EditorTool(
        type: ToolType.entity,
        entityType: EntityType.Cat,
        direction: Direction.Up),
    EditorTool(
        type: ToolType.entity,
        entityType: EntityType.Cat,
        direction: Direction.Left),
    EditorTool(
        type: ToolType.entity,
        entityType: EntityType.Cat,
        direction: Direction.Down),
  ]);

  static const EditorMenu walls = EditorMenu(
      representative: Padding(
        padding: EdgeInsets.all(8.0),
        child: Image(image: AssetImage('assets/graphics/wall_cross.png')),
      ),
      subMenu: <EditorTool>[
        EditorTool(type: ToolType.wall, direction: Direction.Right),
        EditorTool(type: ToolType.wall, direction: Direction.Up),
        EditorTool(type: ToolType.wall, direction: Direction.Left),
        EditorTool(type: ToolType.wall, direction: Direction.Down),
      ]);

  static const EditorMenu arrows = EditorMenu(subMenu: <EditorTool>[
    EditorTool(
        type: ToolType.tile,
        tile: Arrow(player: PlayerColor.Blue, direction: Direction.Right)),
    EditorTool(
        type: ToolType.tile,
        tile: Arrow(player: PlayerColor.Blue, direction: Direction.Up)),
    EditorTool(
        type: ToolType.tile,
        tile: Arrow(player: PlayerColor.Blue, direction: Direction.Left)),
    EditorTool(
        type: ToolType.tile,
        tile: Arrow(player: PlayerColor.Blue, direction: Direction.Down)),
  ]);

  static const EditorMenu generators = EditorMenu(subMenu: <EditorTool>[
    EditorTool(
        type: ToolType.tile, tile: Generator(direction: Direction.Right)),
    EditorTool(type: ToolType.tile, tile: Generator(direction: Direction.Up)),
    EditorTool(type: ToolType.tile, tile: Generator(direction: Direction.Left)),
    EditorTool(type: ToolType.tile, tile: Generator(direction: Direction.Down)),
  ]);

  static const EditorMenu rockets = EditorMenu(subMenu: <EditorTool>[
    EditorTool(type: ToolType.tile, tile: Rocket(player: PlayerColor.Blue)),
    EditorTool(type: ToolType.tile, tile: Rocket(player: PlayerColor.Yellow)),
    EditorTool(type: ToolType.tile, tile: Rocket(player: PlayerColor.Red)),
    EditorTool(type: ToolType.tile, tile: Rocket(player: PlayerColor.Green)),
  ]);
}
