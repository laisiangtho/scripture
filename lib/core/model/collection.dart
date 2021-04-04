// import 'package:flutter/material.dart';
part 'bible.dart';
part 'setting.dart';

// NOTE: BibleLanguage BibleBook, BibleDigit, BibleBookName, Bible BibleStory, BibleCommentary
class Collection {
  final int version;
  final CollectionSetting setting;
  final List<CollectionKeyword> keyword;
  final List<CollectionBible> bible;
  final List<CollectionBookmark> bookmark;

  Collection({
    this.version,
    this.setting,
    this.keyword,
    this.bible,
    this.bookmark
  });

  factory Collection.fromJSON(Map<String, dynamic> o) {
    // NOTE: change of collection bible model
    return Collection(
      version: o['version'] as int,
      setting: CollectionSetting.fromJSON(o['setting']),
      keyword: o['keyword'].map<CollectionKeyword>((json) => CollectionKeyword.fromJSON(json)).toList(),
      // bible: o['bible'].map<CollectionBible>((json) => CollectionBible.fromJSON(json)).toList(),
      bible: (o['bible']??o['book']).map<CollectionBible>((json) => CollectionBible.fromJSON(json)).toList(),
      bookmark: o['bookmark'].map<CollectionBookmark>((json) => CollectionBookmark.fromJSON(json)).toList(),
    );
  }

  Map<String, dynamic> toJSON() {
    // List bible = _collectionBook.map((e)=>e.toJSON()).toList();
    return {
      'version':this.version,
      'setting':this.setting.toJSON(),
      'keyword':this.keyword.map((e)=>e.toJSON()).toList(),
      'bible':this.bible.map((e)=>e.toJSON()).toList(),
      'bookmark':this.bookmark.map((e)=>e.toJSON()).toList()
    };
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

class CollectionBookmark {
  int bookId;
  int chapterId;
  CollectionBookmark({this.bookId, this.chapterId});

  factory CollectionBookmark.fromJSON(Map<String, dynamic> o) {
    // NOTE: book and chapter property from previous version
    return CollectionBookmark(
      bookId: o['bookId']??o['book'] as int,
      chapterId: o['chapterId']??o['chapter'] as int
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'bookId': this.bookId,
      'chapterId': this.chapterId
    };
  }

}

// class CollectionBible<T> {
class CollectionBible {
  final String identify;
  final String name;
  final String shortname;
  final int year;
  final CollectionLanguage language;
  final String description;
  final int version;
  int available;
  int order;
  // NOTE: used in DefinitionBible
  final String publisher;
  final String contributors;
  final String copyright;

  CollectionBible({
    this.identify,
    this.name,
    this.shortname,
    this.year,
    this.language,
    this.description,
    this.publisher,
    this.contributors,
    this.copyright,
    this.version,
    this.available,
    this.order
  });

  factory CollectionBible.fromJSON(Map<String, dynamic> o) {

    String stringProperty(String key){
      // NOTE: required for some of the previous version
      if (o.containsKey(key)){
        if (o[key] is String){
          return o[key];
        } else if (o[key] is Map && o[key].containsKey('text')){
          return o[key]['text'];
        }
      }
      return '';
    }

    int intProperty(String key){
      // NOTE: required for some of the previous version
      if (o.containsKey(key)){
        if (o[key] is String){
          return int.parse(o[key]);
        } else {
          return int.parse(o[key].toString());
        }
      }
      return 0;
    }

    return CollectionBible(
      identify: o['identify'],
      name: o['name'],
      shortname: o['shortname'],
      // year: int.parse(o['year'].toString()),
      language: CollectionLanguage.fromJSON(o['language']),
      description: o['description'],
      publisher: stringProperty('publisher'),
      contributors: stringProperty('contributors'),
      copyright: stringProperty('copyright'),
      // version: int.parse(o['version'].toString()),
      // available: o['available']==null?0:o['available'] as int,
      // order: o['order']==null?0:o['order'] as int
      year: intProperty('year'),
      version: intProperty('version'),
      available: intProperty('available'),
      order: intProperty('order')
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
      'publisher':this.publisher,
      'contributors':this.contributors,
      'copyright':this.copyright,
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
