part of 'main.dart';

class OfBible {
  final BooksType info;
  final Map note;
  final Map language;
  final List digit;
  final List<OfTestament> testament;
  final Map<String, dynamic> story;
  final List<OfBook> book;

  OfBible({
    required this.info,
    required this.note,
    required this.language,
    required this.digit,
    required this.testament,
    required this.story,
    required this.book,
  });

  factory OfBible.fromJSON(Map<String, dynamic> o) {
    final info = BooksType.fromJSON(o['info']);
    return OfBible(
      info: info,
      note: o['note'],
      language: o['language'],
      digit: o['digit'] as List,
      testament:
          (o["testament"] as Map<String, dynamic>).entries.map(OfTestament.fromJSON).toList(),
      story: o['story'],
      // book: (o["book"] as Map<String, dynamic>).entries.map(OfBook.fromJSON).toList(),
      book: (o["book"] as Map<String, dynamic>).entries.map((e) {
        return OfBook.fromJSON(info.identify, e);
      }).toList(),
    );
  }

  /// A copy of [OfBible].
  ///
  /// If [listOfBook] not provided everything is empty, except [OfBible.info]
  OfBible prototype({List<OfBook>? listOfBook}) {
    if (listOfBook != null) {
      return OfBible(
        info: info,
        note: note,
        language: language,
        digit: digit,
        testament: testament,
        story: story,
        book: listOfBook,
      );
    }

    return OfBible(
      info: info,
      note: {},
      language: {},
      digit: [],
      testament: [],
      story: {},
      book: [],
    );
  }

  /// check if there are books, see [OfBible.book]
  bool get ready => book.isNotEmpty;

  /// Total book, see [OfBible.book]
  int get totalBook => book.length;

  /// Total chapters of the Book, see [OfBook.totalChapter]
  int get totalChapter => book.fold(0, (i, c) => i + c.totalChapter);

  /// Total verses of the Book in all,
  /// See [OfBook.totalVerse] and [OfChapter.totalVerse]
  int get totalVerse => book.fold(0, (i, c) => i + c.totalVerse);

  /// get book by [bookId]
  OfBible getBook(int bookId) {
    final List<OfBook> res = [];
    for (var o in book) {
      if (o.info.id == bookId) {
        res.add(o);
        break;
      }
    }
    return prototype(listOfBook: res);
  }

  /// get chapter by [bookId], and [chapterId].
  /// See [getBook] and [OfBook.getChapter]
  OfBible getChapter(int bookId, int chapterId) {
    final List<OfBook> res = [];
    for (final e in getBook(bookId).book) {
      final o = e.getChapter(chapterId);
      if (o.chapter.isNotEmpty) {
        res.add(o);
        break;
      }
    }
    return prototype(listOfBook: res);
  }

  /// get all Titles, see [OfVerse.hasTitle]
  OfBible getTitle() {
    final List<OfBook> res = [];
    for (final e in book) {
      final o = e.getTitle();
      if (o.chapter.isNotEmpty) {
        res.add(o);
      }
    }
    return prototype(listOfBook: res);
  }

  /// get all Titles, see [OfVerse.hasMerge]
  OfBible getMerge() {
    final List<OfBook> res = [];
    for (final e in book) {
      final o = e.getMerge();
      if (o.chapter.isNotEmpty) {
        res.add(o);
      }
    }
    return prototype(listOfBook: res);
  }

  /// Search the [keyword] that contianing in the verses
  /// See [OfVerse.wordContains]
  OfBible wordContains(String keyword) {
    final List<OfBook> res = [];
    for (final e in book) {
      final o = e.wordContains(keyword);
      if (o.chapter.isNotEmpty) {
        res.add(o);
      }
    }
    return prototype(listOfBook: res);
  }

  /// Search the [keyword] in the verses that each words start with
  /// See [OfVerse.wordStarts]
  OfBible wordStarts(String keyword) {
    final List<OfBook> res = [];
    for (final e in book) {
      final o = e.wordStarts(keyword);
      if (o.chapter.isNotEmpty) {
        res.add(o);
      }
    }
    return prototype(listOfBook: res);
  }

