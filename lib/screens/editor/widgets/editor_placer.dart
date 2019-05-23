import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/editor/editor_game_controller.dart';
import 'package:nyanya_rocket/screens/editor/widgets/discard_confirmation_dialog.dart';
import 'package:nyanya_rocket/widgets/game_view/entities_drawer.dart';
import 'package:nyanya_rocket/widgets/game_view/static_game_view.dart';
import 'package:nyanya_rocket/widgets/game_view/tiles_drawer.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

enum ToolType { Tile, Entity, Wall }

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
  final VoidCallback onPlay;
  final VoidCallback onSave;

  const EditorPlacer({
    Key key,
    @required this.editorGameController,
    @required this.menus,
    @required this.onSave,
    this.onPlay,
  }) : super(key: key);

  @override
  _EditorPlacerState createState() => _EditorPlacerState();
}

class _EditorPlacerState extends State<EditorPlacer> {
  int _selected;
  List<int> _subSelected;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _selected = 0;
    _subSelected = List.filled(widget.menus.length, 0);
  }

  EditorTool _currentTool() {
    return widget.menus[_selected].subMenu[_subSelected[_selected]];
  }

  Future<bool> _confirmDiscard() {
    if (_saved) {
      return Future.value(true);
    }

    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const DiscardConfirmationDialog();
        });
  }

  Widget _dragTileBuilder(BuildContext context, List<EditorTool> candidateData,
      List rejectedData, int x, int y) {
    if (candidateData.length == 0) return const SizedBox.expand();

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
          child: Image.asset('assets/graphics/wall.png'));
    else {
      return const SizedBox.shrink();
    }
  }

  void _handleDrop(int x, int y, EditorTool selected) {
    switch (selected.type) {
      case ToolType.Tile:
        widget.editorGameController.toggleTile(x, y, selected.tile);
        break;

      case ToolType.Entity:
        widget.editorGameController
            .toggleEntity(x, y, selected.entityType, selected.direction);
        break;

      case ToolType.Wall:
        widget.editorGameController.toggleWall(x, y, selected.direction);
        break;

      default:
        break;
    }

    _saved = false;
  }

  void _handleTap(int x, int y) {
    EditorTool selected = _currentTool();

    switch (selected.type) {
      case ToolType.Tile:
        widget.editorGameController.toggleTile(x, y, selected.tile);
        break;

      case ToolType.Entity:
        widget.editorGameController
            .toggleEntity(x, y, selected.entityType, selected.direction);
        break;

      case ToolType.Wall:
        widget.editorGameController.toggleWall(x, y, selected.direction);
        break;

      default:
        break;
    }

    _saved = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmDiscard,
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Flex(
            direction: orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal,
            children: <Widget>[
              Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                        aspectRatio: 12.0 / 9.0,
                        child: InputGridOverlay<EditorTool>(
                          child: ValueListenableBuilder<Game>(
                              valueListenable:
                                  widget.editorGameController.gameStream,
                              builder: (context, value, child) {
                                return StaticGameView(
                                  game: value,
                                );
                              }),
                          previewBuilder: _dragTileBuilder,
                          onDrop: _handleDrop,
                          onTap: _handleTap,
                        )),
                  )),
              Flexible(
                  child: Column(
                children: <Widget>[
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:
                        List<Widget>.generate(widget.menus.length, (int i) {
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
                  Flexible(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: <Widget>[
                          Visibility(
                            visible: widget.onPlay != null,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    child: Text(NyaNyaLocalizations.of(context)
                                        .playLabel),
                                    onPressed: widget.onPlay),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  child: Text(NyaNyaLocalizations.of(context)
                                      .saveLabel),
                                  onPressed: () {
                                    widget.onSave();
                                    _saved = true;
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
            ],
          );
        },
      ),
    );
  }

  Widget _subModeBuilder() {
    return Row(
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
            feedback: const SizedBox.shrink(),
            data: widget.menus[_selected].subMenu[i],
          ),
        );
      }),
    );
  }
}
