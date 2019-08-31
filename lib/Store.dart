import 'StoreModel.dart';
import 'StoreCollection.dart';
import 'StoreBible.dart';
import 'StoreConfiguration.dart';
import 'StoreUtility.dart';

class Store extends StoreConfiguration with StoreCollection, StoreBible, StoreUtility {
  static final Store _instance = new Store.internal();
  factory Store() => _instance;
  Store.internal();

  Future<int> updateCollectionAvailable() async{
    return await getCollectionBookIdentify().then((CollectionBook book) async{
      return await updateBible(book.available > 0).then((int e) async{
        book.available = e;
        await writeCollection();
        analyticsShare(book.available == 1?'download':'remove', book.identify);
        return book.available;
      });
    });
  }
  Future<NAME> activeName() async{
    await this.bible.then((bible) async{
      await getCollectionBookIdentify().then((CollectionBook book) async{
        if (book.available < 1) {
          book.available++;
          await writeCollection();
        }
      });
    });
    this.testamentId = this.bookId > 39?2:1;
    return await this.currentBook();
  }

  Future<NAME> currentBook() async{
    return await this.getNames.then((e)=>e.singleWhere((i)=>i.book == this.bookId,orElse: ()=>null));
  }

  Future<List<Map<String, dynamic>>>  testingBookmark() async {
    return await this.bookmark.then((e) async{
     List<NAME> bookNames = await this.getNames;
     return e.map((bookmark){
       NAME book = bookNames.singleWhere((i)=>i.book == bookmark.book,orElse: ()=>null);
      return bookmark.toView(this.digit(bookmark.chapter),book.bookName,book.testamentName);
     }).toList();
    });
  }

  Future<void> analyticsBible() async {
    await activeName().then((NAME book) async{
      await this.getCollectionBookIdentify().then((e) async{
        this.analyticsContent('${e.name} (${e.shortname})',book.bookName);
        // print('analyticsBible, ${e.name} (${e.shortname}) ${book.bookName}');
      });
    });
  }
  Future<void> analyticsRead() async {
    await this.getCollectionBookIdentify().then((CollectionBook e) async{
      await this.currentBook().then((book){
        this.analyticsBook('${e.name} (${e.shortname})',book.bookName,chapterId.toString());
        // print('analyticsRead, ${book.bookName},${this.chapterId} ${e.name} (${e.shortname})');
      });
    });
  }

}