  /// Search the [keyword] in the verses that each words end with
  /// See [OfVerse.wordEnds]
  OfBible wordEnds(keyword) {
    final List<OfBook> res = [];
    for (final e in book) {
      final o = e.wordEnds(keyword);
      if (o.chapter.isNotEmpty) {
        res.add(o);
      }
    }
    return prototype(listOfBook: res);
  }

  /// Search the [keyword] in the verses and extract each words that not not complete
  /// See [OfVerse.wordExtracts]
  Set<String> wordExtracts(keyword) {
    final Set<String> res = {};
    for (final o in book) {
      final e = o.wordExtracts(keyword);
      if (e.isNotEmpty) {
        res.addAll(e);
      }
    }
    return res;
  }
}

class OfTestament {
  final dynamic key;
  final int id;
  final InfoOfTestament info;
  final Map<String, dynamic> other;
  OfTestament({
    required this.key,
    required this.id,
    required this.info,
    required this.other,
  });

  factory OfTestament.fromJSON(MapEntry<String, dynamic> o) {
    return OfTestament(
      key: GlobalKey(),
      id: int.parse(o.key),
      info: InfoOfTestament.fromJSON(o.value['info']),
      other: {},
    );
  }
}

class OfBook {
  final dynamic key;
  final InfoOfBook info;
  final Map<String, dynamic> topic;
  final List<OfChapter> chapter;
  OfBook({
    required this.key,
    required this.info,
    required this.topic,
    required this.chapter,
  });

  factory OfBook.fromJSON(String identify, MapEntry<String, dynamic> o) {
    return OfBook(
      key: GlobalKey(),
      info: InfoOfBook.fromJSON(o),
      topic: {},
      // chapter: (o.value["chapter"] as Map<String, dynamic>).entries.map(OfChapter.fromJSON).toList(),
      chapter: (o.value["chapter"] as Map<String, dynamic>).entries.map((e) {
        return OfChapter.fromJSON(identify, e);
      }).toList(),
    );
  }

  /// Total chapters of the Book, see [OfBook.chapter]
  int get totalChapter => chapter.length;

  /// Total verses of the Book in all chapters, see [OfChapter.totalVerse]
  int get totalVerse => chapter.fold(0, (i, c) => i + c.totalVerse);

  OfBook _selection(List<OfChapter> e) {
    return OfBook(
      key: key,
      info: info,
      topic: topic,
      chapter: e,
    );
  }

  /// get Chapter by [chapterId]
  OfBook getChapter(int chapterId) {
    final List<OfChapter> res = [];
    for (var e in chapter) {
      if (e.id == chapterId) {
        res.add(e);
        break;
      }
    }
    return _selection(res);
  }

  /// get Title from Chapters and verses
  /// See [OfVerse.hasTitle].
  OfBook getTitle() {
    final List<OfChapter> res = [];
    for (var o in chapter) {
      final e = o.getTitle();
      if (e.verse.isNotEmpty) {
        res.add(e);
      }
    }
    return _selection(res);
  }

  /// get Title from Chapters and verses
  /// See [OfVerse.hasMerge]. hasMerge
  OfBook getMerge() {
    final List<OfChapter> res = [];
    for (var o in chapter) {
      final e = o.getMerge();
      if (e.verse.isNotEmpty) {
        res.add(e);
      }
    }
    return _selection(res);
  }

  /// See [OfVerse.wordContains].
  OfBook wordContains(String keyword) {
    final List<OfChapter> res = [];
    for (var o in chapter) {
      final e = o.wordContains(keyword);
      if (e.verse.isNotEmpty) {
        res.add(e);
      }
    }
    return _selection(res);
  }

  /// See [OfVerse.wordStarts].
  OfBook wordStarts(String keyword) {
    final List<OfChapter> res = [];
    for (var o in chapter) {
      final e = o.wordStarts(keyword);
      if (e.verse.isNotEmpty) {
        res.add(e);
      }
    }
    return _selection(res);
  }

  /// See [OfVerse.wordEnds].
  OfBook wordEnds(String keyword) {
    final List<OfChapter> res = [];
    for (var o in chapter) {
      final e = o.wordEnds(keyword);
      if (e.verse.isNotEmpty) {
        res.add(e);
      }
    }
    return _selection(res);
  }

