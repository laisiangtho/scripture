
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
    // TODO: collection available item on auto download
    CollectionBible bible = collectionBookByIdentify(id);
    if(bible.available != available) {
      bible.available = available;
      bool isDelete = available == 0;
      if (isDelete) switchIdentifyPrimary(force:id == this.primaryId);
      await writeCollection();
      this.analyticsShare(isDelete?'delete':'download', id);
      // print(isDelete?'delete':'download');
    }
    // await collectionBookByIdentify(id).then((CollectionBible bible) => bible.available = available);
    // await writeCollection();
  }

  // switchCollectionIdentify switchIdentifyPrimary switchIdentifyParallel
  // Future<void> switchIdentifyPrimary (bool force) async =>  await readCollection().then(
  //   (o) {
  //     if (this.primaryId.isEmpty) {
  //       this.primaryId = o.bible.firstWhere((i) => i.available > 0,orElse: () => o.bible.first).identify;
  //     } else if (force == true){
  //       this.primaryId = o.bible.firstWhere((i) => i.available > 0,orElse: () => o.bible.first).identify;
  //     }
  //     // collection.setting.identify = 'niv2011';
  //   }
  // );
  // Future<void> switchIdentifyParallel () async =>  await readCollection().then(
  //   (o) {
  //     if (this.parallelId.isEmpty || this.parallelId == this.primaryId ) {
  //       this.parallelId = o.bible.firstWhere((i) => i.identify != this.primaryId && i.available > 0,orElse: () => o.bible.first).identify;
  //     }
  //   }
  // );
  void switchIdentifyPrimary({bool force}) {
    if (this.primaryId.isEmpty || force == true) {
      this.primaryId = collection.bible.firstWhere(
        (i) => i.available > 0,
        orElse: () => collection.bible.first
      ).identify;
    }
  }

  void switchIdentifyParallel() {
    if (this.parallelId.isEmpty || this.parallelId == this.primaryId ) {
      this.parallelId = collection.bible.singleWhere(
        (i) => i.identify != this.primaryId && i.available > 0,
        // NOTE: when no available next to primaryId
        orElse: () => collection.bible.firstWhere((i) => i.identify != this.primaryId)
      ).identify;
    }
  }

  Future<List<CollectionBible>> collectionBibleList() async => await readCollection().then((o)=>o.bible);
  Future<List<CollectionKeyword>> collectionKeywordList() async => await readCollection().then((o)=>o.keyword);
  // Future<List<CollectionBookmark>> get collectionBookmarkList async => await readCollection().then((o) => o.bookmark);
  List<CollectionBookmark> get collectionBookmarkList => collection.bookmark;
  // CollectionBible collectionBookByIdentify(String id) => collection.bible.singleWhere((CollectionBible e)=>e.identify == id);
  CollectionBible collectionBookByIdentify(String id) => collection.bible.firstWhere((CollectionBible e)=>e.identify == id);

  // collectionPrimary collectionParallel scripturePrimary scriptureParallel collectionLanguagePrimary collectionLanguageParallel
  CollectionBible get collectionPrimary => collectionBookByIdentify(primaryId);
  CollectionLanguage get collectionLanguagePrimary => collectionPrimary.language;

  CollectionBible get collectionParallel => collectionBookByIdentify(parallelId);
  CollectionLanguage get collectionLanguageParallel => collectionParallel.language;

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