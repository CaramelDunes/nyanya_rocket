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
  _BoardListState createState() => _BoardListState();
}

class _BoardListState extends State<BoardList>
    with AutomaticKeepAliveClientMixin<BoardList> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape ||
            MediaQuery.of(context).size.width >= 270 * 2.5) {
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
          maxCrossAxisExtent: 270,
        ),
        itemCount: widget.itemCount,
        itemBuilder: widget.cardBuilder);
  }
}
