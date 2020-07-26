part of 'core.dart';

mixin _Bookmark on _Bible {

  // bool get isBookmarkMounted => this.keyBookmarkList.currentState != null && this.keyBookmarkList.currentState.mounted;
  bool get isBookmarkMounted => this.keyBookmarkList.currentState != null;

  Future<bool> addBookmarkTest() async => await readCollection().then(
    (o) async{
      int total = o.bookmark.length;
      int index = o.bookmark.indexWhere((i)=>i.bookId == this.bookId && i.chapterId==this.chapterId);
      bool hasNotBookmarked = index < 0;
      if (hasNotBookmarked) {
        if (isBookmarkMounted)this.keyBookmarkList.currentState.insertItem(total);
        o.bookmark.add(CollectionBookmark(bookId:this.bookId,chapterId: this.chapterId));
      } else {
        o.bookmark.removeAt(index);
        if (isBookmarkMounted)this.keyBookmarkList.currentState.removeItem(index, (_,__) => null);
      }
      await writeCollection();
      return hasNotBookmarked;
    }
  );

  Future<bool> removeBookmark(int index) async => await readCollection().then(
    (o) async{
      if (index >= 0) o.bookmark.removeAt(index);
      await writeCollection();
      return true;
    }
  );

  Future<bool> hasBookmark() async => await readCollection().then(
    (o) => o.bookmark.firstWhere((i) => (i.bookId == bookId && i.chapterId==chapterId), orElse: ()=>null) != null
  );

  // Future<List<CollectionBookmark>> bookmarkListView() async{
  //   // List<CollectionBookmark> bookmarkListView =
  //   print('bookmarkListView');
  //   return await this.collectionBookmarkList.then(
  //     (bookmark) async{
  //       return bookmark.map(
  //         (e) => e.toView(
  //             this.getBookList.singleWhere((i)=>i.id == e.bookId,orElse: ()=>null),
  //             // core.getBookList.listName.singleWhere((i)=>i.bookId == e.bookId,orElse: ()=>null),
  //             this.digit(e.chapterId)
  //           )
  //       ).toList();
  //     }
  //   );
  //   // return collection.bookmark.map(
  //   //   (e) => e.toView(
  //   //       this.getBookList.singleWhere((i)=>i.id == e.bookId,orElse: ()=>null),
  //   //       // core.getBookList.listName.singleWhere((i)=>i.bookId == e.bookId,orElse: ()=>null),
  //   //       this.digit(e.chapterId)
  //   //     )
  //   // ).toList();
  // }
  // List<CollectionBookmark> get bookmarkListTmp {
  //   return collection.bookmark.map(
  //     (e) => e.toView(
  //         this.getBookList.singleWhere((i)=>i.id == e.bookId,orElse: ()=>null),
  //         // core.getBookList.listName.singleWhere((i)=>i.bookId == e.bookId,orElse: ()=>null),
  //         this.digit(e.chapterId)
  //       )
  //   ).toList();
  // }

  // Future<bool> removeBookmark(int index) async => await this.collectionBookmarkList.then(
  //   (bookmark) async{
  //     if (index >= 0) bookmark.removeAt(index);
  //    await writeCollection();
  //    return true;
  //   }
  // );

  // Future<bool> hasBookmark() async => await this.collectionBookmarkList.then(
  //   (bookmark) => bookmark.firstWhere((i) => (i.bookId == bookId && i.chapterId==chapterId), orElse: ()=>null) != null
  // );

  // Future<List<Map<String, dynamic>>>  testingBookmarkssss() async {
  //   return await this.collectionBookmarkList.then((e) async{
  //    List<NAME> bookNames = await this.getNameList;
  //    return e.map((bookmark){
  //      NAME book = bookNames.firstWhere((i)=>i.bookId == bookmark.book,orElse: ()=>null);
  //     return bookmark.toView(this.digit(bookmark.chapter),book.bookName,book.testamentName);
  //    }).toList();
  //   });
  // }

  // Future<bool> hasBookmark() async => await this.collectionBookmarkList.then(
  //   (bookmark) => bookmark.firstWhere(
  //     (i) => (i.book == this.bookId && i.chapter == this.chapterId), orElse: ()=>null
  //   )
  // ).then(
  //   (bookmark) => bookmark != null
  // );
  // Future<bool> hasBookmark() async => await this.collectionBookmarkList.then(
  //   (bookmark) => bookmark.firstWhere(
  //     (i) => (i.book == this.bookId && i.chapter == this.chapterId)
  //   )
  // ).then(
  //   (test) {

  //     bool abc = test != null;
  //     print('hasBookmark $chapterId $abc $test');
  //     return abc;
  //   }
  // );

  // Future<bool> addBookmarks() async => await this.collectionBookmarkList.then(
  //   (bookmark) async{
  //     int index = bookmark.indexWhere((i)=>i.bookId == this.bookId && i.chapterId==this.chapterId);
  //     // bool hasBookmarked = index >= 0;
  //     try {
  //       bool hasNotBookmarked = index == -1;
  //       if (hasNotBookmarked) {
  //         bookmark.add(CollectionBookmark(bookId:this.bookId,chapterId: this.chapterId));
  //         if (testabc)this.keyBookmarkList.currentState.insertItem(bookmark.length+1);
  //       } else {
  //         bookmark.removeAt(index);
  //         if (testabc)this.keyBookmarkList.currentState.removeItem(index, (context, animation) => Container());
  //       }
  //       // if (testabc)this.keyBookmarkList.currentState.setState((){});
  //       // this.keyBookmarkList.currentState.
  //       await writeCollection();
  //       return hasNotBookmarked;
  //     } catch (e) {
  //       print('addBookmark $e');
  //       return false;
  //     }
  //     // bool hasNotBookmarked = index == -1;
  //     // if (hasNotBookmarked) {
  //     //   bookmark.add(CollectionBookmark(bookId:this.bookId,chapterId: this.chapterId));
  //     //   if (testabc)this.keyBookmarkList.currentState.insertItem(bookmark.length+1);
  //     // } else {
  //     //   bookmark.removeAt(index);
  //     //   if (testabc)this.keyBookmarkList.currentState.removeItem(index, (context, animation) => Container());
  //     // }
  //     // await writeCollection();
  //     // return hasNotBookmarked;
  //   }
  // );
}