part of '../main.dart';

/// Scripture marks with notify
class Marks extends Notify {
  bool _ready = false;
  MarkBible _marks = MarkBible(bible: []);
  // List<MarkBook> list = [];
  /// Verse selection session
  List<int> verseSelection = [];

  /// Supported color withOpacity or lighten
  final double colorOpacity = 0.3;
  late final double colorOpacityButton = colorOpacity;
  late final double colorOpacityText = colorOpacity - 0.17;

  /// List of supported color list
  late final List<MarksColor> colors = [
    MarksColor(color: Colors.red, name: 'red'),
    MarksColor(color: Colors.blue, name: 'blue'),
    MarksColor(color: Colors.green, name: 'green'),
    MarksColor(color: Colors.orange, name: 'orange'),
    MarksColor(color: Colors.grey, name: 'grey'),
    MarksColor(color: Colors.amber, name: 'amber'),
    MarksColor(color: Colors.brown, name: 'brown'),
    MarksColor(color: Colors.cyan, name: 'cyan'),
    MarksColor(color: Colors.indigo, name: 'indigo'),
    MarksColor(color: Colors.lime, name: 'lime'),
    MarksColor(color: Colors.pink, name: 'pink'),
    MarksColor(color: Colors.purple, name: 'purple'),
    MarksColor(color: Colors.teal, name: 'teal'),
    MarksColor(color: Colors.yellow, name: 'yellow'),
  ];

  final Data data;
  Marks(this.data);

  APIType get api => data.env.url('marks');
  // String get file => api.cache('user_marks_v1');
  String get file => api.cache('user_marks_v3');

  Future<void> init() async {
    if (!_ready) {
      // await delete();
      await _read();
    }
  }

  Paint? verseBackground(int vid) {
    final cb = currentBook;
    if (cb.isNotEmpty) {
      final vrIndex = cb.first.verse.indexWhere((e) => e.id == vid);
      if (vrIndex >= 0) {
        final vrBlock = cb.first.verse.elementAt(vrIndex);
        final colorIndex = vrBlock.color;
        if (colorIndex != null && colorIndex > -1 && colorIndex < colors.length) {
          final sefs = colors.elementAt(colorIndex);
          // return Paint()..color = sefs.color.withOpacity(colorOpacityText);
          return Paint()
            ..color = sefs.color.withOpacity(colorOpacityText)
            ..strokeWidth = 5
            ..strokeJoin = StrokeJoin.round
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.fill;
          // return Paint()..color = sefs.lighten(amount: 0.38);
        }
      }
    }

    return null;
  }

  String? verseNote(int vid) {
    final cb = currentBook;
    if (cb.isNotEmpty) {
      final vrIndex = cb.first.verse.indexWhere((e) => e.id == vid);
      if (vrIndex >= 0) {
        final vrBlock = cb.first.verse.elementAt(vrIndex);
        if (vrBlock.note != null) {
          return vrBlock.note;
        }
      }
    }

    return null;
  }

  /// Toggle selection add or remove
  void setSelection(int id) {
    // primaryScripture.digit(verse.id);
    int index = verseSelection.indexWhere((i) => i == id);
    if (index >= 0) {
      // value.removeAt(index);

      verseSelection = List.from(verseSelection)..removeAt(index);
    } else {
      // value.add(id);

      verseSelection = List.from(verseSelection)..add(id);
    }
    // primaryScripture.count.value = List.from(value)..add(...);
    // primaryScripture.count = value;

    notify();
  }

  bool get hasSelection => verseSelection.isNotEmpty;

  /// hasSelected
  bool hasSelected(int verseId) {
    return verseSelection.indexWhere((id) => id == verseId) >= 0;
  }

  void resetSelection() {
    verseSelection = [];
    notify();
  }

