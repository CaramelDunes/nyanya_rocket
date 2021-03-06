import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/services/firebase/firebase_service.dart';

class SuccessOverlay extends StatefulWidget {
  final String? succeededPath;
  final NyaNyaRoutePath? nextRoutePath;
  final VoidCallback? onPlayAgain;

  const SuccessOverlay(
      {Key? key, this.nextRoutePath, this.onPlayAgain, this.succeededPath})
      : super(key: key);

  @override
  _SuccessOverlayState createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<SuccessOverlay> {
  int? _stars;
  bool _plusOned = false;

  @override
  void initState() {
    super.initState();

    if (widget.succeededPath != null) {
      context
          .read<FirebaseService>()
          .getCommunityStar(widget.succeededPath!)
          .then((int? stars) {
        setState(() {
          _stars = stars;
        });
      });
    }
  }

  Widget _starAdder() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.star,
            color: _plusOned ? Colors.green : null,
          ),
          onPressed: () {
            if (!_plusOned) {
              context
                  .read<FirebaseService>()
                  .incrementCommunityStar(widget.succeededPath!);

              setState(() {
                _plusOned = true;

                if (_stars != null) {
                  _stars = _stars! + 1;
                }
              });
            }
          },
        ),
        Text(_stars.toString())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AbsorbPointer(),
        Material(
          color: Colors.black54,
          child: Column(
            children: <Widget>[
              Spacer(flex: 2),
              Card(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        NyaNyaLocalizations.of(context).stageClearedText,
                        style: TextStyle(color: Colors.green, fontSize: 40),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.succeededPath != null && _stars != null)
                        _starAdder()
                      else
                        const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text(NyaNyaLocalizations.of(context).back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            child: Text(
                                NyaNyaLocalizations.of(context).playAgainLabel),
                            onPressed: widget.onPlayAgain,
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            child: Text(
                                NyaNyaLocalizations.of(context).nextLevelLabel),
                            onPressed: widget.nextRoutePath == null
                                ? null
                                : () {
                                    Router.of(context)
                                        .routerDelegate
                                        .setNewRoutePath(widget.nextRoutePath);
                                  },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(flex: 3),
            ],
          ),
        )
      ],
    );
  }
}