  /// See [OfVerse.wordExtracts].
  Set<String> wordExtracts(String keyword) {
    final Set<String> res = {};
    for (var o in chapter) {
      final e = o.wordExtracts(keyword);
      if (e.isNotEmpty) {
        res.addAll(e);
      }
    }
    return res;
  }
}

class OfChapter {
  final dynamic key;
  final int id;
  final String name;
  final List<OfVerse> verse;
  OfChapter({
    required this.key,
    required this.id,
    required this.name,
    required this.verse,
  });

  factory OfChapter.fromJSON(String identify, MapEntry<String, dynamic> o) {
    return OfChapter(
      key: GlobalKey(),
      id: int.parse(o.key),
      name: o.key,
      // verse: List<OfVerse>.from(o.value["verse"].map(OfVerse.fromJSON)),
      // verse: (o.value["verse"] as Map<String, dynamic>).entries.map(OfVerse.fromJSON).toList(),
      verse: (o.value["verse"] as Map<String, dynamic>).entries.map((e) {
        return OfVerse.fromJSON(identify, e);
      }).toList(),
    );
  }

  int get totalVerse => verse.length;

  OfChapter _selection(List<OfVerse> e) {
    return OfChapter(
      key: key,
      id: id,
      name: name,
      verse: e,
    );
  }

  /// get Title from Verses
  /// See [OfVerse.hasTitle].
  OfChapter getTitle() {
    final List<OfVerse> res = [];
    for (var e in verse) {
      if (e.hasTitle) {
        res.add(e);
      }
    }
    return _selection(res);
  }

  /// get Merge from Verses
  /// See [OfVerse.hasMerge].
  OfChapter getMerge() {
    final List<OfVerse> res = [];
    for (var e in verse) {
      if (e.hasMerge) {
        res.add(e);
      }
    }
    return _selection(res);
  }

  /// search Verses if containing the [keyword]
  /// See [OfVerse.wordContains].
  OfChapter wordContains(String keyword) {
    final List<OfVerse> res = [];
    for (var e in verse) {
      if (e.wordContains(keyword)) {
        res.add(e);
      }
    }
    return _selection(res);
  }

  /// See [OfVerse.wordStarts].
  OfChapter wordStarts(String keyword) {
    final List<OfVerse> res = [];
    for (var e in verse) {
      if (e.wordStarts(keyword)) {
        res.add(e);
      }
    }
    return _selection(res);
  }

  /// See [OfVerse.wordEnds].
  OfChapter wordEnds(String keyword) {
    final List<OfVerse> res = [];
    for (var e in verse) {
      if (e.wordEnds(keyword)) {
        res.add(e);
      }
    }
    return _selection(res);
  }

  /// See [OfVerse.wordExtracts].
  Set<String> wordExtracts(String keyword) {
    final Set<String> res = {};
    for (var e in verse) {
      final w = e.wordExtracts(keyword);
      if (w != null) {
        res.add(w);
      }
    }
    return res;
  }
}

class OfVerse {
  final dynamic key;
  final int id;
  String name;
  bool test;

  final String text;
  final String title;
  final String reference;
  final String merge;
  OfVerse({
    required this.key,
    required this.id,
    required this.name,
    this.test = false,
    required this.text,
    required this.title,
    required this.reference,
    required this.merge,
  });

  factory OfVerse.fromJSON(String identify, MapEntry<String, dynamic> o) {
    return OfVerse(
      key: GlobalKey(),
      id: int.parse(o.key),
      name: o.key,
      // text: o.value['text'],
      // text: (o.value['text'] ?? '').toString(),
      text: _quoteFormat(identify, (o.value['text'] ?? '').toString()),
      title: (o.value['title'] ?? '').toString().trim(),
      reference: o.value['reference'] ?? '',
      merge: o.value['merge'] ?? '',
    );
  }

