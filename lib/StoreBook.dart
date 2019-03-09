import 'dart:convert';
import 'package:path/path.dart';
// import 'package:flutter/foundation.dart';

import 'package:sqflite/sqflite.dart';
import 'package:laisiangtho/StoreModel.dart';
import 'package:laisiangtho/StoreConfiguration.dart';

mixin StoreBook on StoreConfiguration {
  // static final StoreBook _instance = new StoreBook.internal();
  // factory StoreBook() => _instance;
  // StoreBook.internal();

  Database _db;
  List<ModelBible> _bookCollection;

  get _url => 'nosj.*/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth'.split('').reversed.join().replaceAll('*', 'book');
  get _filename => 'assets/bible/'+basename(this._url);


  Future<Database> get db async {
    if (_db == null) _db = await _initDatabase();
    // if (_db == null) _db = await compute(_initDatabase;
    return _db;
  }



  _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String bookPath = join(databasesPath, 'book.db');
    // await deleteDatabase(bookPath);
    return await openDatabase(bookPath, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS book (identify TEXT PRIMARY KEY, name TEXT, shortname TEXT, year INTEGER, lang TEXT, desc TEXT, version INTEGER, available INTEGER)');
      await observeBooks(db, await readBookJSON());
      await db.execute('CREATE TABLE IF NOT EXISTS bookmark (lid INTEGER, book INTEGER, chapter INTEGER, verse TEXT)');
    });
  }

  Future observeBooks(Database db, json) async {
    final batch = db.batch();
    bool isInitiated = _bookCollection != null;
    for (var o in json['book']) {
      int index = isInitiated?_bookCollection.indexWhere((e)=>e.identify==o['identify']):-1;
      if (index >= 0) {
        Map userData = _bookCollection.elementAt(index).toJSON();
        ModelBible e = ModelBible.fromJSON(o..addAll(userData));
        _bookCollection.removeAt(index);
        _bookCollection.insert(index, e);
        // _bookCollection.insertAtPosition();
        batch.update('book', e.toDatabase(), where: 'identify = ?', whereArgs: [e.identify]);
      } else {
        ModelBible e = ModelBible.fromJSON(o);
        batch.insert('book', e.toDatabase());
        if (isInitiated) _bookCollection.add(e);
      }
    }
    return await batch.commit();
  }

  Future<List<ModelBible>> get bookList async {
    if (_bookCollection == null) {
      await db.then((Database client)=>client.rawQuery('SELECT * FROM book')).then((List<Map> result){
        _bookCollection = result.map<ModelBible>((o) => ModelBible.fromDatabase(o)).toList();
      });
    }
    return _bookCollection;
  }

  Future<int> bookAvailability(String _availability) async {
    return await db.then((client)=>client.rawUpdate('UPDATE book SET available = ? WHERE identify = ?',[_availability,identify]));
  }

  Future close() async {
    await db.then((client)=>client.close());
  }
  Future readBookJSON() async {
    return json.decode(await this.appBundle(this._filename));
  }
  Future requestBookJSON() async {
    // final response = await this.requestHTTP(this._url);
    // return json.decode(response.body);
    // return await this.requestHTTP(this._url).then((response){
    //   return json.decode(response.body);
    // });
    return await this.requestHTTP(this._url).then((response){
      return json.decode(response.body);
    });
    // return json.decode( await this.requestHTTP(this._url)..body);
  }
}