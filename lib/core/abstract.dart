
part of 'main.dart';

abstract class _Abstract extends CoreNotifier with _Configuration, _Utility {
  Future<void> initEnvironment() async {
    collection.env = EnvironmentType.fromJSON(UtilDocument.decodeJSON(await UtilDocument.loadBundleAsString('env.json')));
  }

  Future<void> initSetting() async {
    // Box<SettingType> box = await Hive.openBox<SettingType>(collection.env.settingName);
    // SettingType active = collection.boxOfSetting.get(collection.env.settingKey,defaultValue: collection.env.setting)!;
    collection.boxOfSetting = await Hive.openBox<SettingType>(collection.env.settingName);
    SettingType active = collection.setting;

    if (collection.boxOfSetting.isEmpty){
      collection.boxOfSetting.put(collection.env.settingKey,collection.env.setting);
    } else if (active.version != collection.env.setting.version){
      collection.boxOfSetting.put(collection.env.settingKey,active.merge(collection.env.setting));
    }

    collection.boxOfPurchase = await Hive.openBox<PurchaseType>('purchase');
    // collection.boxOfSetting.clear();

    collection.boxOfHistory = await Hive.openBox<HistoryType>('history');
    // collection.boxOfHistory.clear();

    collection.boxOfBookmark = await Hive.openBox<BookmarkType>('bookmark');
    // collection.boxOfBookmark.clear();

    collection.boxOfBook = await Hive.openBox<BookType>('book');
    // await collection.boxOfBook.clear();
    if (collection.boxOfBook.isEmpty){
      String file = collection.env.bibleAPI.archive;
      await loadArchive(file).then((value) {
        for (var o in value) {
          int index = collection.env.books.indexWhere((e) => e.identify == o.replaceFirst('.json', ''));
          if (index >= 0){
            collection.env.books[index].available = 1;
          }
        }
      }).catchError((e){
        debugPrint('? $e');
      });
      // final item = collection.env.api.firstWhere((e) => e.uid =='book').url;
      // collection.env.book.forEach((e) {
      //   debugPrint(item.replaceAll('book', e.identify));
      // });

      // for (var e in collection.env.book) {
      //   // debugPrint(item.replaceAll('book', e.identify));
      //   String file = item.replaceAll('book', e.identify);
      //   UtilDocument.exists(file).then((String fileName) {
      //     // if (fileName.isEmpty) {
      //     //   return download();
      //     // } else {
      //     //   return read();
      //     // }
      //     debugPrint('${e.identify} is ${fileName.isEmpty}');
      //   });
      // }

      await collection.boxOfBook.addAll(collection.env.books);
    }
    // Clear cache
    collection.env.books.clear();
  }

  Future<void> updateBookMeta() {
    final envBook = collection.boxOfBook.values.toList();
    APIType item = collection.env.bookAPI;
    return UtilClient(item.url).get<String>().then((value) async{
      final parsed = UtilDocument.decodeJSON(value);
      await parsed['book'].forEach((e){
        BookType meta = BookType.fromJSON(e);
        int index = envBook.indexWhere((o)=>o.identify==meta.identify);
        if (index >= 0){
          BookType old = envBook.elementAt(index);
          // Check if Bible has a new version
          meta.update = (old.available > 0 && old.version != meta.version)?1:old.update;
          meta.available = old.available;
          collection.boxOfBook.put(index, meta);
        } else {
          collection.boxOfBook.add(meta);
        }
      });
    }).catchError((e) {
      throw "Bible is not loaded";
    });
  }
  // Future<void> updateBookMeta() async {

  //   final envBook = collection.boxOfBook.values.toList();
  //   APIType item = collection.env.bookAPI;
  //   final parsed = UtilDocument.decodeJSON(await UtilClient(item.url).get<String>().catchError((e) => '{}'));

  //   await parsed['book'].forEach((e){
  //     BookType meta = BookType.fromJSON(e);
  //     int index = envBook.indexWhere((o)=>o.identify==meta.identify);
  //     if (index >= 0){
  //       BookType old = envBook.elementAt(index);
  //       // Check if Bible has a new version
  //       meta.update = (old.available > 0 && old.version != meta.version)?1:old.update;
  //       meta.available = old.available;
  //       collection.boxOfBook.put(index, meta);
  //     } else {
  //       collection.boxOfBook.add(meta);
  //     }
  //   });
  // }

  void switchIdentifyPrimary({bool force=false}) {
    if (collection.primaryId.isEmpty) {
      collection.primaryId = collection.boxOfBook.values.firstWhere(
        (e) => e.available > 0,
        // NOTE: when no available just get the first
        orElse: () => collection.boxOfBook.values.first
      ).identify;
    }

    // NOTE: check is available
    int index = collection.boxOfBook.values.toList().indexWhere(
      (e) => e.identify == collection.primaryId && e.available > 0
    );
    if (index < 0){
      collection.primaryId = collection.boxOfBook.values.firstWhere(
        (e) => e.available > 0,
        orElse: () => collection.boxOfBook.values.first
      ).identify;
    }
  }

  void switchIdentifyParallel() {
    if (collection.parallelId.isEmpty) {
      collection.parallelId = collection.boxOfBook.values.firstWhere(
        (e) => e.identify != collection.primaryId && e.available > 0,
        // NOTE: when no available just get next to primaryId
        orElse: () => collection.boxOfBook.values.firstWhere((i) => i.identify != collection.primaryId)
      ).identify;
    }

    // NOTE: check is available
    int index = collection.boxOfBook.values.toList().indexWhere(
      (e) => e.identify == collection.parallelId && e.available > 0
    );
    if (index < 0){
      collection.parallelId = collection.boxOfBook.values.firstWhere(
        (e) => e.identify != collection.primaryId && e.available > 0,
        orElse: () => collection.boxOfBook.values.first
      ).identify;
    }
  }

  Future<void> switchAvailabilityUpdate(String identify) {
    // Scripture scripture = new Scripture(identify:identify,collection:collection);
    try {
      collection.primaryId = identify;
      switchIdentifyParallel();
      Scripture scripture = new Scripture(collection:collection);
      return scripture.switchAvailability(deleteIfExists:true);
    } catch (e) {
      return Future.error(e);
    }
  }


  // NOTE: Bookmark
  void bookmarkSwitchNotify() {
    collection.bookmarkSwitch();
    notify();
  }

  void bookmarkClearNotify() => collection.boxOfBookmark.clear().whenComplete(notify);

  // NOTE: Archive extract File
  Future<List<String>> loadArchive(file) async{
    List<int>? bytes = await UtilDocument.loadBundleAsByte(file).then(
      (data) => UtilDocument.byteToListInt(data).catchError((_) => null)
    ).catchError((e) => null);
    if (bytes != null && bytes.isNotEmpty) {
      final res = await UtilArchive().extract(bytes).catchError((_) => null);
      if (res != null) {
        int index = collection.env.books.indexWhere((e) => e.identify == file.replaceFirst('.json', ''));
        if (index >= 0){
          collection.env.books[index].available = 1;
        }
        return res;
      }
    }
    return Future.error("Failed to load");
  }

  // NOTE: Analytics
  // ignore: todo
  // TODO: analytics
  Future<void> analyticsFromCollection() async{
    this.analyticsSearch('keyword goes here');
  }
}
