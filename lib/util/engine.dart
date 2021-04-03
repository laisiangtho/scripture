import 'dart:convert' show json;
import 'dart:io' show Directory, File, FileSystemEntity;
// import 'dart:async';
// import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' show join, basename;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart' show rootBundle;

class UtilDocument {
  /// getApplicationDocumentsDirectory `Future<Directory> get directory async => await getApplicationDocumentsDirectory();`
  static Future<Directory> get directory => getApplicationDocumentsDirectory();

  static Future<File> file(String fileName) async => new File(
    join(await directory.then((e) => e.path), fileName)
  );

  static Future<String> loadBundleAsString(String fileName) => rootBundle.loadString(fileName);

  static Future<File> writeAsString(String fileName, String fileContext) async => await file(fileName).then(
    (File e) async => await e.writeAsString(fileContext)
  );

  static Future<String> readAsString(String fileName) async => await file(fileName).then(
    (File e) async => await e.readAsString()
  );

  static Future<FileSystemEntity> delete(String fileName) async => await file(fileName).then(
    (File e) async => await e.delete()
  );

  /// NOTE: if exist return path basename,if not NULL
  static Future<String> exists(String fileName) async => await file(fileName).then(
    (File e) async => await e.exists()?basename(fileName):''
  );
  // Future<bool> docsExists(String fileName) async => await documents(fileName).then(
  //   (File e) async => await e.exists()
  // );

  /// JSON to Map
  static Map<String, dynamic> decodeJSON(String response)  => json.decode(response);

  /// Map to JSON
  static String encodeJSON(Map<String, dynamic> response) => json.encode(response);
}

class UtilClient {
  /// Request data over HTTP using get `...requestData(url).then().catchError()`
  static Future<String> request(String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      // return await http.read(url);
      if (response.statusCode == 200){
        return response.body;
      } else {
        return Future.error("Failed to load, code: ${response?.statusCode}");
      }
    } catch (e) {
      // print(e.message);
      return Future.error("No Internet", StackTrace.fromString(e.toString()));
    }
  }
  // getData postData

  // static Future<http.Response> get(String url) async => await http.get(Uri.parse(url));
  // static Future<http.Response> post(String url) async => await http.post(Uri.parse(url));
}
