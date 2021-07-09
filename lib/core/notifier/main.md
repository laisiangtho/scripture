# ?

```dart
export 'history.dart';
export 'node.dart';
export 'store.dart';

// class TestNotifier extends ChangeNotifier {
//   String _value = '';

//   String get word => _value;
//   set word(String v) {
//     if (v != _value){
//       _value = v;
//       notifyListeners();
//     }
//   }
// }

// class SuggestQueryNotifier extends ChangeNotifier {
//   String _value = '';

//   String get word => _value;
//   set word(String v) {
//     if (v != _value){
//       _value = v;
//       notifyListeners();
//     }
//   }
// }

// class SuggestListNotifier extends ChangeNotifier {
//   List<Map<String, Object>> _value;

//   List<Map<String, Object>> get data => _value;
//   set data(List<Map<String, Object>> v) {
//     _value = v;
//     notifyListeners();
//   }
// }
