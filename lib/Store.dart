import 'package:laisiangtho/StoreModel.dart';
import 'package:laisiangtho/StoreBook.dart';
import 'package:laisiangtho/StoreBible.dart';
import 'package:laisiangtho/StoreConfiguration.dart';

class Store extends StoreConfiguration with StoreBook, StoreBible {
  static final Store _instance = new Store.internal();
  factory Store() => _instance;
  Store.internal();

  Future<List> updateBook() async {
    return await observeBooks(await db, await requestBookJSON());
  }
  // Future<List<ModelBible>> getBookAll() async {
  //   return await bookList;
  // }
  // Future<List<ModelBible>> getBookOffline() async {
  //   return await bookList.then((books) => books.where((e)=>e.available > 0).toList());
  // }

  // Future<List<ModelBible>> getBookAvailable() async {
  //   return await bookList.then((books) => books.where((e)=>e.available >= 0).toList());
  // }
  // ModelBible getBookTest(String id) {
  //   return bookList.then((books) => books.singleWhere((e)=>e.identify == id));
  // }
  Future<bool> updateBookAvailable() async{
    // return null;
    // String id
    // await bookList;

    // List<ModelBible> books = await bookList.then((books) => books.where((e)=>e.identify == id).toList());
    // ModelBible book = await bookList.then((books) => books.singleWhere((e)=>e.identify == identify));
    // ModelBible book = await bookList.then((books) => books.where((e)=>e.identify == identify).single);
    // ModelBible book = _bookCollection.singleWhere((e) => e.identify == identify);
    // print(book.length);
      // print(book.name);
      // print(book.available);
    return await bookList.then((books) async{
      ModelBible book = books.where((e)=>e.identify == identify).single;
      if (book.available > 0){
        // NOTE bible Available, therefore delete it
        return await this.localBibleJSON.then((file) async {
          return await file.delete().then((_) {
            return true;
          }).catchError((_){
            return false;
          }).whenComplete(() async{
            book.available = 0;
            return await this.bookAvailability(book.available.toString()).then((int count) => count>0);
          });
        });
      } else {
        // NOTE bible not Available, therefore download it
        return await this.requestBibleJSON.then((data) async {
          return await this.writeBibleJSON(data).then((_) async{
            book.available = 1;
            return await this.bookAvailability(book.available.toString()).then((int count) => count>0);
          }).catchError((_){
            return false;
          });
        });
      }
    });
    /*
    if (isAvailable) {
      return await this.requestBibleJSON.then((data) async {
        return await this.writeBibleJSON(data).then((_){
          print('downloaded');
          return true;
        }).catchError((_){
          return false;
        });
      });
    } else {
      return await this.localBibleJSON.then((file) async {
        return await file.delete().then((_){
          print('deleted');
          return true;
        }).catchError((_){
          return false;
        });
      });
    }
    */
    // return await bookList.then((books) async{
    //   ModelBible book = books.singleWhere((e)=>e.identify == this.identify);
    //   // ModelBible book = books.where((e)=>e.identify == identify).single;
    //   print(book.name);
    // //   print(book.available);
    // // // print(isAvailable);
    //   return isAvailable;
    //   // int count = await db.then((Database client)=>client.rawUpdate('UPDATE book SET available = ? WHERE identify = ?',[book.available,book.identify]));
    //   // print('updated: $count');
    // });

    // return book;
      // print(book.available);
    // books.map((e){
    // });
  }
}