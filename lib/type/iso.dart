part of 'main.dart';

class ISOModel {
  /// ISO 639-3 language code
  String code;
  String text;
  String direction;
  String shortname;
  final List<String> bible = [];

  bool show;

  ISOModel({
    required this.code,
    required this.text,
    required this.shortname,
    this.direction = 'ltr',
    this.show = true,
  });

  void toggleShow() {
    show = !show;
  }

  List<String> get langNameList => text.split('/').map((e) => e.trim()).toList();

  int get totalBible => bible.length;
}

class ISOBible {
  /// ISO 639-3 language code
  String identify;

  String shortname;

  ISOBible({
    required this.identify,
    required this.shortname,
  });
}

// ISOCode
class ISOFilter extends Notify {
  final List<ISOModel> _items = [];

  void insert(ISOModel item) {
    final index = all.indexWhere((e) => e.code == item.code);
    // final index = _tasks.indexOf(task);
    if (index == -1) {
      item.bible.add(item.shortname);
      _items.add(item);
    } else {
      final tmp = _items[index];
      // if (!tmp.bible.contains(item.shortname)) {
      //   tmp.bible.add(item.shortname);
      // }
      tmp.bible.add(item.shortname);
    }
  }

  List<ISOModel> get all => _items;
  List<ISOModel> get selection => all.where((e) => e.show).toList();

  void toggle(ISOModel item) {
    final index = _items.indexOf(item);
    _items[index].toggleShow();
    notify();
  }

  void toggleAll() {
    for (var e in all) {
      e.toggleShow();
    }
    notify();
  }

  void delete(ISOModel item) {
    _items.remove(item);
  }
}
