import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class NyaNyaLocalizationsDelegate
    extends LocalizationsDelegate<NyaNyaLocalizations> {
  const NyaNyaLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<NyaNyaLocalizations> load(Locale locale) {
    return NyaNyaLocalizations.load(locale);
  }

  @override
  bool shouldReload(NyaNyaLocalizationsDelegate old) => false;
}
