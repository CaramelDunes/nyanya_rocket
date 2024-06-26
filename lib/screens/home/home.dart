import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';
import 'package:provider/provider.dart';

import '../../boards/original_challenges.dart';
import '../../boards/original_puzzles.dart';
import '../../localization/nyanya_localizations.dart';
import '../../routing/nyanya_route_path.dart';
import '../../utils.dart';
import '../../widgets/board/static_game_view.dart';
import '../challenges/challenge_progression_manager.dart';
import '../puzzles/puzzle_progression_manager.dart';
import '../settings/settings.dart';
import '../tutorial/tutorial.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: OrientationBuilder(builder: (context, orientation) {
          switch (orientation) {
            case Orientation.portrait:
              return _buildPortrait(context);
            case Orientation.landscape:
              return _buildLandscape(context);
          }
        }),
      ),
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(context),
        const SizedBox(height: 16.0),
        Expanded(flex: 4, child: _buildTilesFlex(context, Axis.vertical)),
        const SizedBox(height: 16.0),
        _buildGuideSettingsRow(context),
      ],
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(context),
        Flexible(
            flex: 4,
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 496),
                child: _buildTilesFlex(context, Axis.horizontal))),
        const SizedBox(height: 4.0),
        _buildGuideSettingsRow(context),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        'NyaNya Rocket!',
        style: Theme.of(context).textTheme.displayMedium!.apply(
            fontFamily: 'Russo One',
            color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget _buildTilesFlex(BuildContext context, Axis direction) {
    return Flex(
      direction: direction,
      children: [
        Expanded(
          child: Consumer<PuzzleProgressionManager>(
            builder: (context, value, child) {
              final completedPercentage =
                  ratioToPercentage(value.completedRatio);
              final unfinishedPuzzleId = value.getFirstNotClearedPuzzle();
              final unfinishedPuzzle = originalPuzzles[unfinishedPuzzleId];

              return _buildBoardTile(
                  context,
                  direction,
                  NyaNyaLocalizations.of(context).puzzlesTitle,
                  FontAwesomeIcons.puzzlePiece,
                  completedPercentage,
                  unfinishedPuzzle.data.gameData,
                  unfinishedPuzzle.name,
                  const NyaNyaRoutePath.originalPuzzles());
            },
          ),
        ),
        Expanded(
          child: Consumer<ChallengeProgressionManager>(
            builder: (context, value, child) {
              final completedPercentage =
                  ratioToPercentage(value.completedRatio);
              final unfinishedChallengeId = value.getFirstNotClearedChallenge();
              final unfinishedChallenge =
                  originalChallenges[unfinishedChallengeId];

              return _buildBoardTile(
                  context,
                  direction,
                  NyaNyaLocalizations.of(context).challengesTitle,
                  FontAwesomeIcons.stopwatch,
                  completedPercentage,
                  unfinishedChallenge.data.getGame(),
                  unfinishedChallenge.fullLocalizedName(context),
                  const NyaNyaRoutePath.originalChallenges());
            },
          ),
        ),
        Expanded(
          child: Flex(
            direction:
                direction == Axis.horizontal ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildIconTile(
                    context,
                    direction,
                    NyaNyaLocalizations.of(context).multiplayerTitle,
                    Icons.groups,
                    const NyaNyaRoutePath.multiplayer()),
              ),
              Expanded(
                child: _buildIconTile(
                    context,
                    direction,
                    NyaNyaLocalizations.of(context).editorTitle,
                    Icons.mode_edit,
                    const NyaNyaRoutePath.editor()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuideSettingsRow(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceEvenly,
      spacing: 8.0,
      runAlignment: WrapAlignment.spaceEvenly,
      runSpacing: 8.0,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.help),
          label: Text(NyaNyaLocalizations.of(context).tutorialTitle),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Tutorial()));
          },
        ),
        TextButton.icon(
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

Widget _buildBoardTile(
    BuildContext context,
    Axis direction,
    String text,
    IconData faIcon,
    int completedPercentage,
    GameState board,
    String boardName,
    NyaNyaRoutePath routePath) {
  return Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Flex(
          direction:
              direction == Axis.horizontal ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Flex(
                direction: direction,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: FaIcon(
                        faIcon,
                        size: 50.0,
                      ),
                    ),
                  ),
                  const SizedBox.square(dimension: 8.0),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(text,
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                        ),
                        Text('$completedPercentage %',
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: AspectRatio(
                          aspectRatio: 12 / 9,
                          child: StaticGameView(game: board)),
                    ),
                    Text(boardName,
                        style: Theme.of(context).textTheme.titleSmall)
                  ],
                ),
              ),
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

Widget _buildIconTile(BuildContext context, Axis direction, String text,
    IconData icon, NyaNyaRoutePath routePath) {
  return Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          direction: direction,
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runAlignment: WrapAlignment.center,
          runSpacing: 4.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Icon(
                icon,
                size: 50.0,
              ),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
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
