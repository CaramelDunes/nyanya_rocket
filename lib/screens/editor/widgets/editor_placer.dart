import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../localization/nyanya_localizations.dart';
import '../../../widgets/board/entities/entity_painter.dart';
import '../../../widgets/board/static_game_view.dart';
import '../../../widgets/board/tiles/tile_painter.dart';
import '../../../widgets/input/input_grid_overlay.dart';
import '../edited_game.dart';
import 'discard_confirmation_dialog.dart';

enum ToolType { tile, entity, wall }

class EditorMenu {
  final List<EditorTool> subMenu;
  final Widget? representative;

  const EditorMenu({required this.subMenu, this.representative});
}

class EditorTool {
  final ToolType type;
  final EntityType? entityType;
  final Tile? tile;
  final Direction? direction;

  const EditorTool(
      {required this.type, this.tile, this.entityType, this.direction});
}

class EditorPlacer extends StatefulWidget {
  final EditedGame editedGame;
  final List<EditorMenu> menus;
  final VoidCallback onSave;
  final VoidCallback? onPlay;
  final VoidCallback onUndo;
  final VoidCallback onRedo;

  const EditorPlacer({
    super.key,
    required this.editedGame,
    required this.menus,
    required this.onSave,
    required this.onUndo,
    required this.onRedo,
    this.onPlay,
  });

  @override
  State<EditorPlacer> createState() => _EditorPlacerState();
}

class _EditorPlacerState extends State<EditorPlacer> {
  int _selected = 0;
  late List<int> _subSelected;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();

    _subSelected = List.filled(widget.menus.length, 0);
  }

  EditorTool _currentTool() {
    return widget.menus[_selected].subMenu[_subSelected[_selected]];
  }

  Future<bool> _confirmDiscard() {
    if (_isSaved) {
      return Future.value(true);
    }

    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const DiscardConfirmationDialog();
        }).then((b) => b ?? false);
  }

  Widget _dragTileBuilder(BuildContext context, List<EditorTool?> candidateData,
      List rejectedData, int x, int y) {
    if (candidateData.isEmpty) return const SizedBox.expand();

    return _toolView(candidateData[0]);
  }

  Widget _toolView(EditorTool? tool) {
    if (tool == null) {
      return const SizedBox.shrink();
    }

    if (tool.type == ToolType.tile) {
      return TilePainter.widget(tool.tile!);
    } else if (tool.type == ToolType.entity) {
      return EntityPainter.widget(tool.entityType!, tool.direction!);
    } else if (tool.type == ToolType.wall) {
      return RotatedBox(
          quarterTurns: -tool.direction!.index,
          child: Image.asset('assets/graphics/wall.png'));
    } else {
      return const SizedBox.shrink();
    }
  }

  void _handleDrop(int x, int y, EditorTool selected) {
    switch (selected.type) {
      case ToolType.tile:
        widget.editedGame.clearTile(x, y);
        widget.editedGame.toggleTile(x, y, selected.tile!);
        break;

      case ToolType.entity:
        widget.editedGame.clearEntity(x, y);
        widget.editedGame
            .toggleEntity(x, y, selected.entityType!, selected.direction!);
        break;

      case ToolType.wall:
        widget.editedGame.toggleWall(x, y, selected.direction!);
        break;

      default:
        break;
    }

    // TODO Use ValueListenableBuilder on the board.
    setState(() {});

    _isSaved = false;
  }

  void _handleTap(int x, int y) {
    EditorTool selected = _currentTool();

    switch (selected.type) {
      case ToolType.tile:
        widget.editedGame.toggleTile(x, y, selected.tile!);
        break;

      case ToolType.entity:
        widget.editedGame
            .toggleEntity(x, y, selected.entityType!, selected.direction!);
        break;

      case ToolType.wall:
        widget.editedGame.toggleWall(x, y, selected.direction!);
        break;

      default:
        break;
    }

    // TODO Use ValueListenableBuilder on the board.
    setState(() {});

    _isSaved = false;
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
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                    aspectRatio: 12.0 / 9.0,
                    child: InputGridOverlay<EditorTool>(
                      previewBuilder: _dragTileBuilder,
                      onDrop: _handleDrop,
                      onTap: _handleTap,
                      child: ValueListenableBuilder<GameState>(
                          valueListenable: widget.editedGame.gameStream,
                          builder: (context, value, child) {
                            return StaticGameView(
                              game: value,
                            );
                          }),
                    )),
              ),
              Flexible(
                  child: Column(
                children: [
                  Expanded(
                      child: Row(
                    children:
                        List<Widget>.generate(widget.menus.length, (int i) {
                      return Expanded(
                        child: Card(
                          color: _selected == i ? Colors.grey.shade300 : null,
                          child: InkWell(
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: widget.menus[i].representative ??
                                  _toolView(widget.menus[i].subMenu[0]),
                            )),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Visibility(
                          visible: widget.onPlay != null,
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FilledButton(
                                  onPressed: widget.onPlay,
                                  child: Text(NyaNyaLocalizations.of(context)
                                      .playLabel)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FilledButton(
                                child: Text(
                                    NyaNyaLocalizations.of(context).saveLabel),
                                onPressed: () {
                                  widget.onSave();
                                  _isSaved = true;
                                }),
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.undo),
                            onPressed: widget.onUndo),
                        IconButton(
                            icon: const Icon(Icons.redo),
                            onPressed: widget.onRedo)
                      ],
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
      children: List<Widget>.generate(widget.menus[_selected].subMenu.length,
          (int i) {
        return Expanded(
          child: Draggable<EditorTool>(
            feedback: const SizedBox.shrink(),
            data: widget.menus[_selected].subMenu[i],
            child: Card(
              color: _subSelected[_selected] == i ? Colors.grey.shade300 : null,
              child: InkWell(
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: _toolView(widget.menus[_selected].subMenu[i]),
                )),
                onTap: () {
                  setState(() {
                    _subSelected[_selected] = i;
                  });
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
