// import 'dart:async';
import 'dart:convert';
// import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';

// import 'StoreModel.dart';

// BIBLE computeParseBible(String response){
//   Map<String, dynamic> parsed = decodeJSON(response);
//   return BIBLE.fromJSON(parsed);
// }

import 'model/collection.dart';


Collection computeParseCollection(dynamic response) {
  Map<String, dynamic> parsed = (response is String)?decodeJSON(response):response;
  return Collection.fromJSON(parsed)..book.sort((a, b) => a.order.compareTo(b.order));
}

BIBLE computeParseBible(String response){
  Map<String, dynamic> parsed = decodeJSON(response);
  return BIBLE.fromJSON(parsed);
}

Future<Response> requestHTTP(String url) async => await Client().get(url);
Map<String, dynamic> decodeJSON(String response)  => json.decode(response);
String encodeJSON(Map response) => json.encode(response);
Future<String> loadBundleAsString(String fileName) async => await rootBundle.loadString(fileName);
// Future<directory> get appDirectory async => await getApplicationDocumentsDirectory();
Future<Directory> get appDirectory => getApplicationDocumentsDirectory();


Future<File> documents(String fileName) async {
  FileSystemEntity directory = await appDirectory;
  // new File(join(await appDirectory.path, fileName));
  return new File(join(directory.path, fileName));
}
Future<File> docsWrite(String fileName,String fileContext) async => await documents(fileName).then((File e) async => await e.writeAsString(fileContext));
Future<String> docsRead(String fileName) async => await documents(fileName).then((File e) async => await e.readAsString());
Future<FileSystemEntity> docsDelete(String fileName) async => await documents(fileName).then((File e) async => await e.delete());
Future<bool> docsExists(String fileName) async => await documents(fileName).then((File e) async => await e.exists());

abstract class Configuration {
  final String appName = 'laisiangtho';
  final String appTitle = 'Lai Siangtho';
  final String appVersion = '1.0.1+35';
  final String appDescription = 'the Holy Bible in languages';
  final String appAnalytics = 'UA-18644721-1';

  // collection currentBible, userBible
  Collection collection;

  String identify ='';
  String searchQuery ='';
  String suggestQuery ='';

  int testamentId = 1;
  String testamentName = '';
  int bookId = 1;
  String bookName = '';
  int chapterId = 1;
  int chapterCount;
  int verseId = 1;
  int verseCount;
  double scrollOffset=0.0;
  bool bottomSheetShow=false;

  bool isReady = false;
  String message = 'Getting ready';

  var contextMedia;
  double bottomBarHeight=55.0;

  String assetsBookJSON = 'assets/book.json';

  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // ScrollController scrollController = ScrollController(initialScrollOffset:0,keepScrollOffset:true);
  // PageController pageController = new PageController(initialPage: 0, keepPage: false,);
  final FocusNode focusNode = new FocusNode();

  final MaterialColor colorPrimarySwatch = MaterialColor(
      0xFFFFFFFF,
      <int, Color>{
        10: Color(0xFFFFFFFF),
        50: Color(0xFFFAFAFA),
        100: Color(0xFFF5F5F5),
        200: Color(0xFFEEEEEE),
        300: Color(0xFFE0E0E0),
        400: Color(0xFFD6D6D6), // only for raised button while pressed in light theme
        500: Color(0xFFBDBDBD),
        600: Color(0xFF757575),
        700: Color(0xFF616161),
        800: Color(0xFF424242),
        850: Color(0xFF303030), // only for background color in dark theme
        900: Color(0xFF212121)
      },
    );

  // GlobalKey keyBottomBar = new GlobalKey();
  // GlobalKey keyNavigation = new GlobalKey();
  // var keyNavigation;


  double get contentBottomPadding => this.focusNode.hasFocus?0.0:(this.bottomBarHeight + this.contextMedia.padding.bottom).toDouble();
  int get uniqueIdentify => new DateTime.now().millisecondsSinceEpoch;

  Future<Collection> parseCollection(dynamic response) async => collection = await compute(computeParseCollection,response);

  Map<int,double> offset ={};

}