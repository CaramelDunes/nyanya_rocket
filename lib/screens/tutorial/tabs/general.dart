import 'package:flutter/material.dart';

class General extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Text('Synopsis', style: Theme.of(context).textTheme.title),
        Text('Board', style: Theme.of(context).textTheme.subtitle)
      ],
    );
  }
}
