part of 'main.dart';

class DefinitionBible {
  final BooksType info;
  final Map note;
  final Map language;
  final List digit;
  final Map testament;
  final Map story;
  final Map book;

  // NOTE: used only in view
  List<DefinitionTestament> testamentInfo;
  List<DefinitionBook> bookInfo;

  DefinitionBible({
    required this.info,
    required this.note,
    required this.language,
    required this.digit,
    required this.testament,
    required this.story,
    required this.book,
    required this.testamentInfo,
    required this.bookInfo,
  });

  factory DefinitionBible.fromJSON(Map<String, dynamic> o) {
    return DefinitionBible(
      info: BooksType.fromJSON(o['info']),
      note: o['note'],
      language: o['language'],
      digit: o['digit'] as List,
      testament: o['testament'],
      story: o['story'],
      book: o['book'],
      testamentInfo: [],
      bookInfo: [],
    );
  }

  // Map<String, dynamic> toJSON() {
  //   return {
  //     'info': this.info.toJSON(),
  //     'note': this.note,
  //     'language': this.language,
  //     'digit': this.digit,
  //     'testament': this.testament,
  //     'story': this.story,
  //     'book': this.book,
  //   };
  // }
}

class DefinitionTestament {
  final int id;
  final String name;
  final String shortName;

  DefinitionTestament({
    required this.id,
    required this.name,
    required this.shortName,
  });
}

class DefinitionBook {
  final int testamentId;

  final int id;
  final String name;
  final String shortName;

  final int chapterCount;
  DefinitionBook({
    required this.testamentId,
    required this.id,
    required this.name,
    required this.shortName,
    required this.chapterCount,
  });
}

class BIBLE {
  final BooksType info;
  final List<BOOK> book;

  // NOTE: used in search result
  final String query;
  int bookCount;
  int chapterCount;
  int verseCount;

  BIBLE({
    required this.info,
    required this.book,
    this.query = '',
    this.bookCount = 0,
    this.chapterCount = 0,
    this.verseCount = 0,
  });
}

class BOOK {
  // int id;
  // String name;
  final DefinitionBook info;
  final List<CHAPTER> chapter;
  BOOK({
    // this.id,
    // this.name,
    required this.info,
    required this.chapter,
  });

  // factory BOOK.fromJSON(dynamic id,Map<String, dynamic> o) {
  //   return BOOK(
  //     id:int.parse(id),
  //     name:o['info']['name'],
  //     chapter:[]
  //   );
  // }
}

class CHAPTER {
  final int id;
  final String name;
  final List<VERSE> verse;
  CHAPTER({
    required this.id,
    required this.name,
    required this.verse,
  });
}

class VERSE {
  final dynamic key;
  final int id;
  final String name;
  final String text;
  final String title;
  final String reference;
  final String merge;
  VERSE({
    required this.key,
    required this.id,
    required this.name,
    required this.text,
    required this.title,
    required this.reference,
    required this.merge,
  });

  factory VERSE.fromJSON(dynamic key, int id, String name, Map<String, dynamic> o) {
    return VERSE(
      key: key,
      id: id,
      name: name,
      text: o['text'],
      title: o['title'] ?? '',
      reference: o['text'] ?? '',
      merge: o['merge'] ?? '',
    );
  }
}
