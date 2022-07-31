import 'package:flutter/material.dart';

import '../../localization/nyanya_localizations.dart';
import '../../widgets/navigation/bar_rail_tabs.dart';
import 'widgets/create_tab.dart';
import 'widgets/edit_tab.dart';

enum EditorMode { puzzle, challenge, multiplayer }

class Editor extends StatelessWidget {
  const Editor({super.key});

  @override
  Widget build(BuildContext context) {
    return BarRailTabs(
      title: NyaNyaLocalizations.of(context).editorTitle,
      tabs: [
        BarRailTab(
            icon: const Icon(Icons.add),
            label: NyaNyaLocalizations.of(context).newTab,
            content: const CreateTab()),
        BarRailTab(
            icon: const Icon(Icons.edit),
            label: NyaNyaLocalizations.of(context).editTab,
            content: const EditTab()),
      ],
    );
  }
}
