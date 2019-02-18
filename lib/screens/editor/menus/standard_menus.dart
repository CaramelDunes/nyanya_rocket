import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/screens/editor/widgets/editor_placer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class StandardMenus {
  static const EditorMenu mice = const EditorMenu(subMenu: <EditorTool>[
    const EditorTool(
        type: ToolType.Entity,
        entityType: EntityType.Mouse,
        direction: Direction.Right),
    const EditorTool(
        type: ToolType.Entity,
        entityType: EntityType.Mouse,
        direction: Direction.Up),
    const EditorTool(
        type: ToolType.Entity,
        entityType: EntityType.Mouse,
        direction: Direction.Left),
    const EditorTool(
        type: ToolType.Entity,
        entityType: EntityType.Mouse,
        direction: Direction.Down),
  ]);

  static const EditorMenu cats = const EditorMenu(subMenu: <EditorTool>[
    const EditorTool(
        type: ToolType.Entity,
        entityType: EntityType.Cat,
        direction: Direction.Right),
    const EditorTool(
        type: ToolType.Entity,
        entityType: EntityType.Cat,
        direction: Direction.Up),
    const EditorTool(
        type: ToolType.Entity,
        entityType: EntityType.Cat,
        direction: Direction.Left),
    const EditorTool(
        type: ToolType.Entity,
        entityType: EntityType.Cat,
        direction: Direction.Down),
  ]);

  static const EditorMenu walls = const EditorMenu(
      representative: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image(image: AssetImage('assets/graphics/wall_cross.png')),
      ),
      subMenu: <EditorTool>[
        EditorTool(type: ToolType.Wall, direction: Direction.Right),
        EditorTool(type: ToolType.Wall, direction: Direction.Up),
        EditorTool(type: ToolType.Wall, direction: Direction.Left),
        EditorTool(type: ToolType.Wall, direction: Direction.Down),
      ]);

  static const EditorMenu arrows = EditorMenu(subMenu: <EditorTool>[
    EditorTool(
        type: ToolType.Tile,
        tile: Arrow(player: PlayerColor.Blue, direction: Direction.Right)),
    EditorTool(
        type: ToolType.Tile,
        tile: Arrow(player: PlayerColor.Blue, direction: Direction.Up)),
    EditorTool(
        type: ToolType.Tile,
        tile: Arrow(player: PlayerColor.Blue, direction: Direction.Left)),
    EditorTool(
        type: ToolType.Tile,
        tile: Arrow(player: PlayerColor.Blue, direction: Direction.Down)),
  ]);

  static const EditorMenu generators = EditorMenu(subMenu: <EditorTool>[
    EditorTool(
        type: ToolType.Tile, tile: Generator(direction: Direction.Right)),
    EditorTool(type: ToolType.Tile, tile: Generator(direction: Direction.Up)),
    EditorTool(type: ToolType.Tile, tile: Generator(direction: Direction.Left)),
    EditorTool(type: ToolType.Tile, tile: Generator(direction: Direction.Down)),
  ]);

  static const EditorMenu eraser = EditorMenu(
      representative: Icon(FontAwesomeIcons.eraser),
      subMenu: <EditorTool>[
        EditorTool(type: ToolType.Eraser),
      ]);
}
