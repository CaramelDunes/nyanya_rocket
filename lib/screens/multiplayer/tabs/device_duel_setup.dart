import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/local_duel.dart';

import '../../../config.dart';
import '../setup_widgets/board_picker.dart';

class DeviceDuelSetup extends StatefulWidget {
  const DeviceDuelSetup({super.key});

  @override
  State<DeviceDuelSetup> createState() => _DeviceDuelSetupState();
}

class _DeviceDuelSetupState extends State<DeviceDuelSetup> {
  final GlobalKey<FormState> _formState = GlobalKey();
  final List<String> _playerNames = ['', ''];
  final List<FocusNode> _nicknameNodes = [FocusNode(), FocusNode()];

  Duration _duration = const Duration(minutes: 3);
  MultiplayerBoard? _board;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(NyaNyaLocalizations.of(context).deviceDuelLabel),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxWidthForBigScreens),
          child: ListView(padding: const EdgeInsets.all(8.0), children: [
            Form(
                key: _formState,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      NyaNyaLocalizations.of(context).durationLabel,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    DropdownButtonFormField<Duration>(
                      value: _duration,
                      items: <DropdownMenuItem<Duration>>[
                        DropdownMenuItem(
                          value: const Duration(minutes: 2),
                          child: Text(NyaNyaLocalizations.of(context)
                              .minuteCountLabel(2)),
                        ),
                        DropdownMenuItem(
                          value: const Duration(minutes: 3),
                          child: Text(NyaNyaLocalizations.of(context)
                              .minuteCountLabel(3)),
                        ),
                        DropdownMenuItem(
                          value: const Duration(minutes: 4),
                          child: Text(NyaNyaLocalizations.of(context)
                              .minuteCountLabel(4)),
                        ),
                        DropdownMenuItem(
                          value: const Duration(minutes: 5),
                          child: Text(NyaNyaLocalizations.of(context)
                              .minuteCountLabel(5)),
                        ),
                      ],
                      onChanged: (Duration? value) => setState(() {
                        _duration = value ?? _duration;
                      }),
                      onSaved: (Duration? value) =>
                          _duration = value ?? _duration,
                    ),
                    const Divider(),
                    Text(
                      NyaNyaLocalizations.of(context).boardLabel,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: 150,
                        child: BoardPicker(
                          onChanged: (MultiplayerBoard board) {
                            setState(() {
                              _board = board;
                            });
                          },
                        ),
                      ),
                    ),
                    const Divider(),
                    Text(
                      NyaNyaLocalizations.of(context).nicknamesLabel,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextFormField(
                      focusNode: _nicknameNodes[0],
                      onFieldSubmitted: (_) {
                        _nicknameNodes[0].unfocus();
                        FocusScope.of(context).requestFocus(_nicknameNodes[1]);
                      },
                      decoration: InputDecoration(
                          hintText:
                              '${NyaNyaLocalizations.of(context).nicknameLabel} 1'),
                      maxLength: 16,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onSaved: (String? text) {
                        _playerNames[0] = text ?? _playerNames[0];
                      },
                    ),
                    TextFormField(
                      focusNode: _nicknameNodes[1],
                      decoration: InputDecoration(
                          hintText:
                              '${NyaNyaLocalizations.of(context).nicknameLabel} 2'),
                      maxLength: 16,
                      textCapitalization: TextCapitalization.words,
                      onSaved: (String? text) {
                        _playerNames[1] = text ?? _playerNames[1];
                      },
                    ),
                    Flexible(
                      child: FilledButton(
                        onPressed: _board != null
                            ? () {
                                _formState.currentState!.save();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LocalDuel(
                                          board: _board!,
                                          players: _playerNames,
                                          duration: _duration,
                                        )));
                              }
                            : null,
                        child: Text(NyaNyaLocalizations.of(context).playLabel),
                      ),
                    )
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
