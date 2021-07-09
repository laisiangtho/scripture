part of 'main.dart';

/// check
mixin _Mock on _Abstract {

  Future<String> mockTest() async {
    return '???';
  }

  /// init scripturePrimary and seed analytics
  Future<void> get primaryInit => scripturePrimary.init().then((o){
    analyticsBook('${o.info.name} (${o.info.shortname})', scripturePrimary.bookName, scripturePrimary.chapterName);
  }).catchError((e){
    throw e;
  });

  Future<void> get chapterPrevious => primaryInit.then((_){
    return scripturePrimary.chapterPrevious();
  }).catchError((e){
    debugPrint('10: $e');
  }).whenComplete(() {
    notify();
  });

  Future<void> get chapterNext => primaryInit.then((_){
    return scripturePrimary.chapterNext();
  }).catchError((e){
    debugPrint('10: $e');
  }).whenComplete(() {
    notify();
  });

  Future<void> chapterChange({int? bookId, int? chapterId}) => primaryInit.then((_){
    return scripturePrimary.chapterBook(bId:bookId, cId:chapterId);
  }).catchError((e){
    debugPrint('10: $e');
  }).whenComplete(() {
    notify();
  });

}
