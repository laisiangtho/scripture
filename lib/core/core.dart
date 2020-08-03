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

  Future<void> init() async {
    await appInfo.then((PackageInfo packageInfo) {
      this.appName = packageInfo.appName;
      this.packageName = packageInfo.packageName;
      this.version = packageInfo.version;
      this.buildNumber = packageInfo.buildNumber;
      // print('$appName $packageName $version $buildNumber');
    });

    await readCollection();
    await switchCollectionIdentify(false);
    await getBibleCurrent.catchError((e){
      // print('init loadDefinitionBible $e');
    }).whenComplete((){
      print('finish init');
    });
    // await loadDefinitionBible(identify).catchError((e){
    //   // print('init loadDefinitionBible $e');
    // }).whenComplete((){
    //   print('finish init');
    // });
    // return await Future.delayed(Duration(milliseconds: 300), (){});
  }


  // NOTE: used on read: when [bible] is switch
  Future<void> analyticsBible() async{
    CollectionBible e = getCollectionBible;
    // print('analyticsBible ${e.name} ${e.shortname} book:$bookName');
    if (e != null) this.analyticsContent('${e.name} (${e.shortname})', this.bookName);
  }

  // NOTE: used on read: when [book,chapter] are change
  Future<void> analyticsReading() async {
    CollectionBible e = getCollectionBible;
    // print('analyticsReading ${e.name} ${e.shortname} book:$bookName chapter: $chapterName');
    if (e != null) this.analyticsBook('${e.name} (${e.shortname})', this.bookName, this.chapterName);
  }

}
