import 'package:flutter/material.dart';

class StarCount extends StatelessWidget {
  final int count;

  const StarCount({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(count.toString()),
        ),
        Icon(Icons.star),
      ],
    );
  }
}
