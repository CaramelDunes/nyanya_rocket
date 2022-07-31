import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../localization/nyanya_localizations.dart';
import '../../routing/nyanya_route_path.dart';
import '../../widgets/board/static_game_view.dart';
import '../puzzles/widgets/original_puzzles.dart';
import '../settings/settings.dart';
import '../tutorial/tutorial.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Material(child: OrientationBuilder(builder: (context, orientation) {
      switch (orientation) {
        case Orientation.portrait:
          return _buildPortrait(context);
        case Orientation.landscape:
          return _buildLandscape(context);
      }
    }));
  }

  Widget _buildPortrait(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16.0),
          _buildTitleRow(context),
          const SizedBox(height: 16.0),
          Expanded(flex: 4, child: _buildPlayRow(context, Axis.vertical)),
          const SizedBox(height: 24.0),
          _buildFourthRow(context),
        ],
      ),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          _buildTitleRow(context),
          const Spacer(),
          Expanded(flex: 4, child: _buildPlayRow(context, Axis.vertical)),
          const Spacer(),
          _buildFourthRow(context),
        ],
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        'NyaNya Rocket!',
        style: Theme.of(context).textTheme.displayMedium!.apply(
            fontFamily: 'Russo One',
            color: Theme.of(context).colorScheme.primary),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPlayRow(BuildContext context, Axis direction) {
    return Flex(
      direction: direction,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.puzzlePiece,
                            size: 50.0,
                          ),
                          Text(
                            NyaNyaLocalizations.of(context).puzzlesTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AspectRatio(
                          aspectRatio: 12 / 9,
                          child: StaticGameView(
                              game: OriginalPuzzles.puzzles[0].data.gameData)),
                    )
                  ],
                ),
              ),
              onTap: () {
                Router.of(context)
                    .routerDelegate
                    .setNewRoutePath(const NyaNyaRoutePath.originalPuzzles());
              },
            ),
          ),
        ),
        Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.stopwatch,
                            size: 50.0,
                          ),
                          Text(NyaNyaLocalizations.of(context).challengesTitle,
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AspectRatio(
                          aspectRatio: 12 / 9,
                          child: StaticGameView(
                              game: OriginalPuzzles.puzzles[0].data.gameData)),
                    )
                  ],
                ),
              ),
              onTap: () {
                Router.of(context).routerDelegate.setNewRoutePath(
                    const NyaNyaRoutePath.originalChallenges());
              },
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Router.of(context)
                          .routerDelegate
                          .setNewRoutePath(const NyaNyaRoutePath.multiplayer());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.groups,
                            size: 50.0,
                          ),
                          Text(
                            NyaNyaLocalizations.of(context).multiplayerTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.mode_edit,
                            size: 50.0,
                          ),
                          Text(NyaNyaLocalizations.of(context).editorTitle,
                              style: Theme.of(context).textTheme.titleMedium)
                        ],
                      ),
                    ),
                    onTap: () {
                      Router.of(context)
                          .routerDelegate
                          .setNewRoutePath(const NyaNyaRoutePath.editor());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFourthRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.help),
          label: Text(NyaNyaLocalizations.of(context).tutorialTitle),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Tutorial()));
          },
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.settings),
          label: Text(NyaNyaLocalizations.of(context).settingsTitle),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Settings()));
          },
        ),
      ],
    );
  }
}
