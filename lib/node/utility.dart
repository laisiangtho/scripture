

// import 'configuration.dart';
// on StoreConfiguration
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
mixin Utility {
  static final FirebaseAnalytics _analytics = new FirebaseAnalytics();
  static final FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(analytics: _analytics);

  FirebaseAnalytics get analytics => _analytics;
  get observer => _observer;

  Future<void> analyticsShare(String contentType, String itemId) async {
    // await _analytics.logEvent(
    //   name: 'share',
    //   parameters: <String, dynamic>{
    //     'content_type': contentType,
    //     'item_id': itemId
    //   }
    // );
  }

  Future<void> analyticsContent(String contentType, String itemId) async {
    // await _analytics.logEvent(
    //   name: 'select_content',
    //   parameters: <String, dynamic>{
    //     'content_type': contentType,
    //     'item_id': itemId
    //   }
    // );
  }

  Future<void> analyticsBook(String bibleName, String bookName, String chapterId) async {
    // await _analytics.logEvent(
    //   name: 'select_book',
    //   parameters: <String, dynamic>{
    //     'content_name': bibleName,
    //     'book_name': bookName,
    //     'chapter_id': chapterId,
    //     // 'item_id': itemId
    //   }
    // );
  }

  Future<void> analyticsScreen(String name, String classes) async {
    // await new FirebaseAnalytics().setCurrentScreen(creenName: 'home',screenClassOverride: 'HomeState');
    // await _analytics.setCurrentScreen(screenName: name,screenClassOverride: classes);
    // print('analytics->screen $name $classes');
  }
  Future<void> analyticsSearch(String searchTerm) async {
    // await _analytics.logSearch(searchTerm:searchTerm);
    // print('analytics->search $searchTerm');
  }

  // Future<void> analyticsSetUserId() async {
  //   await new FirebaseAnalytics().setUserId('some-user');
  //   await this.analytics.then((FirebaseAnalytics e){
  //     e..setUserId('some-user');
  //   });
  // }

  // Future<Analytics> get googleAnalytics async{
  //   return appDirectory.then((FileSystemEntity e){
  //     return new AnalyticsIO(this.appAnalytics, join(e.path, 'analytics'), this.appVersion);
  //   });
  // }
}