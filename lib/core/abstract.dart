part of data.core;

abstract class _Abstract extends UnitEngine with _Utility {
  final Collection collection = Collection.internal();

  late final Preference preference = Preference(collection);
  // authenticate navigate
  late final Authentication authentication = Authentication();
  late final NavigationNotify navigation = NavigationNotify();
  late final Poll poll = Poll(collection, notify, authentication);
  late final Analytics analytics = Analytics();

  late final store = Store();
  late final sql = SQLite();
  // late final store = Store(notify: notify, collection: collection);
  // late final sql = SQLite(collection: collection);

  late final scripturePrimary = Scripture(collection: collection);
  late final scriptureParallel = Scripture(collection: collection, collectionType: 1);

  Future<void> ensureInitialized() async {
    Stopwatch initWatch = Stopwatch()..start();

    await collection.ensureInitialized();
    await collection.prepareInitialized();
    await preference.ensureInitialized();
    await authentication.ensureInitialized();

    // if (authentication.id.isNotEmpty && authentication.id != collection.setting.userId) {
    //   final ou = collection.setting.copyWith(userId: authentication.id);
    //   await collection.settingUpdate(ou);
    // }

    debugPrint('ensureInitialized in ${initWatch.elapsedMilliseconds} ms');
  }

  String get searchQuery => collection.searchQuery.asString;
  set searchQuery(String ord) {
    notifyIf<String>(searchQuery, collection.searchQuery = ord);
  }

  String get suggestQuery => collection.suggestQuery.asString;
  set suggestQuery(String ord) {
    final word = ord.replaceAll(RegExp(' +'), ' ').trim();
    notifyIf<String>(suggestQuery, collection.suggestQuery = word);
  }

  Future<void> dataInitialized() async {
    // if (collection.requireInitialized) {
    //   APIType api = collection.env.api.firstWhere(
    //     (e) => e.asset.isNotEmpty,
    //   );
    //   await UtilArchive.extractBundle(api.asset, noneArchive: true);
    // }

    if (collection.requireInitialized) {
      Iterable<APIType> api = collection.env.api.where(
        (e) => e.asset.isNotEmpty,
      );

      for (var e in api) {
        await UtilArchive.extractBundle(e.asset, noneArchive: true);
      }
    }

    if (collection.boxOfBooks.box.isEmpty) {
      String file = collection.env.url('book').local;
      await UtilDocument.readAsJSON<List<dynamic>>(file).then((ob) async {
        await _importBookMeta(ob);
      }).catchError((e) {
        debugPrint('task? $file $e ');
      });
    }
  }

  Future<void> updateBookMeta() async {
    final url = collection.env.url('book').uri(null);
    return UtilAsk(url).get<String>().then((e) async {
      final parsed = UtilDocument.decodeJSON(e);
      await _importBookMeta(parsed['book']);
    });
  }

  Future<void> _importBookMeta(List<dynamic> bookList) async {
    final books = collection.boxOfBooks.values.toList();
    for (var item in bookList) {
      BooksType meta = BooksType.fromJSON(item);
      int index = books.indexWhere((o) => o.identify == meta.identify);

      String file = collection.env.url('bible').cache(meta.identify);
      meta.available = await UtilDocument.exists(file).then((e) {
        return e.isNotEmpty ? 1 : 0;
      }).catchError((_) {
        return 0;
      });

      if (index >= 0) {
        BooksType old = books.elementAt(index);
        // Check if Bible has a new version
        meta.update = (meta.available > 0 && old.version != meta.version) ? 1 : old.update;
        meta.selected = old.selected;
        collection.boxOfBooks.box.put(index, meta);
        debugPrint('update ${meta.identify} ${meta.available}');
      } else {
        collection.boxOfBooks.box.add(meta);
        debugPrint('add ${meta.identify} ');
      }
    }
  }

  void switchIdentifyPrimary({bool force = false}) {
    final val = collection.boxOfBooks.values;
    if (collection.primaryId.isEmpty) {
      collection.primaryId = val
          .firstWhere(
            (e) => e.available > 0,
            // NOTE: when no available just get the first
            orElse: () => val.first,
          )
          .identify;
    }

    // NOTE: check is available
    int index = val.toList().indexWhere(
          (e) => e.identify == collection.primaryId && e.available > 0,
        );
    if (index < 0) {
      collection.primaryId = val
          .firstWhere(
            (e) => e.available > 0,
            orElse: () => val.first,
          )
          .identify;
    }
  }

  void switchIdentifyParallel() {
    final val = collection.boxOfBooks.values;
    if (collection.parallelId.isEmpty) {
      collection.parallelId = val
          .firstWhere(
            (e) => e.identify != collection.primaryId && e.available > 0,
            // NOTE: when no available just get next to primaryId
            orElse: () => val.firstWhere((i) => i.identify != collection.primaryId),
          )
          .identify;
    }

    // NOTE: check is available
    int index = val.toList().indexWhere(
          (e) => e.identify == collection.parallelId && e.available > 0,
        );
    if (index < 0) {
      collection.parallelId = collection.boxOfBooks.values
          .firstWhere(
            (e) => e.identify != collection.primaryId && e.available > 0,
            orElse: () => val.first,
          )
          .identify;
    }
  }

