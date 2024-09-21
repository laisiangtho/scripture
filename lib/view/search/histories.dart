part of 'main.dart';

class _Histories extends StatefulWidget {
  const _Histories();

  @override
  State<StatefulWidget> createState() => _HistoriesView();
}

class _HistoriesView extends SearchHistoriesStates<_Histories> {
  @override
  String labelHeaderTitle(test) => lang.recentSearch(test.toString());

  @override
  String? labelItemTrailing(item) => app.scripturePrimary.digit(item.hit);

  @override
  String? get messageAWordOrTwo => lang.aWordOrTwo;

  @override
  String? get messageDismissibleBackground => lang.delete;
}