  static String _quoteFormat(String identify, String v) {
    // return v
    //     .replaceAll('``', '“')
    //     .replaceAll("''", '”')
    //     .replaceAll("``", '“')
    //     .replaceAll("´´", '”')
    //     .replaceAll("„", '“')
    //     .replaceAll('\'\'', '”')
    //     .trim();

    switch (identify) {
      case '2079':
        return v.replaceAll('‘', '“').replaceAll("’", '”');
      case 'dnb1930':
        return v.replaceAll(':', '“').replaceAll("!", '.”');

      default:
        return v
            .replaceAll('``', '“')
            .replaceAll("''", '”')
            .replaceAll("``", '“')
            .replaceAll("´´", '”')
            .replaceAll("„", '“')
            .replaceAll('\'\'', '”')
            .trim();
    }
  }

  /// RegExp(keyword).hasMatch(text)
  OfVerse updateName(String e) {
    if (e != name) {
      name = e;
    }
    return this;
  }

  /// ```dart
  /// verse['merge'] != ""
  /// ```
  bool get hasMerge {
    return merge != "";
  }

  /// ```dart
  /// verse.containsKey('title') && verse['title'] != ""
  /// ```
  bool get hasTitle {
    return title != "";
  }

  /// check Verse if containing the [keyword]
  /// ```dart
  /// RegExp(keyword).hasMatch(text)
  /// ```
  bool wordContains(String keyword) {
    return RegExp(keyword, caseSensitive: false, unicode: true).hasMatch(text);
  }

  /// ```dart
  /// RegExp(\\b$keyword).hasMatch(text)
  /// RegExp(r'\b' + keyword, caseSensitive: false, unicode: true)
  /// RegExp pattern = RegExp('(^|\\s|\\w*)$keyword',multiLine: true);
  /// ```
  bool wordStarts(String keyword) {
    String term = '(^|\\s|\\w*)$keyword';
    return RegExp(term, caseSensitive: false, unicode: true).hasMatch(text);
  }

  /// ```dart
  /// RegExp('$keyword\\b').hasMatch(text);
  /// RegExp(keyword + r'\b', caseSensitive: false, unicode: true)
  /// RegExp('$keyword(\$|\\s|\\w*)',multiLine: true);
  /// RegExp('$keyword(?:[.,၊။\\s]+|\\s)',multiLine: true);
  /// ```
  bool wordEnds(String keyword) {
    String term = '$keyword(?:[.,’”၊။]+|\\s|-)';
    return RegExp(term, caseSensitive: false, unicode: true).hasMatch(text);
  }

  /// ```dart
  /// final src = '\\b\\w*$keyword[-\\w]*\\b';
  /// final src = '\\b\\w*$keyword[-\\w]*\\b';
  /// RegExp(\\b\\w*$keyword[-\\w]*\\b, caseSensitive: false).firstMatch(text)
  /// RegExp blockRegExp = RegExp('(?:^|\\w*|[^.,၊။\\s]+)($wordToSearch)(?:[^.,၊။\\s]+|\\w*|\$)', multiLine: true);
  /// r'[^\n]*\b' + keyword + r'\b[^\n]*'
  /// momaite’
  /// un,”
  /// ```
  String? wordExtracts(String keyword) {
    String term = '(?:^|\\w*|[^.,၊။\\s]+)($keyword)(?:[^.,’”၊။]+|\\s|-|\\w*|\$)';
    RegExp reg = RegExp(term, caseSensitive: false, unicode: true);

    Match? matches = reg.firstMatch(text);

    if (matches != null) {
      return matches.group(0);
    }
    return null;
  }
}

class InfoOfBook {
  final int id;
  final String name;
  final String shortName;
  final List<String> abbr;
  final String desc;
  InfoOfBook({
    required this.id,
    required this.name,
    required this.shortName,
    required this.abbr,
    required this.desc,
  });
  factory InfoOfBook.fromJSON(MapEntry<String, dynamic> o) {
    final info = o.value['info'];
    return InfoOfBook(
      id: int.parse(o.key),

      ///NOTE: replace before rendering
      name: info['name'].replaceFirst('။', '').trim(),
      shortName: info['shortname'] ?? '',
      // abbr: (info['abbr'] ?? []) as List<String>,
      abbr: List<String>.from(info['abbr']),
      desc: info['desc'] ?? '',
    );
  }

