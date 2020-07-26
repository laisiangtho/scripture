
part of 'core.dart';

abstract class _Collection with _Configuration, _Utility {

  Future<Collection> _parseCollection(dynamic res) async => collection = await compute(parseCollectionCompute,res);

  Future<Collection> readCollection() async {
    if (collection == null) {
      await docsExists(assetsCollection).then((String hasExists) async {
        if (hasExists == null){
          await loadBundleAsString(join(assetsFolder,assetsCollection)).then(_parseCollection);
          await writeCollection();
        } else {
          await docsRead(assetsCollection).then(_parseCollection);
        }
      });
      // await docsExists(assetsCollection).then((bool hasExists) async {
      //   if (hasExists){
      //     await docsRead(assetsCollection).then(_parseCollection);
      //   } else {
      //     await loadBundleAsString(join(assetsFolder,assetsCollection)).then(_parseCollection);
      //     await writeCollection();
      //   }
      // });
    }
    return collection;
  }

  Future<void> writeCollection() async => await docsWrite(assetsCollection, encodeJSON(collection.toJSON()));

  Future<bool> deleteCollection() async => await docsExists(assetsCollection).then(
    (String hasExists) async{
      return (hasExists == null)?false:await docsDelete(assetsCollection);
    }
  );

  // Future<void> updateCollectionTest() async => Future.delayed(Duration(seconds: 3));
  Future<void> updateCollection() async => requestHTTP(_liveBookJSON.split('').reversed.join()).then(
    (res) async {
      // Map<String, dynamic> parsed = decodeJSON(res.body);
      Map<String, dynamic> parsed = decodeJSON(res);
      // NOTE: change of collection bible model
      parsed['bible'] = (parsed['book']??parsed['bible']);
      await parsed['bible'].forEach((e){
        int index = collection.bible.indexWhere((o)=>o.identify==e['identify']);
        if (index >= 0){
          CollectionBible bible = collection.bible.elementAt(index);
          bible.order = index;
          e.addAll(bible.userSetting());
        } else {
          collection.bible.add(CollectionBible.fromJSON(e));
        }
      });
      parsed['keyword'] = collection.keyword.map((e)=>e.toJSON()).toList();
      parsed['bookmark'] = collection.bookmark.map((e)=>e.toJSON()).toList();
      parsed['setting'] = collection.setting.toJSON();
      parsed['version'] = collection.version;
      await _parseCollection(parsed);
      await writeCollection();
    }
  ).catchError((e){
    // NOTE: Future.error
    throw e;
  });

  Future<void> updateCollectionBookAvailability(String id,int available) async {
    await collectionBookByIdentify(id).then((CollectionBible bible) => bible.available = available);
    await writeCollection();
  }

  Future<void> switchCollectionIdentify (bool force) async =>  await readCollection().then(
    (o) {
      if (this.identify.isEmpty) {
        this.identify = o.bible.firstWhere((i) => i.available > 0,orElse: () => o.bible.first).identify;
      } else if (force == true){
        this.identify = o.bible.firstWhere((i) => i.available > 0,orElse: () => o.bible.first).identify;
      }
      // collection.setting.identify = 'niv2011';
    }
  );

  Future<List<CollectionBible>> collectionBibleList() async => await readCollection().then((o)=>o.bible);
  Future<List<CollectionKeyword>> collectionKeywordList() async => await readCollection().then((o)=>o.keyword);
  // Future<List<CollectionBookmark>> get collectionBookmarkList async => await readCollection().then((o) => o.bookmark);
  List<CollectionBookmark> get collectionBookmarkList => collection.bookmark;

  Future<CollectionBible> collectionBookByIdentify(String id) async => await collectionBibleList().then(
    (bible)=> bible.singleWhere((CollectionBible e)=>e.identify == id)
  );
  // CollectionBible collectionBookByIdentify(String id) => collection.bible.firstWhere((CollectionBible e)=>e.identify == id);
  CollectionBible get getCollectionBible => collection.bible.firstWhere((CollectionBible e)=>e.identify == this.identify);
  CollectionLanguage get getCollectionLanguage => getCollectionBible.language;

  Future<void> addKeyword(String query) async => await collectionKeywordList().then(
    (keyword) async {
      // List<CollectionKeyword> selected = keyword.where((e)=>e.word.toLowerCase().startsWith(query.toLowerCase())).toList();
      if (query.isNotEmpty){
        List<CollectionKeyword> selected = keyword.where((e)=>e.word.toLowerCase() == query.toLowerCase()).toList();
        if (selected.length == 0){
          keyword.insert(0, CollectionKeyword.fromJSON(query));
          await writeCollection();
        }
      }
    }
  ).catchError((e){
    throw e;
  });
}