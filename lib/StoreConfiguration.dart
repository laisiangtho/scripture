// import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';

import 'StoreModel.dart';

BIBLE computeParseBible(String response){
  Map<String, dynamic> parsed = decodeJSON(response);
  return BIBLE.fromJSON(parsed);
}

Future<Response> requestHTTP(String url) async => await Client().get(url);
Map<String, dynamic> decodeJSON(String response)  => json.decode(response);
String encodeJSON(Map response) => json.encode(response);
Future<String> loadBundleAsString(String fileName) async => await rootBundle.loadString(fileName);
Future<FileSystemEntity> get appDirectory async => await getApplicationDocumentsDirectory();

Future<File> documents(String fileName) async {
  FileSystemEntity directory = await appDirectory;
  return new File(join(directory.path, fileName));
}
Future<File> docsWrite(String fileName,String fileContext) async => await documents(fileName).then((File e) async => await e.writeAsString(fileContext));
Future<String> docsRead(String fileName) async => await documents(fileName).then((File e) async => await e.readAsString());
Future<FileSystemEntity> docsDelete(String fileName) async => await documents(fileName).then((File e) async => await e.delete());
Future<bool> docsExists(String fileName) async => await documents(fileName).then((File e) async => await e.exists());


abstract class StoreConfiguration {
  final String appName = 'laisiangtho';
  final String appTitle = 'Lai Siangtho';
  final String appDescription = 'the Holy Bible in languages';

  String identify ='';
  String searchQuery ='';
  String suggestQuery ='';

  int testamentId = 1;
  int bookId = 1;
  int chapterId = 1;
  int chapterCount;
  int verseId = 1;
  int verseCount;
  double offset=0.0;
  bool bottomSheetShow=false;

  var contextMedia;
  double bottomBarHeight=55.0;


  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  PageController pageController = new PageController();
  FocusNode focusNode = new FocusNode();

  // GlobalKey keyBottomBar = new GlobalKey();
  // GlobalKey keyNavigation = new GlobalKey();
  // var keyNavigation;


  double get contentBottomPadding => this.focusNode.hasFocus?0.0:(this.bottomBarHeight + this.contextMedia.padding.bottom).toDouble();
  int get uniqueIdentify => new DateTime.now().millisecondsSinceEpoch;
}