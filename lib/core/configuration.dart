part of 'core.dart';

mixin _Configuration  {
  String appName = 'Lai Siangtho';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  final String appDescription = 'the Holy Bible in languages';

  // final String appAnalytics = 'UA-18644721-1';
  final String assetsFolder = 'assets';
  final String assetsCollection = 'book.json';
  // final String assetsCollection = 'collection.json';
  final String _liveBookJSON = 'nosj.koob/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth';
  final initProgress = ValueNotifier<double>(0.0);

  final keyBookmarkList = GlobalKey<SliverAnimatedListState>();

  Collection collection;

  DefinitionBible userBible;
  List<DefinitionBible> userBibleList = [];

  String get identify => collection.setting.identify;
  set identify(String id) => collection.setting.identify = id;
  int get bookId => collection.setting.bookId;
  set bookId(int id) => collection.setting.bookId = id;
  int get chapterId => collection.setting.chapterId;
  set chapterId(int id) => collection.setting.chapterId = id;
  double get fontSize => collection.setting.fontSize;
  set fontSize(double id) => collection.setting.fontSize = id;

  String get searchQuery => collection.setting.searchQuery??'';
  set searchQuery(String searchQuery) => collection.setting.searchQuery = searchQuery;

  // int get uniqueIdentify => new DateTime.now().millisecondsSinceEpoch;
}