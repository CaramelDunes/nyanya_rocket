import 'package:flutter/material.dart';

class BoardList extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tileBuilder;
  final IndexedWidgetBuilder cardBuilder;

  const BoardList(
      {Key? key,
      required this.itemCount,
      required this.tileBuilder,
      required this.cardBuilder})
      : super(key: key);

  @override
  State<BoardList> createState() => _BoardListState();
}

class _BoardListState extends State<BoardList>
    with AutomaticKeepAliveClientMixin<BoardList> {
  static const double maxCrossAxisExtent = 248.0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape ||
            MediaQuery.of(context).size.width >= maxCrossAxisExtent * 2.0) {
          return _buildLandscape();
        } else {
          return _buildPortrait();
        }
      },
    );
  }

  Widget _buildPortrait() {
    return ListView.builder(
        itemCount: widget.itemCount, itemBuilder: widget.tileBuilder);
  }

  Widget _buildLandscape() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCrossAxisExtent,
        ),
        itemCount: widget.itemCount,
        itemBuilder: widget.cardBuilder);
  }
}
