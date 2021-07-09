part of 'main.dart';

mixin _Configuration  {
  final Collection collection = Collection.internal();

  // late SQLite _sql;
  // late Store store;

  // late List<Map<String, Object?>> suggestionList = [];
  // late List<Map<String, Object?>> definitionList = [];

  late Scripture scripturePrimary;
  late Scripture scriptureParallel;

  // // primaryId, parallelId
  // String get primaryId => collection.setting.identify;
  // set primaryId(String id) => collection.setting.identify = id;

  // String get parallelId => collection.setting.parallel;
  // set parallelId(String id) => collection.setting.parallel = id;

  // int get testamentId => this.bookId > 39?2:1;

  // int get bookId => collection.setting.bookId;
  // set bookId(int id) => collection.setting.bookId = id;
  // int get chapterId => collection.setting.chapterId;
  // set chapterId(int id) => collection.setting.chapterId = id;
  // double get fontSize => collection.setting.fontSize;
  // set fontSize(double id) => collection.setting.fontSize = id;

  // String get searchQuery => collection.setting.searchQuery;
  // set searchQuery(String searchQuery) => collection.setting.searchQuery = searchQuery;

  /// convert (Int or Number of String), chapterId, verseId into it's written language
  // String digit(dynamic e) => (e is String?e:e.toString()).replaceAllMapped(
  //   new RegExp(r'[0-9]'), (i) => userBiblePrimary == null?i.group(0):userBiblePrimary.digit[int.parse(i.group(0))]
  // );
  // String digit(dynamic e) => scripturePrimary.digit(e);
  // int get uniqueIdentify => new DateTime.now().millisecondsSinceEpoch;

}

// Collection parseCollectionCompute(dynamic response) {
//   Map<String, dynamic> parsed = (response is String)?UtilDocument.decodeJSON(response):response;
//   return Collection.fromJSON(parsed)..bible.sort(
//     (a, b) => a.order.compareTo(b.order)
//   );
// }

DefinitionBible parseDefinitionBibleCompute(String response){
  Map<String, dynamic> parsed = UtilDocument.decodeJSON(response);
  return DefinitionBible.fromJSON(parsed);
}
