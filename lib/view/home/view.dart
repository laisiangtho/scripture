part of 'main.dart';

class _View extends _State with _Bar, _Refresh, _Modal {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      key: widget.key,
      controller: scrollController,
      child: Selector<Core, bool>(
        selector: (_, e) => e.nodeFocus,
        builder: (BuildContext context, bool focus, Widget? child) => body()
      )
    );
  }

  Widget body() {
    return CustomScrollView(
      // primary: true,
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      // semanticChildCount: 3,
      slivers: <Widget>[
        bar(),
        // _barContext(true),
        refresh(),
        // new DemoView(core: core),
        bookListSelector(),
        // SliverToBoxAdapter(
        //   child: abcd(),
        // ),
        new SliverToBoxAdapter(
          child: buildMode()
        )

      ]
    );
  }

  Widget bookListSelector() {
    // return Selector<Core,Box<BookType>>(
    //   selector: (_, e) => e.collection.boxOfBook,
    //   // selector: (_, e) => e.collection.boxOfBook.toMap().values.toList(),
    //   // selector: (_, e) => e.collection.boxOfBook.toMap().entries.toList(),
    //   builder: (BuildContext context, Box<BookType> items, Widget? child) => bookList(items)
    // );

    return ValueListenableBuilder(
      valueListenable: core.collection.boxOfBook.listenable(),
      builder: (BuildContext context, Box<BookType> items, Widget? child) => bookList(items)
    );
  }

  Widget bookList(Box<BookType> box){
    // final itemList = box.toMap().entries.toList();
    // itemList.sort((a, b) => a.value.order.compareTo(b.value.order));
    // debugPrint('box ${box.length}');
    // final abc = box.getAt(1);
    return SliverReorderableList(
      key: _reorderablelistKey,
      itemBuilder:(BuildContext context, int index) => bookContainer(index, box.getAt(index)!),
      itemCount:box.length,
      onReorder: (int oldIndex, int newIndex) {

        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        if (oldIndex == newIndex) return;

        // final oldItem = box.getAt(oldIndex)!.copyWith(order:oldIndex);
        // final newItem = box.getAt(newIndex)!.copyWith(order:newIndex);
        // box.putAt(oldIndex, newItem);
        // box.putAt(newIndex, oldItem);

        final itemList = box.toMap().values.toList();
        itemList.insert(newIndex, itemList.removeAt(oldIndex));
        box.putAll(itemList.asMap());
      },
    );
    // return new SliverList(
    //   delegate: SliverChildBuilderDelegate(
    //     (BuildContext context, int index) => bookContainer(index, box.elementAt(index)),
    //     childCount: box.length,
    //     // addAutomaticKeepAlives: true
    //   ),
    // );
  }

  // Widget bookContainer(int index, MapEntry<dynamic, BookType> book){
  //   return Card(
  //     key: Key('$index'),
  //     child: ListTile(
  //       // title: Text('Item ${_items[index]}'),
  //       title: Text(' $index  ${book.value.order} ${book.value.name} '),
  //       trailing: ReorderableDragStartListener(
  //         child: Icon(Icons.short_text_rounded),
  //         index: index,
  //       ),
  //     ),
  //   );
  // }

  Widget bookContainer(int index, BookType book){
    return SlideMenu(
      key: Key('$index'),
      child: Card(
        // key: Key('$index'),
        // child: ListTile(
        //   // title: Text('Item ${_items[index]}'),
        //   title: Text(' ${book.update} ${book.name} '),
        //   trailing: ReorderableDragStartListener(
        //     child: Icon(Icons.short_text_rounded),
        //     index: index,
        //   ),
        //   onTap: ()=>showModal(book),
        // ),
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.white70, width: 1),
          // borderRadius: BorderRadius.circular(10),
          borderRadius: BorderRadius.all(Radius.circular(7.0))
          // borderRadius: new BorderRadius.all(
          //   Radius.elliptical(7, 100)
          // ),
        ),
        child: bookItem(index, book)
      ),
      right: <Widget>[
        Tooltip(
          message: 'More',
          child: new CupertinoButton(
            // color: Colors.blue,
            child: new Icon(
              LaiSiangthoIcon.dot_horiz,color: Colors.grey,
            ),
            onPressed: () => showModal(book)
          ),
        )
      ]
    );
  }

  Widget bookItem(int index, BookType book){
    bool isAvailable = book.available > 0;
    // bool isPrimary = book.identify == core.primaryId;
    bool isPrimary = book.identify == '';
    return new ListTile(
      // dense: true,
      // selected: isPrimary,
      enabled: true,
      title: Padding(
        padding: EdgeInsets.only(bottom: 6, top: 0),
        child: Text(
          book.name, maxLines: 1, overflow: TextOverflow.ellipsis,
          semanticsLabel: book.name,
          style: Theme.of(context).textTheme.headline5!.copyWith(
            fontSize: 20,
            fontWeight: isAvailable?FontWeight.w400:FontWeight.w300,
            // color: isAvailable?Colors.black:Colors.grey,
            height: book.langName=='my'?1.0:1.2
          )
          // style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 18,color: isAvailable?Colors.black:Colors.grey)
        ),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Container(
            // padding: EdgeInsets.all(5),
            // width: 50.0,
            constraints: BoxConstraints(
              minWidth: 35.0,
            ),
            padding: EdgeInsets.symmetric(vertical:2),
            // margin: EdgeInsets.only(top:5),
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.all(Radius.circular(3)),
              // color: isAvailable?isCurrent?Colors.grey:Colors.grey[400]:Colors.grey[200]
              color: isAvailable?isPrimary?Colors.black54:Colors.grey:Colors.grey[200]
              // isCurrent?Colors.blue[300]:
            ),
            child: Text(
              book.langCode.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color:isAvailable?Colors.white:Colors.grey[400],
                fontSize: 12,
                height: 1.4
              )
              // style: Theme.of(context).textTheme.caption.copyWith(
              //   color:isAvailable?Colors.white:Colors.grey[400],
              //   // fontSize: 10,
              //   // height: 13
              // )
            )
          ),
          Divider(),
          Text(' '+book.shortname,style: Theme.of(context).textTheme.subtitle2!.copyWith(
              fontSize: 14,
              height: book.langName=='my'?1.0:1.0
            )
          )
        ]
      ),
      trailing: AnimatedSwitcher(
        duration: const Duration(milliseconds:400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: this.isSorting?ReorderableDragStartListener(
          // child: Icon(Icons.short_text_rounded),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: Icon(
              LaiSiangthoIcon.drag_handle,
              color: Colors.red,
              size: 25.0
            ),
          ),
          index: index,
        ):
        Padding(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 3),
          child: Text(book.year.toString(),
            style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 18,color: isAvailable?Colors.black:Colors.grey[400],
              // fontWeight: FontWeight.w300,
            )
          ),
        )
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   // crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: <Widget>[
        //     Text(book.year.toString(),
        //       style: DefaultTextStyle.of(context).style.copyWith(
        //         fontSize: 17,color: isAvailable?Colors.black:Colors.grey[400],
        //         // fontWeight: FontWeight.w300,
        //       )
        //     ),
        //     // Icon(LaiSiangthoIcon.right_open,color: isAvailable?Colors.grey:Colors.grey[200], size: 25),
        //   ]
        // )
      ),
      onTap:()=>isAvailable?toBible(book):showModal(book)
      // onTap:()=>showModal(book)
    );

  }

  Widget buildMode() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7.0))
      ),
      elevation: 2,

      // child: Text('abc'),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Semantics(
                label: "Switch theme mode",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb,size:20),
                    Text('Switch theme',
                      style: TextStyle(
                        fontSize: 20
                      )
                    )
                  ],
                ),
              )
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ThemeMode.values.map<Widget>((e){
                  bool active = IdeaTheme.of(context).themeMode == e;
                  // IdeaTheme.update(context,IdeaTheme.of(context).copyWith(themeMode: ThemeMode.system));
                  return Semantics(
                    label: "Switch to",
                    selected: active,
                    child: CupertinoButton(
                      borderRadius: new BorderRadius.circular(30.0),
                      padding: EdgeInsets.symmetric(vertical:5, horizontal:10),
                      // minSize: 20,
                      // color: Theme.of(context).primaryColorDark,
                      child: Text(
                        themeName[e.index],
                        semanticsLabel: themeName[e.index],
                      ),
                      onPressed: active?null:()=>IdeaTheme.update(context,IdeaTheme.of(context).copyWith(themeMode: e))
                    ),
                  );
                }).toList()
              )
            )
          ]
        ),
      )
    );
  }
}
