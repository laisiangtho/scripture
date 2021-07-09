part of 'main.dart';

mixin _Utility {
  final UtilAnalytics utilAnalytics = new UtilAnalytics();

  Future<void> analyticsSearch(String searchTerm) async {
    // debugPrint('analyticsSearch $searchTerm');
    if (searchTerm.isNotEmpty) await utilAnalytics.send.logSearch(searchTerm:searchTerm);
  }

  Future<void> analyticsScreen(String name, String classes) async {
    // await new FirebaseAnalytics().setCurrentScreen(creenName: 'home',screenClassOverride: 'HomeState');
    // debugPrint('analyticsScreen $name $classes');
    await utilAnalytics.send.setCurrentScreen(screenName: name,screenClassOverride: classes);
  }

  // Future<void> analyticsShare(String contentType, String itemId) async {
  //   await utilAnalytics.send.logEvent(
  //     name: 'share',
  //     parameters: <String, dynamic>{
  //       'content_type': contentType,
  //       'item_id': itemId
  //     }
  //   );
  // }

  // Future<void> analyticsContent(String contentType, String itemId) async {
  //   // debugPrint('analyticsContent contentType:$contentType itemId: $itemId');
  //   await utilAnalytics.send.logEvent(
  //     name: 'select_content',
  //     parameters: <String, dynamic>{
  //       'content_type': contentType,
  //       'item_id': itemId
  //     }
  //   );
  // }

  Future<void> analyticsBook(String bibleName, String bookName, String chapterName) async {
    // debugPrint('analyticsBook $bibleName book:$bookName chapter: $chapterName');
    await utilAnalytics.send.logEvent(
      name: 'select_book',
      parameters: <String, dynamic>{
        'content_name': bibleName,
        'book_name': bookName,
        'chapter_id': chapterName,
        // 'item_id': itemId
      }
    );
  }
}