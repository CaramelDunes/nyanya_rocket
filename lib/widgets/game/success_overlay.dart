import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../localization/nyanya_localizations.dart';
import '../../routing/nyanya_route_path.dart';
import '../../services/firestore/firestore_service.dart';

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
          .read<FirestoreService>()
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
      children: [
        IconButton(
          icon: Icon(
            Icons.star,
            color: _plusOned ? Colors.green : null,
          ),
          onPressed: () {
            if (!_plusOned) {
              context
                  .read<FirestoreService>()
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
        const AbsorbPointer(),
        Material(
          color: Colors.black54,
          child: Column(
            children: [
              const Spacer(flex: 2),
              Card(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        NyaNyaLocalizations.of(context).stageClearedText,
                        style:
                            const TextStyle(color: Colors.green, fontSize: 40),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.succeededPath != null && _stars != null)
                        _starAdder()
                      else
                        const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            child: Text(NyaNyaLocalizations.of(context).back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: widget.onPlayAgain,
                            child: Text(
                                NyaNyaLocalizations.of(context).playAgainLabel),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: widget.nextRoutePath == null
                                ? null
                                : () {
                                    Router.of(context)
                                        .routerDelegate
                                        .setNewRoutePath(widget.nextRoutePath);
                                  },
                            child: Text(
                                NyaNyaLocalizations.of(context).nextLevelLabel),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        )
      ],
    );
  }
}
