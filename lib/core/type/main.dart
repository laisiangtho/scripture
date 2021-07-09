// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';
// import 'package:flutter/widgets.dart';
import "package:hive/hive.dart";
import "package:lidea/extension.dart";

// NOTE: typeId: 0
part 'adapter/setting.dart';
// NOTE: typeId: 1
part 'adapter/history.dart';
// NOTE: typeId: 2
part 'adapter/bookmark.dart';
// NOTE: typeId: 7
part 'adapter/purchase.dart';
// NOTE: typeId: 9
part 'adapter/book.dart';

part 'setting.dart';
part 'history.dart';
part 'bookmark.dart';
part 'purchase.dart';
part 'book.dart';
part 'bible.dart';
part "collection.dart";

// NOTE: only type
class EnvironmentType {
  String name;
  String description;
  String package;
  String version;
  String buildNumber;

  String settingName;
  String settingKey;
  SettingType setting;

  TokenType token;

  List<ProductsType> products;
  List<APIType> apis;
  List<BookType> books;

  EnvironmentType({
    required this.name,
    required this.description,
    required this.package,
    required this.version,
    required this.buildNumber,
    required this.settingName,
    required this.settingKey,
    required this.setting,

    required this.token,
    required this.products,
    required this.apis,
    required this.books,
  });

  factory EnvironmentType.fromJSON(Map<String, dynamic> o) {
    return EnvironmentType(
      name: o["name"]??"MyOrdbok",
      description: o["description"]??"A comprehensive Myanmar online dictionary",
      package: o["package"]??"",
      version: o["version"]??"1.0.0",
      buildNumber: o["buildNumber"]??"0",
      settingName: o["settingName"]??"0",
      settingKey: o["settingKey"]??"0",
      setting: SettingType.fromJSON(o["setting"]),
      token: TokenType.fromJSON(o["token"]),
      products: o['products'].map<ProductsType>((e) => ProductsType.fromJSON(e)).toList(),
      apis: o['api'].map<APIType>((e) => APIType.fromJSON(e)).toList(),
      books: o['book'].map<BookType>((e) => BookType.fromJSON(e)).toList()
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "name":name,
      "description":description,
      "package":package,
      "version":version,
      "buildNumber":buildNumber,
      "settingName":settingName,
      "settingKey":settingKey,
      "setting":setting.toString(),
      "token":token.toString(),
      "products":products.map((e)=>e.toJSON()).toList(),
      "apis":apis.map((e)=>e.toJSON()).toList(),
      "books":books.map((e)=>e.toJSON()).toList()
    };
  }

  // bookAPI
  APIType get bookAPI => apis.firstWhere((e) => e.uid == 'book');
  APIType get bibleAPI => apis.firstWhere((e) => e.uid == 'bible');

  // APIType get sense => this.api.firstWhere((e) => e.uid == 'sense',orElse: () => null);
  // APIType get derive => this.api.firstWhere((e) => e.uid == 'derive',orElse: () => null);
  // APIType get thesaurus => this.api.firstWhere((e) => e.uid == 'thesaurus',orElse: () => null);

  /// Every database
  // Iterable<APIType> get listOfDatabase => this.api.where((e) => e.src.length > 0);
  // /// Every table
  // // Iterable<APIType> get listOfTable => this.api.where((e) => e.table.isNotEmpty);

  // /// the primary database and table
  // // APIType get primary => this.api.firstWhere((e) => e.isMain, orElse: () => null!);
  // APIType get primary => this.api.firstWhere((e) => e.isMain);
  // /// the primary database and it table except primary table
  // Iterable<APIType> get children => this.api.where((e) => e.isChild);
  // /// Other database to attached
  // Iterable<APIType> get secondary => this.api.where((e) => e.isAttach);

  // SynsetType grammar(int id) => this.synset.firstWhere((e) => e.id == id);
  // SynmapType pos(int id) => this.synmap.firstWhere((e) => e.id == id);
}

// NOTE: only type, EnvironmentType child
class TokenType {
  String key;
  String id;

  TokenType({
    required this.key,
    required this.id
  });

  factory TokenType.fromJSON(Map<String, dynamic> o) {
    return TokenType(
      key: o["key"].toString().bracketsHack(),
      id: o["id"].toString().bracketsHack()
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "key":key,
      "id":id
    };
  }

}

// NOTE: only type, EnvironmentType child
// class HistoryType {
//   int id;
//   String word;

//   HistoryType({
//     required this.id,
//     required this.word
//   });

//   factory HistoryType.fromJSON(Map<String, dynamic> o) {
//     return HistoryType(
//       id: o["id"] as int,
//       word: o["word"] as String
//     );
//   }

//   Map<String, dynamic> toJSON() {
//     return {
//       "id":id,
//       "word":word
//     };
//   }
// }

