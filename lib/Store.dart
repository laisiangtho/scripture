import 'StoreModel.dart';
import 'StoreCollection.dart';
import 'StoreBible.dart';
import 'StoreConfiguration.dart';

class Store extends StoreConfiguration with StoreCollection, StoreBible {
  static final Store _instance = new Store.internal();
  factory Store() => _instance;
  Store.internal();

  Future<bool> updateCollectionAvailable() async{
    return await getCollectionBookIdentify().then((CollectionBook book) async{
      await updateBible(book.available > 0).then((int e) async{
        book.available = e;
        await writeCollection();
      });
    });
  }

  Future<List<Map<String, dynamic>>>  testingBookmark() async {

    return await this.bookmark.then((e) async{

     List<NAME> names = await this.getNames;
     List<Map<String, dynamic>> list = [];
     for (var bookmark in e) {
       NAME book = names.singleWhere((i)=>i.book == bookmark.book,orElse: ()=>null);
      //  int index = bookName.indexWhere((i)=>i.id == bookmark.bookId && i.type == false);
       list.add(bookmark.toView(book.bookName));
     }
     return list;
    });
  }
}