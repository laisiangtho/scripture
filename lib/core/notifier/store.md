# ?

```dart
import 'package:flutter/foundation.dart';

class StoreNotifier extends ChangeNotifier {
  bool _loading = true;

  bool get loading => _loading;
  set loading(bool value) {
    if (value != _loading){
      _loading = value;
      notifyListeners();
    }
  }

  // _queryProductError itemError
  String? _itemError;

  String? get itemError => _itemError!;
  set itemError(String? value) {
    if (value != _itemError){
      _itemError = value;
      notifyListeners();
    }
  }

  String _message = '';

  String get message => _message;
  set message(String value) {
    if (value != _message){
      _message = value;
      notifyListeners();
    }
  }

  bool _available = false;

  bool get available => _available;
  set available(bool value) {
    if (value != _available){
      _available = value;
      notifyListeners();
    }
  }

  // _purchasePending
  bool _pending = false;

  bool get pending => _pending;
  // purchasePending
  set pending(bool value) {
    if (value != _pending){
      _pending = value;
      notifyListeners();
    }
  }

  List<dynamic> _products = [];

  List<dynamic> get products => _products;
  set products(List<dynamic> value) {
    if (value != _products){
      _products = value;
      notifyListeners();
    }
  }

  List<String> _consumables = [];

  List<String> get consumables => _consumables;
  set consumables(List<String> value) {
    if (value != _consumables){
      _consumables = value;
      notifyListeners();
    }
  }

  List<dynamic> _purchases = [];

  List<dynamic> get purchases => _purchases;
  set purchases(List<dynamic> value) {
    if (value != _purchases){
      _purchases = value;
      notifyListeners();
    }
  }

  void apple(){

  }

  // bool _loading = true;
  // bool _isAvailable = false;
  // bool _purchasePending = false;
  // List<String> _notFoundIds = [];
  // List<ProductDetails> _products = [];
  // List<PurchaseDetails> _purchases = [];
  // List<String> _consumables = [];
  // String? _queryProductError;
}

class ParentStoreNotifier with ChangeNotifier {
// class StoreNotifier with ChangeNotifier {
  String _message = '';

  String get message => _message;
  set message(String value) {
    if (value != _message){
      _message = value;
      notifyListeners();
    }
  }
}
class ChildStoreNotifier {
  ParentStoreNotifier _instance;
  ChildStoreNotifier(this._instance);

  set updateLoading(String value) {
    _instance.message=value;
  }
}
