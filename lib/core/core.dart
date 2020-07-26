import 'dart:async';
import 'dart:convert' show json;
import 'dart:io';
// import 'dart:math';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:bible/model.dart';

part 'configuration.dart';
part 'engine.dart';
part 'collection.dart';
part 'bible.dart';
part 'bookmark.dart';
part 'mock.dart';
part 'utility.dart';

class Core extends _Collection with _Bible, _Bookmark, _Mock {
  //Creates instance through `_internal` constructor
  static Core _instance = new Core.internal();
  Core.internal();

  factory Core() => _instance;

  //retrieve the instance through the app
  static Core get instance => _instance;

  Future init() async {
    await appInfo.then((PackageInfo packageInfo) {
      this.appName = packageInfo.appName;
      this.packageName = packageInfo.packageName;
      this.version = packageInfo.version;
      this.buildNumber = packageInfo.buildNumber;
      initProgress.value=0.2;
      // print('$appName $packageName $version $buildNumber');
    });

    await readCollection().whenComplete(
      () => initProgress.value=0.5
    );
    await switchCollectionIdentify(false).whenComplete(
      () => initProgress.value=0.6
    );
    // await getBibleCurrent.whenComplete(
    //   () => initProgress.value=0.6
    // );
    await loadDefinitionBible(identify).catchError((e){
      // print('init loadDefinitionBible $e');
    }).whenComplete((){
      initProgress.value=0.7;
    });
    await Future.delayed(const Duration(milliseconds: 20), () {initProgress.value=0.9;});
    await Future.delayed(const Duration(milliseconds: 20), () {initProgress.value=1.0;});
  }

  Future<void> analyticsBible(DefinitionBook book) async {
    CollectionBible e = getCollectionBible;
    this.analyticsContent('${e.name} (${e.shortname})', book.name);
  }

  Future<void> analyticsRead() async {
    // NOTE: used on read: [book,chapter] change
    CollectionBible e = getCollectionBible;
    this.analyticsBook('${e.name} (${e.shortname})',this.bookName,this.chapterName);
  }

}