  /// (bookId >= 40) ? 2 : 1
  int get testamentId => id < 40 ? 1 : 2;
}

class InfoOfTestament {
  final String name;
  final String shortName;
  final String desc;
  InfoOfTestament({
    required this.name,
    required this.shortName,
    required this.desc,
  });
  factory InfoOfTestament.fromJSON(Map<String, dynamic> o) {
    return InfoOfTestament(
      name: o['name'],
      shortName: o['shortname'] ?? '',
      desc: o['desc'] ?? '',
    );
  }
}

class CacheBible {
  /// [OfBook] data for read and search result
  final OfBible result;

  /// Verses suggestion based on query suggest
  final OfBible suggest;

  /// Words suggestion based on query
  final Set<String> words;

  /// NOTE: used in search result
  String query;

  CacheBible({
    required this.result,
    required this.suggest,
    this.words = const {},
    this.query = '',
  });

  CacheBible update({OfBible? result, OfBible? suggest, Set<String>? words, String? query}) {
    return CacheBible(
      result: result ?? this.result,
      suggest: suggest ?? this.suggest,
      words: words ?? this.words,
      query: query ?? this.query,
    );
  }
}

class CacheSnap {
  final OfBible result;
  final bool ready;

  CacheSnap({
    required this.result,
    this.ready = false,
  });

  CacheSnap update({OfBible? result, bool? ready}) {
    return CacheSnap(
      result: result ?? this.result,
      ready: ready ?? this.ready,
    );
  }
}

/// `SnapOut` is readonly which flatten `OfBook` type into list of [bookId,chapterId, verse]
class SnapOut {
  final int bookId;
  final int chapterId;
  // final int verseId;
  // final String title;
  final OfVerse verse;

  SnapOut({
    required this.bookId,
    required this.chapterId,
    required this.verse,
  });
}

class CategoryBible {
  // final Iterable<CategoryTestament> testament;
  // final Iterable<CategorySection> section;
  final Iterable<CategoryBook> book;

  CategoryBible({
    // required this.testament,
    // required this.section,
    this.book = const [],
  });

  factory CategoryBible.fromJSON(Map<String, dynamic> o) {
    dynamic i(String key) => (o[key] ?? []);
    return CategoryBible(
      // testament: i('testament').map<CategoryTestament>((e) => CategoryTestament.fromJSON(e)),
      // section: i('section').map<CategorySection>((e) => CategorySection.fromJSON(e)),
      book: i('book').map<CategoryBook>((e) => CategoryBook.fromJSON(e)),
    );
  }
}

class CategorySection {
  final int id;
  final String name;
  final String desc;

  CategorySection({
    required this.id,
    required this.name,
    required this.desc,
  });

  factory CategorySection.fromJSON(Map<String, dynamic> o) {
    String asString(String key) => o[key].toString();
    // int asNumber(String key) => int.parse(o[key]);

    return CategorySection(
      id: o['id'],
      name: asString('name'),
      desc: asString('desc'),
    );
  }
}

class CategoryTestament {
  final int id;
  final String name;
  final String desc;
  final String shortname;

  CategoryTestament({
    required this.id,
    required this.name,
    required this.desc,
    required this.shortname,
  });

  factory CategoryTestament.fromJSON(Map<String, dynamic> o) {
    String asString(String key) => o[key].toString();
    return CategoryTestament(
      id: o['id'],
      name: asString('name'),
      desc: asString('desc'),
      shortname: asString('shortname'),
    );
  }
}

class CategoryBook {
  final int id;
  final String name;
  final String shortname;
  final String desc;
  final Iterable<String> abbr;
  final int testament;
  final int section;
  final List<int> chapter;

  CategoryBook({
    required this.id,
    required this.name,
    required this.shortname,
    required this.desc,
    required this.abbr,
    required this.testament,
    required this.section,
    required this.chapter,
  });

