
part of 'core.dart';

// Collection get collection => _dataCollection;
// set collection (Collection e) => _dataCollection = e;

Collection parseCollectionCompute(dynamic response) {
  Map<String, dynamic> parsed = (response is String)?decodeJSON(response):response;
  return Collection.fromJSON(parsed)..bible.sort(
    (a, b) => a.order.compareTo(b.order)
  );
}

DefinitionBible parseBibleCompute(String response){
  Map<String, dynamic> parsed = decodeJSON(response);
  return DefinitionBible.fromJSON(parsed);
}

// Future<Response> requestHTTP(String url) async => await Client().get(url).catchError((e)=>'e? $e');
// Future<http.Response> requestHTTP(String url) async => await http.post(url);

Future<String> requestHTTP(String url) async {
  try {
    http.Response response = await http.get(url);
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

Map<String, dynamic> decodeJSON(String response)  => json.decode(response);

String encodeJSON(Map<String, dynamic> response) => json.encode(response);

Future<String> loadBundleAsString(String fileName) => rootBundle.loadString(fileName);

// Future<directory> get appDirectory async => await getApplicationDocumentsDirectory();

Future<Directory> get directory => getApplicationDocumentsDirectory();

// Future<File> documents(String fileName) async {
//   FileSystemEntity directory = await directory;
//   return new File(join(directory.path, fileName));
// }

Future<File> documents(String fileName) async => new File(
  join(await directory.then((e) => e.path), fileName)
);

Future<File> docsWrite(String fileName, String fileContext) async => await documents(fileName).then(
  (File e) async => await e.writeAsString(fileContext)
);

Future<String> docsRead(String fileName) async => await documents(fileName).then(
  (File e) async => await e.readAsString()
);

Future<FileSystemEntity> docsDelete(String fileName) async => await documents(fileName).then(
  (File e) async => await e.delete()
);

/// NOTE: if exist return path basename,if not NULL
Future<String> docsExists(String fileName) async => await documents(fileName).then(
  (File e) async => await e.exists()?basename(fileName):null
);
// Future<bool> docsExists(String fileName) async => await documents(fileName).then(
//   (File e) async => await e.exists()
// );

Future<PackageInfo> get appInfo => PackageInfo.fromPlatform();
