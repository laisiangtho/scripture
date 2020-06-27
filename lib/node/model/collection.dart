import 'package:flutter/material.dart';

class Collection {
  final List<CollectionBook> book;
  final List<CollectionBookmark> bookmark;
  final List<CollectionKeyword> keyword;
  Collection({this.book,this.bookmark, this.keyword});

  factory Collection.fromJSON(Map<String, dynamic> o) {
    return Collection(
      book: o['book'].map<CollectionBook>((json) => CollectionBook.fromJSON(json)).toList(),
      bookmark: o['bookmark'].map<CollectionBookmark>((json) => CollectionBookmark.fromJSON(json)).toList(),
      keyword: o['keyword'].map<CollectionKeyword>((json) => CollectionKeyword.fromJSON(json)).toList()
    );
  }
  Map<String, dynamic> toJSON() {
    // List book = _collectionBook.map((e)=>e.toJSON()).toList();
    return {
      'book':this.book.map((e)=>e.toJSON()).toList(),
      'bookmark':this.bookmark.map((e)=>e.toJSON()).toList(),
      'keyword':this.keyword.map((e)=>e.toJSON()).toList()
    };
  }
}

class CollectionBookmark {
  int book;
  int chapter;
  // String verse;
  CollectionBookmark({this.book, this.chapter});

  factory CollectionBookmark.fromJSON(Map<String, dynamic> o) {
    return CollectionBookmark(
      book: o['book'] as int,
      chapter: o['chapter'] as int
    );
  }
  Map<String, dynamic> toJSON() {
    return {
      'book': this.book,
      'chapter': this.chapter
    };
  }
  Map<String, dynamic> toView(chapterName,bookName,testamentName) {
    return this.toJSON()..addAll({
      'book': book,
      'chapter': chapter,
      'chapterName': chapterName,
      'bookName': bookName,
      'testamentName': testamentName
    });
    // return {
    //   'book': book,
    //   'chapter': chapter,
    //   'bookName': bookName
    // };
  }
}

class CollectionKeyword {
  String word;
  CollectionKeyword({this.word});
  factory CollectionKeyword.fromJSON(String word) {
    return CollectionKeyword(
      word: word
    );
  }
  String toJSON() {
    return this.word;
  }
}

class CollectionBook<T> {
  final Key key;
  final String identify;
  final String name;
  final String shortname;
  final int year;
  final CollectionLanguage language;
  final String description;
  final int version;
  int available;
  int order;
  // Key(store.uniqueIdentify.toString())

  CollectionBook({this.key, this.identify, this.name, this.shortname, this.year, this.language, this.description, this.version, this.available,this.order});

  factory CollectionBook.fromJSON(Map<String, dynamic> o) {
    return CollectionBook(
      key: ValueKey(o['identify']),
      identify: o['identify'],
      name: o['name'],
      shortname: o['shortname'],
      year: int.parse(o['year'].toString()),
      language: CollectionLanguage.fromJSON(o['language']),
      description: o['description'],
      version: int.parse(o['version'].toString()),
      available: o['available']==null?0:o['available'] as int,
      order: o['order']==null?0:o['order'] as int
    );
  }
  Map<String, dynamic> toJSON() {
    return {
      'identify': this.identify,
      'name': this.name,
      'shortname': this.shortname,
      'year':this.year,
      'language':this.language.toJSON(),
      'description':this.description,
      'version':this.version,
      'available':this.available
    };
  }
  Map<String, dynamic> userSetting() {
    return {
      'available':this.available,
      'order':this.order
    };
  }
}

class CollectionLanguage {
  final String text;
  final String textdirection;
  final String name;
  CollectionLanguage({this.text, this.textdirection, this.name});

  factory CollectionLanguage.fromJSON(Map<String, dynamic> o) {
    return CollectionLanguage(
      text: o['text'],
      textdirection: o['textdirection'],
      name: o['name']
    );
  }
  Map<String, dynamic> toJSON() {
    return {
      'text': this.text,
      'textdirection': this.textdirection,
      'name': this.name
    };
  }
}

// BibleLanguage BibleBook, BibleDigit, BibleBookName, Bible BibleStory, BibleCommentary
class BIBLE {
  final CollectionBook info;
  final Map note;
  final Map language;
  final List digit;
  final Map testament;
  final Map story;
  final Map book;
  BIBLE({this.info, this.note, this.language, this.digit, this.testament, this.story, this.book});
  factory BIBLE.fromJSON(Map<String, dynamic> o) {
    return BIBLE(
      info: CollectionBook.fromJSON(o['info']),
      note: o['note'],
      language: o['language'],
      digit: o['digit'] as List,
      testament: o['testament'],
      story: o['story'],
      book: o['book']
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

class BOOK {
  bool type;
  int id;
  int itemCount;
  String name;
  String shortname;
  BOOK({this.id, this.type, this.name, this.itemCount, this.shortname});
}

class NAME {
  int testament;
  String testamentName;
  String testamentShortname;

  int book;
  String bookName;
  String bookShortname;

  // int chapterId;
  int chapterCount;
  NAME({this.testament,this.testamentName, this.testamentShortname, this.book, this.bookName, this.bookShortname,this.chapterCount});
}

// class CHAPTER {
//   String book;
//   String testament;
//   String chapter;
//   int chapterCount;
//   CHAPTER({this.book, this.testament, this.chapter,this.chapterCount});
// }

class VERSE {
  final String testament;
  final String book;
  final String chapter;
  final String verse;
  final String verseTitle;
  // final String verseReference;
  // final String verseMerge;
  final String verseText;
  bool selected=false;
  VERSE({this.testament, this.book, this.chapter, this.verse, this.verseText,this.verseTitle});
}