import 'package:flutter/material.dart';

/// NOTE: Core
import '/core/main.dart';
export '/core/main.dart';

/// NOTE: Routes
export '/view/routes.dart';

/// NOTE: Components
export '/components/main.dart';

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
}

/// Draggable sheet state
abstract class SheetStates<T extends StatefulWidget> extends DraggableSheets<T> {
  @override
  late final Core app = App.core;

  @override
  late final Data data = app.data;
}
