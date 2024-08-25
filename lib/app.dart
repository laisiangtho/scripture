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

abstract class StateAbstract<T extends StatefulWidget> extends SharedState<T> {
  late final Map<String, dynamic> args = state.asMap;

  @override
  late final Core app = App.core;

  @override
  late final Data data = app.data;
}
