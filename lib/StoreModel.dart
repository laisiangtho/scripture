class ModelBible<T> {
  final String identify;
  final String name;
  final String shortname;
  final int year;
  final String lang;
  final String desc;
  final int version;
  int available;
  //NOTE identify TEXT PRIMARY KEY, name TEXT, shortname TEXT, year INTEGER, lang TEXT, desc TEXT, version INTEGER, available INTEGER

  ModelBible({this.identify, this.name, this.shortname, this.year, this.lang, this.desc, this.version, this.available});

  factory ModelBible.fromJSON(Map<String, dynamic> o) {
    return ModelBible(
      identify: o['identify'],
      name: o['name'],
      shortname: o['shortname'],
      year: int.parse(o['year']),
      lang: o['language']['name'],
      desc: o['description'],
      version: int.parse(o['version']),
      available: o['available']==null?0:o['available'] as int
    );
  }

  factory ModelBible.fromDatabase(Map<String, dynamic> o) {
    return ModelBible(
      identify: o['identify'] as String,
      name: o['name'] as String,
      shortname: o['shortname'] as String,
      year: o['year'] as int,
      lang: o['lang'] as String,
      desc: o['desc'] as String,
      version: o['version'] as int,
      available: o['available'] as int
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'available':this.available
    };
  }
  Map<String, dynamic> toDatabase() {
    return {
      'identify': this.identify,
      'name': this.name,
      'shortname': this.shortname,
      'year':this.year,
      'lang':this.lang,
      'desc':this.desc,
      'version':this.version,
      'available':this.available
    };
  }
}

class ModelBook {
  bool type;
  int id;
  int itemCount;
  String name;
  String shortname;
  ModelBook({this.id, this.type, this.name, this.itemCount, this.shortname});
}
class ModelChapter {
  String book;
  String testament;
  String chapter;
  int chapterCount;
  ModelChapter({this.book, this.testament, this.chapter,this.chapterCount});
}
// class ModelBookInfo {
//   String book;
//   String testament;
//   String chapter;
//   int chapterCount;
//   ModelBookInfo({this.book, this.testament, this.chapter,this.chapterCount});
// }
class ModelVerse {
  String testament;
  String book;
  String chapter;
  String verse;
  String verseTitle;
  String verseReference;
  String verseMerge;
  String verseText;
  ModelVerse({this.testament, this.book, this.chapter, this.verse, this.verseText,this.verseTitle});
}
