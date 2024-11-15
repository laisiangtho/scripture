part of 'main.dart';

/// App instance that providing Core, Data, Route, Preference, Authenticate and Context
class App {
  /// App Core where each api sourced
  /// ```dart
  /// App.core;
  /// app;
  /// ```
  static final Core core = Core();
}

/// Common state
abstract class CommonStates<T extends StatefulWidget> extends SharedState<T> {
  @override
  late final Core app = App.core;

  @override
  late final Data data = app.data;

  @override
  late final Preference preference = app.preference;

  @override
  AppLocalizations get lang => context.lang;
}

/// Draggable sheet state
abstract class SheetStates<T extends StatefulWidget> extends DraggableSheets<T> {
  @override
  late final Core app = App.core;

  @override
  late final Data data = app.data;

  @override
  late final Preference preference = app.preference;

  @override
  AppLocalizations get lang => context.lang;
}

/// Search state
abstract class SearchEngineStates<T extends StatefulWidget> extends SearchViews<T> {
  @override
  late final Core app = App.core;

  @override
  late final Data data = app.data;

  @override
  late final Preference preference = app.preference;

  @override
  AppLocalizations get lang => context.lang;
}

/// Search state
abstract class SearchRecentsStates<T extends StatefulWidget> extends SearchRecents<T> {
  @override
  late final Core app = App.core;

  @override
  late final Data data = app.data;

  @override
  late final Preference preference = app.preference;

  @override
  AppLocalizations get lang => context.lang;
}

/// Search state
abstract class SearchHistoriesStates<T extends StatefulWidget> extends HistoriesState<T> {
  @override
  late final Core app = App.core;

  @override
  late final Data data = app.data;

  @override
  late final Preference preference = app.preference;

  @override
  AppLocalizations get lang => context.lang;
}
