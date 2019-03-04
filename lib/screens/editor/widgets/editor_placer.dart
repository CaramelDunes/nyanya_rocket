import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/editor/editor_game_controller.dart';
import 'package:nyanya_rocket/widgets/game_view/static_game_view.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/widgets/game_view/entities_drawer.dart';
import 'package:nyanya_rocket/widgets/game_view/tiles_drawer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

enum ToolType { Tile, Entity, Wall, Eraser }

class EditorMenu {
  final List<EditorTool> subMenu;
  final Widget representative;

  const EditorMenu({@required this.subMenu, this.representative});
}

class EditorTool {
  final ToolType type;
  final EntityType entityType;
  final Tile tile;
  final Direction direction;

  const EditorTool(
      {@required this.type, this.tile, this.entityType, this.direction});
}

class EditorPlacer extends StatefulWidget {
  final EditorGameController editorGameController;
  final List<EditorMenu> menus;

  const EditorPlacer({Key key, this.editorGameController, @required this.menus})
      : super(key: key);

  @override
  _EditorPlacerState createState() => _EditorPlacerState();
}

class _EditorPlacerState extends State<EditorPlacer> {
  int _selected;
  List<int> _subSelected;

  @override
  void initState() {
    super.initState();
    _selected = 0;
    _subSelected = List.filled(widget.menus.length, 0);
  }

  EditorTool _currentTool() {
    return widget.menus[_selected].subMenu[_subSelected[_selected]];
  }

  Widget _dragTileBuilder(BuildContext context, List<EditorTool> candidateData,
      List rejectedData, int x, int y) {
    if (candidateData.length == 0) return Container();

    return _toolView(candidateData[0]);
  }

  Widget _toolView(EditorTool tool) {
    if (tool.type == ToolType.Tile)
      return TilesDrawer.tileView(tool.tile);
    else if (tool.type == ToolType.Entity)
      return EntitiesDrawer.entityView(tool.entityType, tool.direction);
    else if (tool.type == ToolType.Wall)
      return RotatedBox(
          quarterTurns: -tool.direction.index,
          child: Image(
            image: AssetImage('assets/graphics/wall.png'),
          ));
    else {
      return Container();
    }
  }

  void _handleDrop(int x, int y, EditorTool selected) {
    switch (selected.type) {
      case ToolType.Tile:
        widget.editorGameController.placeTile(x, y, selected.tile);
        break;

      case ToolType.Entity:
        widget.editorGameController
            .placeEntity(x, y, selected.entityType, selected.direction);
        break;

      case ToolType.Wall:
        widget.editorGameController.toggleWall(x, y, selected.direction);
        break;

      default:
        break;
    }
  }

  void _handleTap(int x, int y) {
    EditorTool selected = _currentTool();

    switch (selected.type) {
      case ToolType.Tile:
        widget.editorGameController.placeTile(x, y, selected.tile);
        break;

      case ToolType.Entity:
        widget.editorGameController
            .placeEntity(x, y, selected.entityType, selected.direction);
        break;

      case ToolType.Wall:
        widget.editorGameController.toggleWall(x, y, selected.direction);
        break;

      case ToolType.Eraser:
        widget.editorGameController.clearTile(x, y);
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => Flex(
        direction: MediaQuery.of(context).orientation == Orientation.portrait
            ? Axis.vertical
            : Axis.horizontal,
        children: <Widget>[
          Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AspectRatio(
                    aspectRatio: 12.0 / 9.0,
                    child: InputGridOverlay<EditorTool>(
                      child: StaticGameView(
                        game: widget.editorGameController.gameStream,
                      ),
                      previewBuilder: _dragTileBuilder,
                      onDrop: _handleDrop,
                      onTap: _handleTap,
                    )),
              )),
          Expanded(
              child: Flex(
            direction:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? Axis.horizontal
                    : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List<Widget>.generate(widget.menus.length, (int i) {
              return Expanded(
                child: Card(
                  color: _selected == i ? Colors.grey.shade300 : null,
                  child: InkWell(
                    child: widget.menus[i].representative ??
                        _toolView(widget.menus[i].subMenu[0]),
                    onTap: () {
                      setState(() {
                        _selected = i;
                      });
                    },
                  ),
                ),
              );
            }),
          )),
          Expanded(child: _subModeBuilder()),
        ],
      );

  Widget _subModeBuilder() {
    return Flex(
      direction: MediaQuery.of(context).orientation == Orientation.portrait
          ? Axis.horizontal
          : Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.generate(widget.menus[_selected].subMenu.length,
          (int i) {
        return Expanded(
          child: Draggable<EditorTool>(
            child: Card(
              color: _subSelected[_selected] == i ? Colors.grey.shade300 : null,
              child: InkWell(
                child: _toolView(widget.menus[_selected].subMenu[i]),
                onTap: () {
                  setState(() {
                    _subSelected[_selected] = i;
                  });
                },
              ),
            ),
            feedback: Container(),
            data: widget.menus[_selected].subMenu[i],
          ),
        );
      }),
    );
  }
}
