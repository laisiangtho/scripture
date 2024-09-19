part of 'main.dart';

class _Histories extends StatefulWidget {
  const _Histories();

  @override
  State<StatefulWidget> createState() => _HistoriesView();
}

class _HistoriesView extends HistoriesState<_Histories> {
  @override
  late final Core app = App.core;

  @override
  String labelHeaderTitle(test) => app.preference.of(context).recentSearch(test.toString());

  @override
  String? labelItemTrailing(item) => app.scripturePrimary.digit(item.hit);

  @override
  String? get messageAWordOrTwo => app.preference.of(context).aWordOrTwo;

  @override
  String? get messageDismissibleBackground => app.preference.of(context).delete;
}
