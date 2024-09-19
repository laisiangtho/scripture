import 'package:flutter/material.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends SearchRecents<Main> {
  @override
  late final Core app = App.core;

  @override
  void onSearch(RecentSearchType item) {
    context.push('/search', extra: {'keyword': item.word});
  }

  @override
  String get doConfirmMessage => app.preference.of(context).confirmToDelete('all');
  @override
  String get doConfirmTitle => app.preference.of(context).confirmation;
  @override
  String get doConfirmCancel => app.preference.of(context).cancel;
  @override
  String get doConfirmSubmit => app.preference.of(context).confirm;
  @override
  String get labelBack => app.preference.of(context).back;
  @override
  String get labelHeaderTitle =>
      app.preference.of(context).keyword(boxOfRecentSearch.plural.toString());
  @override
  String get labelSectionTitle => app.preference.of(context).recentSearch('false');
  @override
  String get labelDismissibleBackground => app.preference.of(context).delete;
  @override
  String messageOnEmpty(int test) => app.preference.of(context).recentSearchCount(0);
  @override
  String labelItemTrailing(RecentSearchType item) => app.scripturePrimary.digit(item.hit);
}
