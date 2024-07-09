part of '../main.dart';

/// Scripture References with notify
/// marks
/// refs Refs
class Refs extends Notify {
  bool _ready = false;

  /// Scripture category from JSON
  CategoryBible category = CategoryBible(book: []);

  final Data data;
  Refs(this.data);

  APIType get api => data.env.url('category');

  Future<void> init() async {
    // debugPrint('Categories ${api.asset}');
    if (!_ready) {
      await _initCategories().then((e) {
        category = e;
        _ready = true;
      });
    }
  }

  Future<CategoryBible> _initCategories() async {
    String file = data.env.url('category').local;
    final ob = await Docs.asset.readAsJSON<Map<String, dynamic>>(file);
    return CategoryBible.fromJSON(ob);
  }

  void reference(String e) {}
}
