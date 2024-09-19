part of 'main.dart';

/// A custom data provider extended on [_Searches], [_Mocks] and [_Abstracts].
/// And private class for current project, but have access to parent data
abstract class _Engines extends _Mocks {
  late final scripturePrimary = Scripture(data);
  late final scriptureParallel = Scripture(data, dataType: 1);

  Future<void> engineInitialized() async {
    // debugPrint('prepareInitialized');
    if (data.requireInitialized) {
      Iterable<APIType> api = data.env.api.where(
        (e) => e.asset.isNotEmpty,
      );

      for (var e in api) {
        // await UtilArchive.extractBundle(e.asset, noneArchive: true);
        await Docs.archive.bundle(e.asset);
      }
    }

    await _initBooks();
  }

  Future<void> _initBooks() async {
    // if (data.boxOfBooks.box.isEmpty) {
    //   String file = data.env.url('book').local;
    //   await UtilDocument.readAsJSON<List<dynamic>>(file).then((ob) async {
    //     await _importBookMeta(ob);
    //   }).catchError((e) async {
    //     final abc = data.env.url('book');
    //     debugPrint('task? $file, ${abc.toString()} $e  ');
    //   });
    // }

    // NOTE: data.isUpdated can be removed a year or two later
    if (data.boxOfBooks.box.isEmpty || data.isUpdated) {
      // NOTE: this conditional can be removed when data.isUpdated no longer need
      // if (data.boxOfBooks.box.isNotEmpty) {
      //   await data.boxOfBooks.box.clear();
      // }
      // if (data.boxOfBookmarks.box.isNotEmpty) {
      //   await data.boxOfBookmarks.box.clear();
      // }
      String file = data.env.url('book').local;

      // final ob = Docs.raw.decodeJSON<List<dynamic>>(
      //   await Docs.asset.readAsString(file),
      // );

      final ob = await Docs.asset.readAsJSON<List<dynamic>>(file);
      await _importBookMeta(ob);
    }
  }

  Future<void> updateBookMeta() async {
    // final urls = data.env.url('book').uri(name: "git+");
    // debugPrint(urls.toString());
    final url = data.env.url('book').uri();
    return AskNest(url).get<String>().then((e) async {
      final parsed = Docs.raw.decodeJSON(e);
      // debugPrint(e);
      await _importBookMeta(parsed['book']);
    }).catchError((e) {
      // debugPrint('updateBookMeta $e');
    });
  }

  Future<void> _importBookMeta(List<dynamic> items) async {
    final books = data.boxOfBooks.values.toList();

    for (var item in items) {
      BooksType meta = BooksType.fromJSON(item);
      int index = books.indexWhere((o) => o.identify == meta.identify);

      String file = data.env.url('bible').cache(meta.identify);
      meta.available = await Docs.app.exists(file).then((e) {
        return e.isNotEmpty ? 1 : 0;
      }).catchError((_) {
        return 0;
      });

      if (index > -1) {
        BooksType old = books.elementAt(index);
        // Check if Bible has a new version
        meta.update = (meta.available > 0 && old.version != meta.version) ? 1 : old.update;
        meta.selected = old.selected;
        data.boxOfBooks.box.put(index, meta);
      } else {
        data.boxOfBooks.box.add(meta);
        // debugPrint('add ${meta.identify} ');
      }
    }

    // for (var item in items) {
    //   BooksType meta = BooksType.fromJSON(item);
    //   int index = books.indexWhere((o) => o.identify == meta.identify);

    //   String file = data.env.url('bible').cache(meta.identify);
    //   meta.available = await Docs.app.exists(file).then((e) {
    //     return e.isNotEmpty ? 1 : 0;
    //   }).catchError((_) {
    //     return 0;
    //   });

    //   data.boxOfBooks.box.a

    //   if (index > -1) {
    //     BooksType old = books.elementAt(index);
    //     // Check if Bible has a new version
    //     meta.update = (meta.available > 0 && old.version != meta.version) ? 1 : old.update;
    //     meta.selected = old.selected;
    //     data.boxOfBooks.box.put(index, meta);
    //     debugPrint('update ${meta.identify} ${meta.available}');
    //   } else {
    //     data.boxOfBooks.box.add(meta);
    //     debugPrint('add ${meta.identify} ');
    //   }
    // }
  }

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
        .whenComplete(state.notify);
  }

  /// Bookmark delete all
  void clearBookmarkWithNotify() {
    data.boxOfBookmarks.clearAll().whenComplete(state.notify);
  }

  /// Bookmark delete once
  void deleteBookmarkWithNotify(int index) {
    data.boxOfBookmarks.deleteAtIndex(index).whenComplete(state.notify);
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
      // debugPrint('51? $e');
    }).whenComplete(scripturePrimary.changeNotify);
  }

  Future<void> get chapterNext {
    return primaryInit.then((_) {
      return scripturePrimary.chapterNext();
    }).catchError((e) {
      // debugPrint('52? $e');
    }).whenComplete(scripturePrimary.changeNotify);
  }

  Future<void> chapterChange({int? bookId, int? chapterId}) {
    return primaryInit.then((_) {
      return scripturePrimary.chapterBook(bId: bookId, cId: chapterId);
    }).catchError((e) {
      // debugPrint('53? $e');
    }).whenComplete(scripturePrimary.changeNotify);
  }
}
