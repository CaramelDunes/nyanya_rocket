import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/blocs/multiplayer_queue.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/multiplayer/setup_widgets/leaderboard.dart';
import 'package:nyanya_rocket/screens/multiplayer/setup_widgets/player_finder.dart';

class QueueAndLeaderboard extends StatelessWidget {
  final QueueType queueType;
  final String displayName;
  final String idToken;
  final String masterServerHostname;

  const QueueAndLeaderboard(
      {Key? key,
      required this.queueType,
      required this.displayName,
      required this.idToken,
      required this.masterServerHostname})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            if (orientation == Orientation.portrait) {
              return _buildPortrait(context);
            } else {
              return _buildLandscape(context);
            }
          },
        ));
  }

  Widget _buildPortrait(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 2, child: _buildPlayerFinder()),
        Divider(),
        Expanded(flex: 3, child: _buildLeaderboard(context))
      ],
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildPlayerFinder()),
        VerticalDivider(),
        Expanded(child: _buildLeaderboard(context))
      ],
    );
  }

  Widget _buildPlayerFinder() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PlayerFinder(
        displayName: displayName,
        idToken: idToken,
        queueType: queueType,
        masterServerHostname: masterServerHostname,
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FaIcon(FontAwesomeIcons.crown),
                SizedBox(width: 8.0),
                Text(
                  NyaNyaLocalizations.of(context).leaderBoardLabel,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Leaderboard(),
            )),
          ]),
    );
  }
}
