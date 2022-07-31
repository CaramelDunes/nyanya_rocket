import 'package:flutter/material.dart';

class StarCount extends StatelessWidget {
  final int count;

  const StarCount({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(count.toString()),
        ),
        const Icon(Icons.star),
      ],
    );
  }
}