  factory CategoryBook.fromJSON(Map<String, dynamic> o) {
    // String asString(String key) => o[key].toString();
    // int asNumber(String key) => int.parse(o[key]);
    Map<String, dynamic> info = o['info'];
    Map<String, dynamic> clue = o['clue'];
    String infoValue(String key) => info[key];

    return CategoryBook(
      id: o['id'],
      name: infoValue('name'),
      shortname: infoValue('shortname'),
      desc: infoValue('desc'),
      abbr: (info['abbr'] ?? []).map<String>((e) => e.toString()),
      // abbr: [],
      // testament: 0,
      // section: 0,
      // verse: [],
      testament: clue['t'] as int,
      section: clue['s'] as int,
      // verse: (clue['v'] ?? []).cast<List<int>>(),
      chapter: (clue['v'] ?? []).cast<int>(),
    );
  }

  /// Total chapter
  int get totalChapter => chapter.length;

  /// Used in sending as argument
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "shortname": shortname,
      "desc": desc,
      "abbr": abbr,
      "testament": testament,
      "section": section,
      "chapter": chapter,
    };
  }
}

class CategoryGuide {
  final int id;
  final String name;
  final String shortname;
  final String desc;
  final Iterable<String> abbr;
  final int testament;
  final int section;
  final List<int> chapter;

  CategoryGuide({
    required this.id,
    required this.name,
    required this.shortname,
    required this.desc,
    required this.abbr,
    required this.testament,
    required this.section,
    required this.chapter,
  });

  factory CategoryGuide.fromJSON(Map<String, dynamic> o) {
    // String asString(String key) => o[key].toString();
    // int asNumber(String key) => int.parse(o[key]);
    Map<String, dynamic> info = o['info'];
    Map<String, dynamic> clue = o['clue'];
    String infoValue(String key) => info[key];

    return CategoryGuide(
      id: o['id'],
      name: infoValue('name'),
      shortname: infoValue('shortname'),
      desc: infoValue('desc'),
      abbr: (info['abbr'] ?? []).map<String>((e) => e.toString()),
      // abbr: [],
      // testament: 0,
      // section: 0,
      // verse: [],
      testament: clue['t'] as int,
      section: clue['s'] as int,
      // verse: (clue['v'] ?? []).cast<List<int>>(),
      chapter: (clue['v'] ?? []).cast<int>(),
    );
  }
}

class MarkBible {
  List<MarkBook> bible;
  MarkBible({
    this.bible = const [],
  });

  factory MarkBible.fromJSON(Map<String, dynamic> o) {
    return MarkBible(
      bible: ((o["bible"] ?? []) as List<dynamic>).map((e) => MarkBook.fromJSON(e)).toList(),
    );
  }

  void reset() {
    bible = [];
  }

  Map<String, dynamic> toJSON() {
    final o = bible.map((e) => e.toJSON()).toList();
    o.removeWhere((value) => value == null);
    return {
      "bible": o,
    };
  }
}

class MarkBook {
  final int book;
  final int chapter;
  final List<MarkVerse> verse;
  MarkBook({
    required this.book,
    required this.chapter,
    required this.verse,
  });

  factory MarkBook.fromJSON(Map<String, dynamic> o) {
    final ver = (o["verse"] ?? []) as List<dynamic>;
    return MarkBook(
      book: o['book'],
      chapter: o['chapter'],
      verse: ver.map((e) => MarkVerse.fromJSON(e)).toList(),
    );
  }

  Map<String, dynamic>? toJSON() {
    final vs = verse.map((e) => e.toJSON()).toList();
    vs.removeWhere((value) => value == null);

    if (vs.isEmpty) {
      return null;
    }
    return {
      "book": book,
      "chapter": chapter,
      "verse": vs,
    };
  }
}

class MarkVerse {
  final int id;
  int? color;
  String? note;

  MarkVerse({
    required this.id,
    this.color,
    this.note,
  });

  factory MarkVerse.fromJSON(Map<String, dynamic> o) {
    return MarkVerse(
      id: o['id'],
      color: o['color'],
      note: o['note'],
    );
  }

  Map<String, dynamic>? toJSON() {
    if (color == null && note == null) {
      return null;
    }
    final Map<String, dynamic> res = {"id": id};
    if (color != null) {
      res['color'] = color;
    }
    if (note != null) {
      res['note'] = note;
    }
    return res;
  }
}
