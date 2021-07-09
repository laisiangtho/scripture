part of 'main.dart';

class Collection{
  late EnvironmentType env;
  late Box<SettingType> boxOfSetting;
  late Box<HistoryType> boxOfHistory;
  late Box<BookmarkType> boxOfBookmark;
  late Box<PurchaseType> boxOfPurchase;
  late Box<BookType> boxOfBook;

  List<DefinitionBible> cacheBible = [];

  // NOTE: time sample
  // final time = watch..start(); time.elapsedMilliseconds
  // final Stopwatch watch = new Stopwatch();

  static final Collection _instance = new Collection.internal();
  factory Collection() => _instance;
  Collection.internal();

  // NOTE: retrieve the instance through the app
  static Collection get instance => _instance;

  // NOTE: compare 2 strings
  bool stringCompare(String? a, String b) => a!.toLowerCase() == b.toLowerCase();

  // NOTE: Setting
  SettingType get setting => boxOfSetting.get(env.settingKey,defaultValue: env.setting)!;

  Future<void> settingUpdate(SettingType value) async{
    boxOfSetting.put(env.settingKey,value);
  }

  String get primaryId => setting.identify;
  set primaryId(String id) {
    if (setting.identify != id) {
      this.settingUpdate(setting.copyWith(identify: id));
    }
  }

  String get parallelId => setting.parallel;
  set parallelId(String id) {
    if (setting.parallel != id) {
      this.settingUpdate(setting.copyWith(parallel: id));
    }
  }

  int get testamentId => this.bookId > 39?2:1;

  int get bookId => setting.bookId;
  set bookId(int id) {
    if (setting.bookId != id) {
      this.settingUpdate(setting.copyWith(bookId: id));
    }
  }

  int get chapterId => setting.chapterId;
  set chapterId(int id) {
    if (setting.chapterId != id) {
      this.settingUpdate(setting.copyWith(chapterId: id));
    }
  }

  double get fontSize => setting.fontSize;
  set fontSize(double size) {
    if (setting.fontSize != size) {
      this.settingUpdate(setting.copyWith(fontSize: size));
    }
  }

  String get searchQuery => setting.searchQuery;
  // set searchQuery(String searchQuery) => setting.searchQuery = searchQuery;
  set searchQuery(String word) {
    if (setting.searchQuery != word){
      setting.searchQuery = word;
      this.settingUpdate(setting);
    }
  }

  // NOTE: Bookmark
  int get bookmarkIndex => boxOfBookmark.toMap().values.toList().indexWhere(
    (e) => e.bookId == bookId && e.chapterId == chapterId
  );

  void bookmarkDelete(int index) => boxOfBookmark.deleteAt(index);

  void bookmarkSwitch() {
    if (bookmarkIndex >= 0){
      bookmarkDelete(bookmarkIndex);
    } else {
      boxOfBookmark.add(
        BookmarkType(
          identify: primaryId,
          date: DateTime.now(),
          bookId: bookId,
          chapterId: chapterId
        )
      );
    }
  }

  // boxOfHistory addWordHistory
  // bool hasNotHistory(String ord) => this.boxOfHistory.values.firstWhere((e) => stringCompare(e,ord),orElse: ()=>'') == null;
  // bool hasNotHistory(String ord) => this.boxOfHistory.values.firstWhere((e) => stringCompare(e,ord),orElse: () => '')!.isEmpty;

  // void bookOrder(int newIndex, int index){
  //   boxOfBook.deleteAt(index);
  //   // boxOfBook.insert(newIndex, item);
  //   boxOfBook.putAt(index, value);
  //   // boxOfBook.keyAt(index);
  // }


  // MapEntry<dynamic, PurchaseType> boxOfPurchaseExist(String id) => this.boxOfPurchase.toMap().entries.firstWhere(
  //   (e) => stringCompare(e.value.purchaseId,id),
  //   orElse: ()=> MapEntry(null,PurchaseType())
  // );

  // bool boxOfPurchaseDeleteByPurchaseId(String id) {
  //   if (id.isNotEmpty){
  //     final purchase = this.boxOfPurchaseExist(id);
  //     if (purchase.key != null){
  //       // this.boxOfHistory.deleteAt(history.key);
  //       this.boxOfPurchase.delete(purchase.key);
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  // NOTE: History
  Iterable<MapEntry<dynamic, HistoryType>> get historyIterable => boxOfHistory.toMap().entries;

  MapEntry<dynamic, HistoryType> historyExist(String ord) => historyIterable.firstWhere(
    (e) => stringCompare(e.value.word,ord),
    orElse: () => MapEntry(null,HistoryType(word: ord))
  );
  // MapEntry<dynamic, HistoryType> historyExist(String ord) => this.boxOfHistory.toMap().entries.firstWhere(
  //   (e) => stringCompare(e.value.word,ord),
  //   orElse: () => MapEntry(null,HistoryType(word: ord))
  // );

  bool historyUpdate(String ord) {
    if (ord.isNotEmpty){
      final history = this.historyExist(ord);
      history.value.date = DateTime.now();
      history.value.hit++;
      if (history.key == null){
        this.boxOfHistory.add(history.value);
      } else {
        this.boxOfHistory.put(history.key, history.value);
      }
      return true;
    }
    return false;
  }

  bool historyDeleteByWord(String ord) {
    if (ord.isNotEmpty){
      final history = this.historyExist(ord);
      if (history.key != null){
        this.boxOfHistory.delete(history.key);
        return true;
      }
    }
    return false;
  }

  Iterable<MapEntry<dynamic, HistoryType>> history() {
    if (searchQuery.isEmpty){
      return historyIterable;
    } else {
      return historyIterable.where(
        (e) => e.value.word.toLowerCase().startsWith(searchQuery.toLowerCase())
      );
    }
  }

}
