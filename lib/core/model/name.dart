// part of 'collection.dart';

class NAME {
  final String identify;
  final int testamentId;
  final String testamentName;
  final String testamentShortname;

  final int bookId;
  final String bookName;
  final String bookShortname;

  final int chapterCount;

  // NOTE: used in bookmark:view
  // int chapterId;
  // String chapterName;

  NAME({
    this.identify,
    this.testamentId,
    this.testamentName,
    this.testamentShortname,
    this.bookId,
    this.bookName,
    this.bookShortname,
    this.chapterCount,
    // this.chapterId,
    // this.chapterName,
  });

  // factory NAME.fromJSON(Map<String, dynamic> o) {
  //   return NAME(
  //     identify:o['identify'],
  //     testamentId:o['testamentId'],
  //     testamentName:o['testamentName'],
  //     testamentShortname:o['testamentShortname'],
  //     bookId:o['bookId'],
  //     bookName:o['bookName'],
  //     bookShortname:o['bookShortname'],
  //     chapterCount:o['chapterCount'],
  //     chapterId:o['chapterId'],
  //     chapterName:o['chapterName'],
  //   );
  // }

  // factory NAME.bookmark(int chapterId,String chapterName) {
  //   // this.chapterId = chapterId;
  //   // this.chapterName = chapterName;
  //   // return this;
  //    return NAME(

  //     testamentId:chapterId,
  //     chapterId:chapterId,
  //     chapterName:chapterName,
  //    );
  // }
}
