import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../localization/nyanya_localizations.dart';
import '../../../services/firestore/firestore_service.dart';

Widget buildNews(BuildContext context) {
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
              FutureBuilder<List<Map<String, dynamic>>>(
                future:
                    context.read<FirestoreService>().getNews(articleLocale()),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
                        children:
                            snapshot.data!.map((Map<String, dynamic> document) {
                          return ListTile(
                            title: Text(document['title']),
                            trailing: Text(MaterialLocalizations.of(context)
                                .formatShortDate(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        document['date']
                                            .millisecondsSinceEpoch))),
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

String articleLocale() {
  const availableArticleLocales = {'en', 'fr'};
  final shortLocale = Intl.shortLocale(Intl.getCurrentLocale());

  if (availableArticleLocales.contains(shortLocale)) {
    return shortLocale;
  } else {
    return 'en';
  }
}
