library data.core;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// NOTE: Preference
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// NOTE: Authentication
import 'package:lidea/firebase_auth.dart';
import 'package:lidea/unit/authentication.dart';

// NOTE: Navigation
import 'package:lidea/unit/navigation.dart';

// NOTE: Analytics
import 'package:lidea/unit/analytics.dart';

// NOTE: Store
// import 'package:lidea/unit/store.dart';
// NOTE: SQLite
// import 'package:lidea/unit/sqlite.dart';
// NOTE: Audio
// import 'package:audio_session/audio_session.dart';
// import 'package:just_audio/just_audio.dart';

// NOTE: Core notify and Initializing properties
import 'package:lidea/unit/engine.dart';

import '/type/main.dart';

part 'store.dart';
part 'sqlite.dart';
part 'audio.dart';

part 'preference.dart';
part 'authentication.dart';
part 'navigation.dart';
part 'analytics.dart';

part 'abstract.dart';
part 'utility.dart';
part 'mock.dart';
part 'scripture.dart';

class Core extends _Abstract with _Mock {
  // Core() : super();

  Future<void> init(BuildContext context) async {
    Stopwatch initWatch = Stopwatch()..start();
    preference.setContext(context);

    // await Future.microtask(() => null);

    await dataInitialized();

    await store.init();
    await sql.init();

    // await mockTest();

    collection.suggestQuery = collection.searchQuery;
    switchIdentifyPrimary();

    await primaryInit.catchError((e) {
      debugPrint('scripturePrimary: $e');
    });

    switchIdentifyParallel();

    // await scriptureParallel.init().catchError((e) {
    //   debugPrint('scriptureParallel: $e');
    // });
    message = '';

    debugPrint('Initiated in ${initWatch.elapsedMilliseconds} ms');
  }
}


/*
import 'dart:async';

// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:lidea/authentication.dart';
import 'package:lidea/analytics.dart';
import 'package:lidea/engine.dart';
// import 'package:lidea/hive.dart';

import 'package:bible/type.dart';

import 'store.dart';
import 'sqlite.dart';
// import 'player.dart';

part 'configuration.dart';
part 'abstract.dart';
part 'utility.dart';
part 'mock.dart';
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

*/