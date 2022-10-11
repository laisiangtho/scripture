part of data.core;

abstract class _Mock extends _Abstract {
  late final scripturePrimary = Scripture(data);
  late final scriptureParallel = Scripture(data, dataType: 1);

  Future<void> prepareInitialized() async {
    if (data.requireInitialized) {
      Iterable<APIType> api = data.env.api.where(
        (e) => e.asset.isNotEmpty,
      );

      for (var e in api) {
        // await UtilArchive.extractBundle(e.asset, noneArchive: true);
        await ArchiveNest.extractBundle(e.asset, noneArchive: true);
      }
    }
    if (data.boxOfBooks.box.isEmpty) {
      String file = data.env.url('book').local;
      await UtilDocument.readAsJSON<List<dynamic>>(file).then((ob) async {
        await _importBookMeta(ob);
      }).catchError((e) {
        debugPrint('task? $file $e ');
      });
    }
  }

  Future<void> updateBookMeta() async {
    final url = data.env.url('book').uri();
    return AskNest(url).get<String>().then((e) async {
      final parsed = UtilDocument.decodeJSON(e);
      await _importBookMeta(parsed['book']);
    });
  }

  Future<void> _importBookMeta(List<dynamic> bookList) async {
    final books = data.boxOfBooks.values.toList();
    for (var item in bookList) {
      BooksType meta = BooksType.fromJSON(item);
      int index = books.indexWhere((o) => o.identify == meta.identify);

      String file = data.env.url('bible').cache(meta.identify);
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
        data.boxOfBooks.box.put(index, meta);
        debugPrint('update ${meta.identify} ${meta.available}');
      } else {
        data.boxOfBooks.box.add(meta);
        debugPrint('add ${meta.identify} ');
      }
    }
  }

  // TODO: StateError (Bad state: No element)
  void switchIdentifyPrimary({bool force = false}) {
    final val = data.boxOfBooks.values;
    if (data.primaryId.isEmpty) {
      data.primaryId = val
          .firstWhere(
            (e) => e.available > 0,
            // NOTE: when no available just get the first
            orElse: () => val.first,
          )
          .identify;
    }

    // NOTE: check is available
    int index = val.toList().indexWhere(
          (e) => e.identify == data.primaryId && e.available > 0,
        );
    if (index < 0) {
      data.primaryId = val
          .firstWhere(
            (e) => e.available > 0,
            orElse: () => val.first,
          )
          .identify;
    }
  }

  void switchIdentifyParallel() {
    final val = data.boxOfBooks.values;
    if (data.parallelId.isEmpty) {
      data.parallelId = val
          .firstWhere(
            (e) => e.identify != data.primaryId && e.available > 0,
            // NOTE: when no available just get next to primaryId
            orElse: () => val.firstWhere((i) => i.identify != data.primaryId),
          )
          .identify;
    }

    // NOTE: check is available
    int index = val.toList().indexWhere(
          (e) => e.identify == data.parallelId && e.available > 0,
        );
    if (index < 0) {
      data.parallelId = data.boxOfBooks.values
          .firstWhere(
            (e) => e.identify != data.primaryId && e.available > 0,
            orElse: () => val.first,
          )
          .identify;
    }
  }

  Future<void> switchAvailabilityUpdate(String identify) {
    // Scripture scripture = new Scripture(identify:identify,collection:collection);
    try {
      data.primaryId = identify;
      switchIdentifyParallel();
      Scripture scripture = Scripture(data);
      return scripture.switchAvailability(deleteIfExists: true);
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Bookmark switch
  void switchBookmarkWithNotify() {
    data.boxOfBookmarks
        .userSwitch(
          data.bookmarkIndex,
          data.primaryId,
          data.bookId,
          data.chapterId,
        )
        .whenComplete(notify);
  }

  /// Bookmark delete all
  void clearBookmarkWithNotify() {
    data.boxOfBookmarks.clearAll().whenComplete(notify);
  }

  /// Bookmark delete once
  void deleteBookmarkWithNotify(int index) {
    data.boxOfBookmarks.deleteAtIndex(index).whenComplete(notify);
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
      debugPrint('51? $e');
    }).whenComplete(scripturePrimary.changeNotify);
  }

  Future<void> get chapterNext {
    return primaryInit.then((_) {
      return scripturePrimary.chapterNext();
    }).catchError((e) {
      debugPrint('52? $e');
    }).whenComplete(scripturePrimary.changeNotify);
  }

  Future<void> chapterChange({int? bookId, int? chapterId}) {
    return primaryInit.then((_) {
      return scripturePrimary.chapterBook(bId: bookId, cId: chapterId);
    }).catchError((e) {
      debugPrint('53? $e');
    }).whenComplete(scripturePrimary.changeNotify);
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

  // void userObserver(User? user) {
  //   debugPrint('userObserver begin');
  // }

  // Future<void> analyticsFromCollection() async {
  //   analyticsSearch('keyword goes here');
  // }
}
