
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

/// setup `FirebaseAnalytics`
///
/// Firebase Analytics API.
class UtilAnalytics {
  static final FirebaseAnalytics _analytics = new FirebaseAnalytics();
  static final FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(analytics: _analytics);

  FirebaseAnalytics get send => _analytics;
  get observer => _observer;

  Future<void> search(String searchTerm) async {
    if (searchTerm.isNotEmpty) await _analytics.logSearch(searchTerm:searchTerm);
  }

  Future<void> share(String contentType, String itemId) async {
    await _analytics.logEvent(
      name: 'share',
      parameters: <String, dynamic>{
        'content_type': contentType,
        'item_id': itemId
      }
    );
  }

  Future<void> content(String contentType, String itemId) async {
    // print('analyticsContent contentType:$contentType itemId: $itemId');
    await _analytics.logEvent(
      name: 'select_content',
      parameters: <String, dynamic>{
        'content_type': contentType,
        'item_id': itemId
      }
    );
  }

  Future<void> book(String bibleName, String bookName, String chapterId) async {
    await _analytics.logEvent(
      name: 'select_book',
      parameters: <String, dynamic>{
        'content_name': bibleName,
        'book_name': bookName,
        'chapter_id': chapterId,
        // 'item_id': itemId
      }
    );
  }

  Future<void> screen(String name, String classes) async {
    // await new FirebaseAnalytics().setCurrentScreen(creenName: 'home',screenClassOverride: 'HomeState');
    // print('analyticsScreen $name $classes');
    await _analytics.setCurrentScreen(screenName: name,screenClassOverride: classes);
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