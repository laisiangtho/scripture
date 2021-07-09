# ?

```dart
import 'package:flutter/foundation.dart';

class HistoryNotifier extends ChangeNotifier {
  int _current = 0;
  int _next = 0;
  int _previous = 0;

  int get next => _next;
  int get previous => _previous;

  int get current => _current;
  set current(int index) {
    _current = index;
    notifyListeners();
  }
}
