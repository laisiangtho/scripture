part of 'collection.dart';

class CollectionSetting {
  String identify;
  int bookId;
  int chapterId;
  int verseId;
  double fontSize;
  String searchQuery;

  CollectionSetting({
    this.identify:'',
    this.bookId:1,
    this.chapterId:1,
    this.verseId:1,
    this.fontSize:16.0,
    this.searchQuery:'',
  });

  factory CollectionSetting.fromJSON(Map<String, dynamic> o) {
    if (o == null) {
      return CollectionSetting();
    }
    return CollectionSetting(
      identify: o['identify'],
      bookId: o['bookId'] as int,
      chapterId: o['chapterId'] as int,
      verseId: o['verseId'] as int,
      fontSize: o['fontSize'] as double,
      searchQuery: o['searchQuery']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'identify': this.identify,
      'bookId': this.bookId,
      'chapterId': this.chapterId,
      'verseId': this.verseId,
      'fontSize': this.fontSize,
      'searchQuery': this.searchQuery
    };
  }

}