// NOTE: only type, EnvironmentType child
class ProductsType {
  String cart;
  String name;
  String type;
  String title;
  String description;

  ProductsType({
    required this.cart,
    required this.name,
    required this.type,
    required this.title,
    required this.description,
  });

  factory ProductsType.fromJSON(Map<String, dynamic> o) {
    return ProductsType(
      cart: o["cart"] as String,
      name: o["name"] as String,
      type: o["type"] as String,
      title: o["title"] as String,
      description: o["description"] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "cart":cart,
      "name":name,
      "type":type,
      "title":type,
      "description":type,
    };
  }
}

// NOTE: only type, EnvironmentType child
class APIType {
  String uid;
  List<String> src;

  APIType({
    required this.uid,
    required this.src
  });

  factory APIType.fromJSON(Map<String, dynamic> o) {
    return APIType(
      uid: o["uid"] as String,
      // NOTE: .split('').reverse().join('')
      src: List.from(
        (o['src']??[]).map<String>(
          (e) => e.toString().gitHack()
        )
      )
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "uid":uid,
      "src":src.toList()
    };
  }

  // String get file => '$uid.json';
  String get url => src.where((e) => Uri.parse(e).isAbsolute).first;
  String get file => src.where((e) => Uri.parse(e).isAbsolute == false).first;
  String get archive => file.replaceFirst('?', uid);
  // String get fileName => basename(this.url);
}

// NOTE: only type, EnvironmentType child
// class APIType {
//   String uid;
//   String table;
//   int kind;
//   Map<dynamic, String> query;
//   List<String> src;

//   APIType({
//     required this.uid,
//     required this.table,
//     required this.kind,
//     required this.query,
//     required this.src
//   });
//   // map<K2, V2>((K, V) => MapEntry<K2, V2>) => Map<K2, V2>)

//   factory APIType.fromJSON(Map<String, dynamic> o) {
//     return APIType(
//       uid: o["uid"] as String,
//       table: (o["table"]??'').toString(),
//       kind: (o['kind']??0) as int,
//       query: (o['query']??{}).map<dynamic, String>(
//         (k, v) => MapEntry(k, v.toString())
//       ),
//       // query: (o['query']??{}).map<dynamic, String>(
//       //   (k, v) => MapEntry(k, v.toString().replaceFirst('??', _tableName))
//       // ),
//       // NOTE: .split('').reverse().join('')
//       src: List.from(
//         (o['src']??[]).map<String>(
//           (e) => e.toString().gitHack()
//         )
//       )
//       // child: List.from((o['child']??[]).map<APIType>((e) => APIType.fromJSON(e)))
//     );
//   }

//   Map<String, dynamic> toJSON() {
//     return {
//       "uid":uid,
//       "table":table,
//       "kind":kind,
//       "query":query,
//       "src":src.toList(),
//       // "child":child.map((e)=>e.toJSON()).toList()
//     };
//   }

//   String get db => '$uid.db';

//   // isMain == true is also built-in as bundle
//   bool get isMain => kind == 1 && src.length > 0;
//   bool get isChild => kind == 1 && src.length == 0;
//   bool get isAttach => kind == 0 && src.length > 0;

//   Iterable<MapEntry<dynamic, String>> get listQuery => query.entries;

//   // Table name alias
//   String get tableName => isAttach?'$uid.$table':table;
//   // String get createIndex => listQuery.firstWhere((e) => e.key == 'createIndex',orElse: () => null)?.value?.replaceFirst('??', tableName);
//   String? get createIndex {
//     final val = listQuery.firstWhere((e) => e.key == 'createIndex');

//     if (val.value.isNotEmpty) {
//       return val.value.replaceAll('?!', tableName).replaceAll('#', uid).replaceAll('??', table);
//     }
//     return null;
//   }
// }

// NOTE: only type, EnvironmentType child
// class SynsetType {
//   final int id;
//   final String name;
//   final String shortname;
//   SynsetType({required this.id, required this.name, required this.shortname});

//   factory SynsetType.fromJSON(Map<String, dynamic> o) {
//     return SynsetType(
//       id: o["id"] as int,
//       name: o["name"] as String,
//       shortname: (o["shortname"]??'') as String
//     );
//   }

//   Map<String, dynamic> toJSON() {
//     return {
//       "id": id,
//       "name": name,
//       "shortname": shortname
//     };
//   }
// }

// NOTE: only type, EnvironmentType child
// class SynmapType {
//   final int id;
//   final int type;
//   final String name;
//   SynmapType({required this.id, required this.type, required this.name});

//   factory SynmapType.fromJSON(Map<String, dynamic> o) {
//     return SynmapType(
//       id: o["id"] as int,
//       type: o["type"] as int,
//       name: o["name"] as String
//     );
//   }

//   Map<String, dynamic> toJSON() {
//     return {
//       "id": id,
//       "type": type,
//       "name": name
//     };
//   }
// }
