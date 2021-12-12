import 'package:flutter/material.dart';

import '../../../localization/nyanya_localizations.dart';
import '../../../models/challenge_data.dart';
import '../../../models/multiplayer_board.dart';
import '../../../models/named_challenge_data.dart';
import '../../../models/named_puzzle_data.dart';
import '../../../models/puzzle_data.dart';
import '../screens/challenge_editor.dart';
import '../screens/multiplayer_editor.dart';
import '../screens/puzzle_editor.dart';
import 'name_field.dart';

enum EditorMode { puzzle, challenge, multiplayer }

class CreateTab extends StatefulWidget {
  static final RegExp nameRegExp = RegExp(r'^[ -~]{2,24}$');

  const CreateTab({Key? key}) : super(key: key);

  @override
  _CreateTabState createState() => _CreateTabState();
}

class _CreateTabState extends State<CreateTab> {
  String _name = '';
  EditorMode _mode = EditorMode.puzzle;
  ChallengeType _challengeType = ChallengeType.getMice;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final localized = NyaNyaLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NameFormField(
                  onSaved: (String? newValue) {
                    _name = newValue ?? _name;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<EditorMode>(
                  value: _mode,
                  items: <DropdownMenuItem<EditorMode>>[
                    DropdownMenuItem(
                      child: Text(localized.puzzleType),
                      value: EditorMode.puzzle,
                    ),
                    DropdownMenuItem(
                      child: Text(localized.challengeType),
                      value: EditorMode.challenge,
                    ),
                    DropdownMenuItem(
                      child: Text(localized.multiplayerType),
                      value: EditorMode.multiplayer,
                    ),
                  ],
                  onChanged: (EditorMode? value) {
                    if (value != null) {
                      setState(() {
                        _mode = value;
                      });
                    }
                  },
                  onSaved: (EditorMode? value) => _mode = value ?? _mode,
                ),
                Visibility(
                  visible: _mode == EditorMode.challenge,
                  child: DropdownButtonFormField<ChallengeType>(
                    value: _challengeType,
                    items: <DropdownMenuItem<ChallengeType>>[
                      DropdownMenuItem(
                        child: Text(
                            ChallengeType.getMice.toLocalizedString(context)),
                        value: ChallengeType.getMice,
                      ),
                      DropdownMenuItem(
                        child: Text(
                            ChallengeType.runAway.toLocalizedString(context)),
                        value: ChallengeType.runAway,
                      ),
                      DropdownMenuItem(
                        child: Text(
                            ChallengeType.lunchTime.toLocalizedString(context)),
                        value: ChallengeType.lunchTime,
                      ),
                      DropdownMenuItem(
                        child: Text(ChallengeType.oneHundredMice
                            .toLocalizedString(context)),
                        value: ChallengeType.oneHundredMice,
                      ),
                    ],
                    onChanged: (ChallengeType? value) {
                      if (value != null) {
                        setState(() {
                          _challengeType = value;
                        });
                      }
                    },
                    onSaved: (ChallengeType? value) =>
                        _challengeType = value ?? _challengeType,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                    child: Text(localized.createLabel),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (BuildContext _) {
                          switch (_mode) {
                            case EditorMode.puzzle:
                              return PuzzleEditor(
                                  puzzle: NamedPuzzleData(
                                      name: _name,
                                      puzzleData: PuzzleData.withBorder()));

                            case EditorMode.challenge:
                              return ChallengeEditor(
                                challenge: NamedChallengeData(
                                    name: _name,
                                    challengeData: ChallengeData.withBorder(
                                        type: _challengeType)),
                              );

                            case EditorMode.multiplayer:
                              return MultiplayerEditor(
                                board: MultiplayerBoard.withBorder(
                                    name: _name, maxPlayer: 2),
                              );
                          }
                        }));
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
