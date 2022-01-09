export "package:lidea/type/main.dart";
// import "package:lidea/type/main.dart";

import "package:lidea/hive.dart";
// import "package:lidea/unit/notify.dart";
import "package:lidea/cluster/docket.dart";

part "audio.dart";
part "collection.dart";

part "bible.dart";
part "book.dart";
part "adapter/book.dart";
part "bookmark.dart";
part "adapter/bookmark.dart";

/// tmp
class UserDataType {
  int version;
  int size;
  List<int> playlist;
  List<String> keywords;

  UserDataType({
    required this.version,
    required this.size,
    required this.playlist,
    required this.keywords,
  });

  factory UserDataType.fromJSON(Map<String, dynamic> o) {
    return UserDataType(
      version: int.parse((o["version"] ?? 0)),
      size: int.parse((o["size"] ?? 0)),
      playlist: List.from(o['playlist'] ?? []).map<int>((e) => int.parse(e)).toList(),
      keywords: List.from(o['keywords'] ?? []).map<String>((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "version": version,
      "size": size,
      "playlist": playlist,
      "keywords": keywords,
    };
  }
}
