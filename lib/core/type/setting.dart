
part of 'main.dart';

// NOTE: adapter/setting.dart
@HiveType(typeId: 0)
class SettingType {
  @HiveField(0)
  int version;
  // 0 = system 1 = light 2 = dark
  @HiveField(1)
  int mode;
  @HiveField(2)
  double fontSize;
  @HiveField(3)
  String searchQuery;

  @HiveField(4)
  String identify;
  @HiveField(5)
  int bookId;
  @HiveField(6)
  int chapterId;
  @HiveField(7)
  int verseId;

  @HiveField(8)
  String parallel;

  SettingType({
    this.version:0,
    this.mode:0,
    this.fontSize:24.0,
    this.searchQuery:"",

    this.identify:"",
    this.bookId: 1,
    this.chapterId: 1,
    this.verseId: 1,
    this.parallel:""
  });

  factory SettingType.fromJSON(Map<String, dynamic> o) {
    return SettingType(
      version: o["version"] as int,
      mode: o["mode"] as int,
      fontSize: o["fontSize"] as double,
      searchQuery: o["searchQuery"] as String,

      identify: o["identify"] as String,
      bookId: o["bookId"] as int,
      chapterId: o["chapterId"] as int,
      verseId: o["verseId"] as int,
      parallel: o["parallel"] as String,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "version":version,
      "mode":mode,
      "fontSize":fontSize,
      "searchQuery":searchQuery,

      "identify":identify,
      "bookId":bookId,
      "chapterId":chapterId,
      "verseId":verseId,
      "parallel":parallel
    };
  }

  SettingType merge(SettingType o) {
    return SettingType(
      version: o.version,
      mode: o.mode,
      fontSize: o.fontSize,
      searchQuery: o.searchQuery,

      identify: o.identify,
      bookId: o.bookId,
      chapterId: o.chapterId,
      verseId: o.verseId,
      parallel: o.parallel
    );
  }

  SettingType copyWith({
    int? version,
    int? mode,
    double? fontSize,
    String? searchQuery,

    String? identify,
    int? bookId,
    int? chapterId,
    int? verseId,
    String? parallel
  }) {
    return SettingType(
      version: version??this.version,
      mode: mode??this.mode,
      fontSize: fontSize??this.fontSize,
      searchQuery: searchQuery??this.searchQuery,

      identify: identify??this.identify,
      bookId: bookId??this.bookId,
      chapterId: chapterId??this.chapterId,
      verseId: verseId??this.verseId,
      parallel: parallel??this.parallel
    );
  }
}
