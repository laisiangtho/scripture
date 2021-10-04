import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:lidea/notify.dart';
import 'package:lidea/engine.dart';
import 'package:lidea/analytics.dart';

import 'package:bible/type.dart';
// import 'package:bible/notifier.dart';

// import 'store.dart';
// import 'sqlite.dart';

part 'scripture.dart';

part 'configuration.dart';
part 'notify.dart';
part 'abstract.dart';
// part 'store.dart';
// part 'sqlite.dart';
part 'utility.dart';
part 'mock.dart';

// class Core extends _Abstract with _Bible, _Bookmark, _Speech, _Mock
// abstract class _Abstract with _Configuration, _Utility
// mixin _Configuration
// mixin _Bible on _Abstract
// mixin _Bookmark on _Bible
// mixin _Speech
// mixin _Mock
// mixin _Utility

class Core extends _Abstract with _Mock {
  // Creates instance through `_internal` constructor
  static final Core _instance = new Core.internal();
  Core.internal();
  factory Core() => _instance;
  // retrieve the instance through the app
  static Core get instance => _instance;

  Future<void> init() async {
    Stopwatch initWatch = new Stopwatch()..start();

    if (progressPercentage == 1.0) return;

    await initEnvironment();
    progressPercentage = 0.1;

    await Hive.initFlutter();
    Hive.registerAdapter(SettingAdapter());
    Hive.registerAdapter(HistoryAdapter());
    Hive.registerAdapter(BookmarkAdapter());
    Hive.registerAdapter(BookAdapter());
    // Hive.registerAdapter(PurchaseAdapter());
    progressPercentage = 0.4;
    await initSetting();

    await mockTest();

    // store = new Store(notify:notify,collection: collection);
    // await store.init();

    // _sql = new SQLite(collection: collection);
    // await _sql.init();

    switchIdentifyPrimary();
    progressPercentage = 0.5;
    scripturePrimary = new Scripture(collection: collection);
    message = 'Identify';
    // await scripturePrimary.init().catchError((e){
    //   debugPrint('scripturePrimary: $e');
    // });
    await primaryInit.catchError((e){
      debugPrint('scripturePrimary: $e');
    });

    message = 'look through';
    progressPercentage = 0.8;
    switchIdentifyParallel();
    scriptureParallel = new Scripture(collection: collection, collectionType: 1);
    // await scriptureParallel.init().catchError((e){
    //   debugPrint('scriptureParallel: $e');
    // });

    // message = 'Parallel';

    // await mockTest();

    message = '';
    progressPercentage = 1.0;
    await Future.delayed(Duration(milliseconds: 10));

    // searchQuery = collection.searchQuery;
    // debugPrint('primaryId: ${scripturePrimary.identify}, parallelId: ${scriptureParallel.identify}');
    debugPrint('Initiated at ${initWatch.elapsedMilliseconds} Milliseconds');
  }

}
