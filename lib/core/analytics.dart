part of data.core;

class Analytics extends UnitAnalytics {
  @override
  Future<void> search(String searchTerm) async {
    super.search(searchTerm);
    debugPrint('search $searchTerm');
  }

  @override
  Future<void> screen(String screenName, String screenClass) async {
    super.screen(screenName, screenClass);
    debugPrint('screen $screenName $screenClass');
  }
}
