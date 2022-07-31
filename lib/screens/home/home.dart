import 'package:flutter/material.dart';

import '../../config.dart';
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
          const SizedBox(height: 16.0),
          _buildOtherRow(context),
          const SizedBox(height: 8.0),
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
          Expanded(flex: 4, child: _buildPlayRow(context, Axis.horizontal)),
          const Spacer(),
          _buildOtherRow(context),
          const Spacer(),
          _buildFourthRow(context),
        ],
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'NyaNya Rocket!',
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .apply(fontFamily: 'Russo One'),
          textAlign: TextAlign.center,
        ),
      ],
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
              onTap: () {
                Router.of(context)
                    .routerDelegate
                    .setNewRoutePath(const NyaNyaRoutePath.originalPuzzles());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [Text('Puzzles'), Text('58/100')],
                    ),
                    AspectRatio(
                        aspectRatio: 12 / 9,
                        child: StaticGameView(
                            game: OriginalPuzzles.puzzles[0].data.gameData))
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
              onTap: () {
                Router.of(context).routerDelegate.setNewRoutePath(
                    const NyaNyaRoutePath.originalChallenges());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [Text('Challenges'), Text('58/100')],
                    ),
                    AspectRatio(
                        aspectRatio: 12 / 9,
                        child: StaticGameView(
                            game: OriginalPuzzles.puzzles[0].data.gameData))
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherRow(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton.icon(
          label: const Text('Settings'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const Settings()));
          },
          icon: const Icon(Icons.settings)),
      ElevatedButton.icon(
        onPressed: () {
          Router.of(context)
              .routerDelegate
              .setNewRoutePath(const NyaNyaRoutePath.multiplayer());
        },
        icon: const Icon(Icons.groups),
        label: const Text('Multiplayer'),
      ),
      ElevatedButton.icon(
        onPressed: () {
          Router.of(context)
              .routerDelegate
              .setNewRoutePath(const NyaNyaRoutePath.editor());
        },
        icon: const Icon(Icons.mode_edit),
        label: const Text('Editor'),
      )
    ]);
  }

  Widget _buildFourthRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationLegalese: kAboutText,
              applicationVersion: kAboutVersion,
            );
          },
          icon: const Icon(Icons.info),
          label: const Text('About'),
        ),
        ElevatedButton.icon(
            label: const Text('How to play'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Tutorial()));
            },
            icon: const Icon(Icons.help)),
      ],
    );
  }
}