  Future<void> switchAvailabilityUpdate(String identify) {
    // Scripture scripture = new Scripture(identify:identify,collection:collection);
    try {
      collection.primaryId = identify;
      switchIdentifyParallel();
      Scripture scripture = Scripture(collection: collection);
      return scripture.switchAvailability(deleteIfExists: true);
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Bookmark switch
  void switchBookmarkWithNotify() {
    collection.boxOfBookmarks
        .userSwitch(
          collection.bookmarkIndex,
          collection.primaryId,
          collection.bookId,
          collection.chapterId,
        )
        .whenComplete(notify);
  }

  /// Bookmark delete all
  void clearBookmarkWithNotify() {
    collection.boxOfBookmarks.clearAll().whenComplete(notify);
  }

  /// Bookmark delete once
  void deleteBookmarkWithNotify(int index) {
    collection.boxOfBookmarks.deleteAtIndex(index).whenComplete(notify);
  }

  /// init scripturePrimary and seed analytics
  Future<void> get primaryInit {
    return scripturePrimary.init().then((o) {
      analytics.book(
        '${o.info.name} (${o.info.shortname})',
        scripturePrimary.bookName,
        scripturePrimary.chapterName,
      );
    }).catchError((e) {
      throw e;
    });
  }

  Future<void> get chapterPrevious {
    return primaryInit.then((_) {
      return scripturePrimary.chapterPrevious();
    }).catchError((e) {
      debugPrint('10: $e');
    }).whenComplete(() {
      notify();
    });
  }

  Future<void> get chapterNext {
    return primaryInit.then((_) {
      return scripturePrimary.chapterNext();
    }).catchError((e) {
      debugPrint('10: $e');
    }).whenComplete(() {
      notify();
    });
  }

  Future<void> chapterChange({int? bookId, int? chapterId}) {
    return primaryInit.then((_) {
      return scripturePrimary.chapterBook(bId: bookId, cId: chapterId);
    }).catchError((e) {
      debugPrint('10: $e');
    }).whenComplete(() {
      notify();
    });
  }

  // void verseSelectionWithNotify(int id) {
  //   // scripturePrimary.init().then((o) {

  //   // }).catchError((e) {
  //   //   debugPrint('10: $e');
  //   // }).whenComplete(() {
  //   //   debugPrint('verseSelectionWithNotify ${scripturePrimary.verseSelectionWorking}');
  //   //   notify();
  //   // });
  //   final tmp = scripturePrimary.verseSelectionWorking;
  //   int index = tmp.indexWhere((i) => i == id);
  //   if (index >= 0) {
  //     tmp.removeAt(index);
  //   } else {
  //     tmp.add(id);
  //   }
  //   scripturePrimary.verseSelectionWorking = tmp;
  //   Future.microtask(() {
  //     notify();
  //   });
  // }

  // String _testQuery = '';

  // String get testQuery => _testQuery;
  // set testQuery(String ord) {
  //   // notifyIf<String>(_testQuery, _testQuery = ord);
  //   int index = scripturePrimary.verseSelectionWorking.indexWhere((i) => i == id);
  //     if (index >= 0) {
  //       scripturePrimary.verseSelectionWorking.removeAt(index);
  //     } else {
  //       scripturePrimary.verseSelectionWorking.add(id);
  //     }
  // }

  /*
  Future<void> initBible() async {
    if (collection.requireInitialized) {
      APIType api = collection.env.api.firstWhere(
        (e) => e.asset.isNotEmpty,
      );
      await UtilArchive.extractBundle(api.asset);
    }
    // if (requireInitialized) {
    //   final localData = collection.env.api.where((e) => e.asset.isNotEmpty);
    //   for (APIType api in localData) {
    //     await UtilArchive.extractBundle(api.assetName).then((_) {
    //       debugPrint('Ok ${api.uid}');
    //     }).catchError((e) {
    //       debugPrint('Error ${api.uid} $e');
    //     });
    //   }
    // }
  }

  Future<void> initDictionary() async {
    if (collection.requireInitialized) {
      APIType api = collection.env.api.firstWhere(
        (e) => e.asset.isNotEmpty,
      );
      await UtilArchive.extractBundle(api.asset);
    }
  }

  Future<void> initMusic() async {
    final localData = collection.env.api.where(
      (e) => e.local.isNotEmpty && !e.local.contains('!'),
    );
    if (collection.requireInitialized) {
      APIType api = collection.env.api.firstWhere((e) => e.asset.isNotEmpty);
      await UtilArchive.extractBundle(api.asset);
    }
    collection.cacheBucket = AudioBucketType.fromJSON(
      Map.fromEntries(
        await Future.wait(
          localData.map(
            (e) async => MapEntry(
              e.uid,
              await UtilDocument.readAsJSON<List<dynamic>>(e.localName),
            ),
          ),
        ),
      ),
    );
  }
  */

  // Future<void> deleteOldLocalData(Iterable<APIType> localData) async {
  //   if (requireInitialized) {
  //     for (APIType api in localData) {
  //       await UtilDocument.exists(api.localName).then((String e) {
  //         if (e.isNotEmpty) {
  //           UtilDocument.delete(e);
  //         }
  //       });
  //     }
  //   }
  // }

  void userObserver(User? user) {
    debugPrint('userObserver begin');
  }

  // Future<void> analyticsFromCollection() async {
  //   analyticsSearch('keyword goes here');
  // }
}

DefinitionBible parseDefinitionBibleCompute(String response) {
  Map<String, dynamic> parsed = UtilDocument.decodeJSON(response);
  return DefinitionBible.fromJSON(parsed);
}
