import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/models/named_challenge_data.dart';
import 'package:nyanya_rocket/models/named_puzzle_data.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/screens/editor/screens/challenge_editor.dart';
import 'package:nyanya_rocket/screens/editor/screens/multiplayer_editor.dart';
import 'package:nyanya_rocket/screens/editor/screens/puzzle_editor.dart';
import 'package:nyanya_rocket/screens/editor/widgets/name_field.dart';

enum EditorMode { Puzzle, Challenge, Multiplayer }

class CreateTab extends StatefulWidget {
  static final RegExp nameRegExp = RegExp(r'^[ -~]{2,24}$');

  @override
  _CreateTabState createState() => _CreateTabState();
}

class _CreateTabState extends State<CreateTab>
    with AutomaticKeepAliveClientMixin<CreateTab> {
  String _name = '';
  EditorMode _mode = EditorMode.Puzzle;
  ChallengeType _challengeType = ChallengeType.GetMice;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Spacer(flex: 2),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  NameFormField(
                    onSaved: (String? newValue) {
                      _name = newValue ?? _name;
                    },
                  ),
                  DropdownButtonFormField<EditorMode>(
                    value: _mode,
                    items: <DropdownMenuItem<EditorMode>>[
                      DropdownMenuItem(
                        child: Text(NyaNyaLocalizations.of(context).puzzleType),
                        value: EditorMode.Puzzle,
                      ),
                      DropdownMenuItem(
                        child:
                            Text(NyaNyaLocalizations.of(context).challengeType),
                        value: EditorMode.Challenge,
                      ),
                      DropdownMenuItem(
                        child: Text(
                            NyaNyaLocalizations.of(context).multiplayerType),
                        value: EditorMode.Multiplayer,
                      ),
                    ],
                    onChanged: (EditorMode? value) {
                      if (value != null)
                        setState(() {
                          _mode = value;
                        });
                    },
                    onSaved: (EditorMode? value) => _mode = value ?? _mode,
                  ),
                  Visibility(
                    visible: _mode == EditorMode.Challenge,
                    child: DropdownButtonFormField<ChallengeType>(
                      value: _challengeType,
                      items: <DropdownMenuItem<ChallengeType>>[
                        DropdownMenuItem(
                          child: Text(
                              ChallengeType.GetMice.toLocalizedString(context)),
                          value: ChallengeType.GetMice,
                        ),
                        DropdownMenuItem(
                          child: Text(
                              ChallengeType.RunAway.toLocalizedString(context)),
                          value: ChallengeType.RunAway,
                        ),
                        DropdownMenuItem(
                          child: Text(ChallengeType.LunchTime.toLocalizedString(
                              context)),
                          value: ChallengeType.LunchTime,
                        ),
                        DropdownMenuItem(
                          child: Text(
                              ChallengeType.OneHundredMice.toLocalizedString(
                                  context)),
                          value: ChallengeType.OneHundredMice,
                        ),
                      ],
                      onChanged: (ChallengeType? value) {
                        if (value != null)
                          setState(() {
                            _challengeType = value;
                          });
                      },
                      onSaved: (ChallengeType? value) =>
                          _challengeType = value ?? _challengeType,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        child:
                            Text(NyaNyaLocalizations.of(context).createLabel),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (BuildContext _) {
                              switch (_mode) {
                                case EditorMode.Puzzle:
                                  return PuzzleEditor(
                                      puzzle: NamedPuzzleData.fromPuzzleData(
                                          name: _name,
                                          puzzleData: PuzzleData.withBorder()));

                                case EditorMode.Challenge:
                                  return ChallengeEditor(
                                    challenge:
                                        NamedChallengeData.fromChallengeData(
                                            name: _name,
                                            challengeData:
                                                ChallengeData.withBorder(
                                                    type: _challengeType)),
                                  );

                                case EditorMode.Multiplayer:
                                  return MultiplayerEditor(
                                    board: MultiplayerBoard.withBorder(
                                        name: _name, maxPlayer: 2),
                                  );
                              }
                            }));
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
