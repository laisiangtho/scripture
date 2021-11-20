part of 'main.dart';

mixin _Configuration {
  final Collection collection = Collection.internal();
  // late void Function({int at, String? to, Object? args, bool routePush}) navigate;

  late Scripture scripturePrimary;
  late Scripture scriptureParallel;

  late Store store;
  // late SQLite _sql;
  // late Audio audio;
}

DefinitionBible parseDefinitionBibleCompute(String response) {
  Map<String, dynamic> parsed = UtilDocument.decodeJSON(response);
  return DefinitionBible.fromJSON(parsed);
}
