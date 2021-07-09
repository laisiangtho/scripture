
# ?

```dart
import 'package:flutter/foundation.dart';

class NodeNotifier extends ChangeNotifier {
  bool _hasFocus = false;

  bool get focus => _hasFocus;
  set focus(bool newFocus) {
    if (newFocus != _hasFocus){
      _hasFocus = newFocus;
      notifyListeners();
    }
  }
}
