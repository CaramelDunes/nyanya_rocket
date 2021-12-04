import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/settings/first_run.dart';
import 'package:provider/provider.dart';

import '../../../services/firestore/firestore_service.dart';

class WhatsNew extends StatelessWidget {
  static Set<String> availableLocales = {'en', 'fr'};

  const WhatsNew({Key? key}) : super(key: key);

  // static Future<QuerySnapshot> news = FirebaseFirestore.instance
  //     .collection('articles_${articleLocale()}')
  //     .orderBy('date', descending: true)
  //     .get();

  void _dismissWelcomeCard(BuildContext context) {
    Provider.of<FirstRun>(context, listen: false).enabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      if (orientation == Orientation.portrait) {
        return _buildPortrait(context);
      } else {
        return _buildLandscape(context);
      }
    });
  }

  Widget _buildPortrait(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: Provider.of<FirstRun>(context).enabled,
          child: Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              _dismissWelcomeCard(context);
            },
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      NyaNyaLocalizations.of(context).firstTimeWelcome,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Text(NyaNyaLocalizations.of(context).firstTimeText),
                  ElevatedButton(
                    child: Text(
                        NyaNyaLocalizations.of(context).firstTimeButtonLabel),
                    onPressed: () {
                      _dismissWelcomeCard(context);
                      Router.of(context)
                          .routerDelegate
                          .setNewRoutePath(const NyaNyaRoutePath.guide());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(child: _buildNews(context)),
        Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0),
          child: Row(
            children: _buildShortcutList(context, Axis.vertical),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildShortcutList(context, Axis.horizontal),
            ),
          ),
        ),
        const VerticalDivider(),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildNews(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildShortcutList(BuildContext context, Axis direction) {
    return [
      Expanded(
          child: _buildShortcutCard(
              context: context,
              faIcon: FontAwesomeIcons.puzzlePiece,
              name: NyaNyaLocalizations.of(context).puzzlesTitle,
              routePath: const NyaNyaRoutePath.originalPuzzles(),
              direction: direction)),
      Expanded(
          child: _buildShortcutCard(
              context: context,
              faIcon: FontAwesomeIcons.stopwatch,
              name: NyaNyaLocalizations.of(context).challengesTitle,
              routePath: const NyaNyaRoutePath.originalChallenges(),
              direction: direction)),
      Expanded(
          child: _buildShortcutCard(
              context: context,
              faIcon: FontAwesomeIcons.gamepad,
              name: NyaNyaLocalizations.of(context).multiplayerTitle,
              routePath: const NyaNyaRoutePath.multiplayer(),
              direction: direction))
    ];
  }

  Widget _buildShortcutCard(
      {required BuildContext context,
      required IconData faIcon,
      required String name,
      required NyaNyaRoutePath routePath,
      required Axis direction}) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: direction,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FaIcon(faIcon, size: 48),
              const SizedBox(height: 4.0),
              Text(
                name,
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
        ),
        onTap: () {
          Router.of(context).routerDelegate.setNewRoutePath(routePath);
        },
      ),
    );
  }

  Widget _buildNews(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 8.0),
              const Icon(Icons.new_releases),
              const SizedBox(width: 8.0),
              Text(
                NyaNyaLocalizations.of(context).newsLabel,
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                FutureBuilder<List<Map<String, dynamic>>?>(
                  future:
                      context.read<FirestoreService>().getNews(articleLocale()),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                            child: Text(
                                NyaNyaLocalizations.of(context).loadingLabel));
                      default:
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: snapshot.data!
                              .map((Map<String, dynamic> document) {
                            return ListTile(
                              title: Text(document['title']),
                              trailing: Text(MaterialLocalizations.of(context)
                                  .formatShortDate(document['date'])),
                            );
                          }).toList(),
                        );
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String articleLocale() {
    String shortLocale = Intl.shortLocale(Intl.getCurrentLocale());

    if (availableLocales.contains(shortLocale)) {
      return shortLocale;
    } else {
      return 'en';
    }
  }
}
