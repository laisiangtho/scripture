
part of 'main.dart';

// NOTE: adapter/bookmark.dart
@HiveType(typeId: 2)
class BookmarkType {
  @HiveField(0)
  String identify;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  int bookId;
  @HiveField(3)
  int chapterId;


  BookmarkType({
    this.identify:'',
    this.date,
    this.bookId:1,
    this.chapterId:1,
  });

  factory BookmarkType.fromJSON(Map<String, dynamic> o) {
    return BookmarkType(
      identify: o["identify"] as String,
      date: o["date"] as DateTime,
      bookId: o["book"] as int,
      chapterId: o["chapterId"] as int,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "identify":identify,
      "date":date,
      "bookId":bookId,
      "chapterId":chapterId
    };
  }
}
