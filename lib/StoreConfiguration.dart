// import 'dart:async';
// import 'dart:convert';
import 'dart:io';
// import 'package:path/path.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

abstract class StoreConfiguration {
  final String appName = 'laisiangtho';
  final String appTitle = 'Lai Siangtho';
  final String appDescription = 'the Holy Bible in languages';

  String identify;

  int testamentId = 1;
  int bookId = 1;
  int chapterId = 1;
  int chapterCount;
  int verseId = 1;
  int verseCount;

  int testCounter = 1;
  String appMessage = 'Hello World';

  Future get appDirectory async {
    return await getApplicationDocumentsDirectory();
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
  }
  Future<File> appFile(String filename) async {
    final directory = await appDirectory;
    // String filename = basename(this._url);
    return new File('${directory.path}/$filename');
  }
  Future<String> appBundle(String filename) async {
    return await rootBundle.loadString(filename);
  }
  Future requestHTTP(String url) async {
    // final response = await http.Client().get(this._url);
    // return json.decode(response.body);
    return await http.Client().get(url);
  }
}