part of 'collection.dart';

class DefinitionBible {
  final CollectionBible info;
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
    this.info,
    this.note,
    this.language,
    this.digit,
    this.testament,
    this.story,
    this.book,
    this.testamentInfo,
    this.bookInfo,
  });

  factory DefinitionBible.fromJSON(Map<String, dynamic> o) {
    return DefinitionBible(
      info: CollectionBible.fromJSON(o['info']),
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

  Map<String, dynamic> toJSON() {
    return {
      'info': this.info.toJSON(),
      'note': this.note,
      'language': this.language,
      'digit': this.digit,
      'testament': this.testament,
      'story': this.story,
      'book': this.book,
    };
  }

}

class DefinitionTestament {
  final int id;
  final String name;
  final String shortName;

  DefinitionTestament({
    this.id,
    this.name,
    this.shortName,
  });
}

class DefinitionBook {
  final int testamentId;

  final int id;
  final String name;
  final String shortName;

  final int chapterCount;
  DefinitionBook({
    this.testamentId,
    this.id,
    this.name,
    this.shortName,
    this.chapterCount,
  });
}

class BIBLE {
  final CollectionBible info;
  final List<BOOK> book;

  // NOTE: used in search result
  final String query;
  int bookCount;
  int chapterCount;
  int verseCount;

  BIBLE({
    this.info,
    this.query,
    this.book,
    this.bookCount,
    this.chapterCount,
    this.verseCount,
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
    this.info,
    this.chapter,
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
    this.id,
    this.name,
    this.verse,
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
    this.key,
    this.id,
    this.name,
    this.text,
    this.title,
    this.reference,
    this.merge,
  });

  factory VERSE.fromJSON(dynamic key,int id,String name,Map<String, dynamic> o) {
    return VERSE(
      key:key,
      id:id,
      name: name,
      text:o['text'],
      title:o['title']??'',
      reference:o['text']??'',
      merge:o['title']??'',
    );
  }

}
