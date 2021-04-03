// import 'dart:async';
// import 'dart:math';
import 'package:path/path.dart';

// import 'package:flutter_tts/flutter_tts.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:lidea/engine.dart';
import 'package:lidea/analytics.dart';

import 'package:bible/model.dart';

part 'configuration.dart';
part 'scripture.dart';
// part 'engine.md';
part 'collection.dart';
part 'bible.dart';
part 'bookmark.dart';
part 'utility.dart';
part 'speech.dart';

class Core extends _Collection with _Bible, _Bookmark, _Speech {
  // Creates instance through `_internal` constructor
  static Core _instance = new Core.internal();
  Core.internal();

  factory Core() => _instance;

  // retrieve the instance through the app
  static Core get instance => _instance;

  Future<void> init() async {
    await readCollection();
    switchIdentifyPrimary();
    await getBiblePrimary.catchError((e){
      debugPrint('error Primary $e');
    });

    switchIdentifyParallel();
    await getBibleParallel.catchError((e){
      debugPrint('error Parallel $e');
    });

    // ????
    // await initSpeech().catchError((e){
    //   print('error speech $e');
    // });

    // await loadDefinitionBible(identify).catchError((e){
    //   // print('init loadDefinitionBible $e');
    // });
    // await Future.delayed(Duration(milliseconds: 300), (){});
  }

  // NOTE: used on read: when [bible] is switch
  Future<void> analyticsBible() async{
    CollectionBible e = collectionPrimary;
    // print('analyticsBible ${e.name} ${e.shortname} book:$bookName');
    if (e != null) this.analyticsContent('${e.name} (${e.shortname})', this.bookName);
  }

  // NOTE: used on read: when [book,chapter] are change
  Future<void> analyticsReading() async {
    CollectionBible e = collectionPrimary;
    // print('analyticsReading ${e.name} ${e.shortname} book:$bookName chapter: $chapterName');
    if (e != null) this.analyticsBook('${e.name} (${e.shortname})', this.bookName, this.chapterName);
  }
}