  /// Apply on current reading chapter
  void selectionApply({int? color, String? note, List<int>? verses}) {
    if (color == null && note == null) {
      return;
    }

    final vLists = verses ?? verseSelection;
    MarkBook newData = MarkBook(
      book: data.bookId,
      chapter: data.chapterId,
      verse: [],
    );
    final inB =
        _marks.bible.indexWhere((e) => e.book == data.bookId && e.chapter == data.chapterId);

    final hasBook = inB >= 0;
    if (hasBook) {
      newData = _marks.bible.elementAt(inB);
    }

    bool noteAdded = false;

    for (var vId in vLists) {
      final inV = newData.verse.indexWhere((e) => e.id == vId);
      final vd = newData.verse.firstWhere((e) => e.id == vId, orElse: () {
        return MarkVerse(id: vId);
      });

      if (color != null) {
        if (vd.color != color) {
          vd.color = color;
        } else {
          vd.color = null;
        }
      }
      if (note != null) {
        // if (noteAdded == false) {
        //   vd.note = note;
        //   noteAdded = true;
        // }
        if (note.isEmpty) {
          vd.note = null;
        } else {
          if (noteAdded == false) {
            vd.note = note;
            noteAdded = true;
          }
        }
      }

      if (inV >= 0) {
        newData.verse[inV] = vd;
      } else {
        newData.verse.add(vd);
      }

      newData.verse.removeWhere((e) => e.color == null && e.note == null);
    }

    if (hasBook) {
      _marks.bible[inB] = newData;
    } else {
      _marks.bible.add(newData);
    }

    _marks.bible.removeWhere((e) => e.verse.isEmpty);
    notify();
    save();
  }

  /// Current book and chapter
  List<MarkBook> get currentBook {
    return _marks.bible.where((e) => e.book == data.bookId && e.chapter == data.chapterId).toList();
  }

  List<MarkVerse> get currentVerse {
    final abc = currentBook;
    if (abc.isNotEmpty) {
      return abc.first.verse;
    }
    return [];
  }

  Future<void> _read() async {
    if (_ready) {
      // return Future.value(list);
      return;
    }

    // UtilDocument.app;
    // UtilDocument.common.decodeJSON(response);

    return Docs.app.readAsJSON<Map<String, dynamic>>(file).then((o) {
      // final abc = Docs.raw.decodeJSON<Map<String, dynamic>>(o);
      // debugPrint('marks: $o');
      _marks = MarkBible.fromJSON(o);
    }).catchError((e) {
      /// NOTE: Future.error
      // debugPrint('marks: read $e');
      // return Future.value(list);
    }).whenComplete(() {
      _ready = true;
      notify();
    });
    // return Docs.app.readAsString(file).then((o) {
    //   final abc = Docs.raw.decodeJSON<Map<String, dynamic>>(o);
    //   // debugPrint('marks: $o');
    //   _marks = MarkBible.fromJSON(abc);
    // }).catchError((e) {
    //   /// NOTE: Future.error
    //   // debugPrint('marks: read $e');
    //   // return Future.value(list);
    // }).whenComplete(() {
    //   _ready = true;
    //   notify();
    // });
  }

  /// Need not to wait
  Future<void> save() {
    final raw = _marks.toJSON();
    // Docs.app
    //     .writeAsString(
    //   file,
    //   Docs.raw.encodeJSON(o),
    // )
    //     .catchError((e) {
    //   /// NOTE: Future.error
    //   // debugPrint('marks: write $e');
    //   return e;
    // });
    return Docs.app.writeAsJSON<Map<String, dynamic>>(file, raw).catchError((e) {
      /// NOTE: Future.error
      // debugPrint('marks: write $e');
      return e;
    });
  }

  /// Backup to supported device library
  /// TODO: to be integrated
  Future<void> backup() {
    final raw = Docs.raw.encodeJSON(_marks.toJSON(), space: 2);
    String fileName = file.replaceFirst('.json', '.txt');
    return Docs.user.writeAsString(fileName, raw).then((e) {
      // debugPrint('marks: backup ${e.path}');
    }).catchError((e) {
      /// NOTE: Future.error
      // debugPrint('marks: backup $e');
      // return e;
    });
  }

  Future<void> delete() {
    return Docs.app.delete(file).then((_) {
      // _list = [];
    }).catchError((e) {
      /// NOTE: Future.error
    }).whenComplete(() {
      // list = [];
      _marks.reset();
    });
  }
}

class MarksColor {
  final Color color;
  final String name;

  MarksColor({
    required this.color,
    required this.name,
  });
}
