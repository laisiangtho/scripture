// import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

Future<Response> requestHTTP(String url) async {
  return await Client().get(url);
}
Map<String, dynamic> decodeJSON(String response) {
  return json.decode(response);
}
String encodeJSON(Map response) {
  return json.encode(response);
}

Future<String> loadBundleAsString(String fileName) async {
  return await rootBundle.loadString(fileName);
}
Future<FileSystemEntity> get appDirectory async {
  return await getApplicationDocumentsDirectory();
}
Future<File> documents(String fileName) async {
  FileSystemEntity directory = await appDirectory;
  return new File(join(directory.path, fileName));
}
Future<File> docsWrite(String fileName,String fileContext) async {
  return await documents(fileName).then((File e) async => await e.writeAsString(fileContext));
  // return await this.docs(fileName).then((File e) async => await e.writeAsString(json.encode(fileContext)));
}
Future<String> docsRead(String fileName) async {
  return await documents(fileName).then((File e) async => await e.readAsString());
  // return await this.docs(fileName).then((File e) async => json.decode(await e.readAsString()));
}
Future<FileSystemEntity> docsDelete(String fileName) async {
  return await documents(fileName).then((File e) async => await e.delete());
}
Future<bool> docsExists(String fileName) async {
  return await documents(fileName).then((File e) async => await e.exists());
}

abstract class StoreConfiguration {
  final String appName = 'laisiangtho';
  final String appTitle = 'Lai Siangtho';
  final String appDescription = 'the Holy Bible in languages';

  String identify ='';
  String searchQuery ='';

  int testamentId = 1;
  // String testamentName;
  int bookId = 1;
  // String bookName;
  int chapterId = 1;
  int chapterCount;
  int verseId = 1;
  int verseCount;
  double offset=0.0;

  bool showSheet = false;

}