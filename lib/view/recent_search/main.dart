import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'recent-search';
  static String label = 'Recent search';
  static IconData icon = LideaIcon.listNested;

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends SearchRecents<Main> {
  @override
  late final Core app = App.core;

  @override
  void onSearch(RecentSearchType item) {
    route.pushNamed(
      'home/search',
      arguments: {'keyword': item.word},
    );
  }

  @override
  String get doConfirmMessage => preference.text.confirmToDelete('all');
  @override
  String get doConfirmTitle => preference.text.confirmation;
  @override
  String get doConfirmCancel => preference.text.cancel;
  @override
  String get doConfirmSubmit => preference.text.confirm;
  @override
  String get labelBack => preference.text.back;
  @override
  String get labelHeaderTitle => preference.text.keyword(boxOfRecentSearch.plural.toString());
  @override
  String get labelSectionTitle => preference.text.recentSearch('false');
  @override
  String get labelDismissibleBackground => preference.text.delete;
  @override
  String messageOnEmpty(int test) => preference.text.recentSearchCount(0);
  @override
  String labelItemTrailing(RecentSearchType item) => app.scripturePrimary.digit(item.hit);
}
