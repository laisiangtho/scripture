import 'dart:async';

// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:lidea/authentication.dart';
import 'package:lidea/analytics.dart';
import 'package:lidea/engine.dart';
import 'package:lidea/hive.dart';

import 'package:bible/type.dart';

import 'purchase.dart';

part 'configuration.dart';
part 'abstract.dart';
part 'utility.dart';
part 'mock.dart';
// part 'store.dart';
// part 'sqlite.dart';
// part 'audio.dart';

part 'scripture.dart';

class Core extends _Abstract with _Mock {
  Core(Authentication authentication) : super(authentication);

  Future<void> init() async {
    Stopwatch initWatch = Stopwatch()..start();

    await Future.microtask(() => null);

    await _initData();

    // store = new Store(notify:notify,collection: collection);
    // await store.init();

    // // _sql = new SQLite(collection: collection);
    // // await _sql.init();

    // audio = new Audio(notifyIf:notifyIf, collection: collection);
    // await audio.init();

    collection.suggestQuery = collection.searchQuery;
    switchIdentifyPrimary();
    scripturePrimary = Scripture(collection: collection);

    await primaryInit.catchError((e) {
      debugPrint('scripturePrimary: $e');
    });

    switchIdentifyParallel();
    scriptureParallel = Scripture(collection: collection, collectionType: 1);
    // await scriptureParallel.init().catchError((e) {
    //   debugPrint('scriptureParallel: $e');
    // });
    message = '';

    debugPrint('Initiated in ${initWatch.elapsedMilliseconds} ms');
  }

  Future<void> analyticsReading() async {
    analyticsSearch('keyword goes here');
  }
}
