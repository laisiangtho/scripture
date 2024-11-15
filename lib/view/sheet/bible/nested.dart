import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';

// import 'package:lidea/provider.dart';
// import 'package:lidea/launcher.dart';
// import 'package:lidea/icon.dart';
// import 'package:lidea/hive.dart';

import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _State();
}

class _State extends SheetStates<Main> {
  Scripture get scripture => app.scripturePrimary;

  List<OfBook> get books => scripture.bookList;

  final List<int> expandedList = [];

  // @override
  // bool get persistent => false;

  @override
  late final actualInitialSize = 0.8;
  @override
  late final actualMinSize = 0.8;

  @override
  Widget draggableDecoration({Widget? child}) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // backgroundColor: Colors.white,
      appBar: PreferredSize(
        // kToolbarHeight kTextTabBarHeight
        preferredSize: const Size.fromHeight(kToolbarHeight), // here the desired height
        child: AppBar(
          // forceMaterialTransparency: true,
          // backgroundColor: Colors.red,
          // foregroundColor: Colors.blue,
          leading: ViewButtons(
            // color: Colors.red,
            padding: EdgeInsets.zero,
            child: const ViewLabels(
              icon: Icons.arrow_back_ios_new,
              label: 'Back',
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          leadingWidth: 100,
          elevation: 1,
          title: const Text("Books"),
        ),
      ),

      body: child!,
    );
  }

  @override
  List<Widget> slivers() {
    return <Widget>[
      SliverMainAxisGroup(
        slivers: <Widget>[
          SliverAppBar(
            title: const Text('Old Testament'),
            titleTextStyle: context.style.labelMedium,
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 30.0,
          ),
          // SliverList.builder(
          //   itemBuilder: (BuildContext context, int index) {
          //     return Container(
          //       color: index.isEven ? Colors.amber[300] : Colors.blue[300],
          //       height: 100.0,
          //       child: Center(
          //         child: Text(
          //           'Item $index',
          //           style: const TextStyle(fontSize: 24),
          //         ),
          //       ),
          //     );
          //   },
          //   itemCount: 2,
          // ),
          ViewLists(
            // NOTE: referred to ViewScrollBehavior
            // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            duration: const Duration(milliseconds: 50),
            itemBuilder: (BuildContext _, int index) {
              // final index = 39 + i;
              return bookItem(index, books.elementAt(index));
              // return Text('index $id $index');
            },
            // itemSeparator: (BuildContext _, int index) {
            //   return const ViewSectionDivider(
            //     primary: false,
            //     padding: EdgeInsets.symmetric(horizontal: 15),
            //   );
            // },
            itemSnap: const ListTile(
              minVerticalPadding: 16,
              enabled: false,
              title: Text('...'),
            ),
            itemCount: 39,
          ),
        ],
      ),
      SliverMainAxisGroup(
        slivers: <Widget>[
          SliverAppBar(
            title: const Text('New Testament'),
            titleTextStyle: context.style.labelMedium,
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 30.0,
          ),
          ViewLists(
            // NOTE: referred to ViewScrollBehavior
            // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            duration: const Duration(milliseconds: 50),
            itemBuilder: (BuildContext _, int i) {
              final index = 39 + i;
              return bookItem(index, books.elementAt(index));
              // return Text('index $id $index');
            },
            // itemSeparator: (BuildContext _, int index) {
            //   return const ViewSectionDivider(
            //     primary: false,
            //     padding: EdgeInsets.symmetric(horizontal: 15),
            //   );
            // },
            itemSnap: const ListTile(
              minVerticalPadding: 16,
              enabled: false,
              title: Text('...'),
            ),
            itemCount: books.length - 39,
          ),
        ],
      ),
      SliverMainAxisGroup(
        slivers: <Widget>[
          SliverAppBar(
            title: const Text('New Testament'),
            titleTextStyle: context.style.labelMedium,
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 30.0,
          ),
          ViewLists(
            // NOTE: referred to ViewScrollBehavior
            // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            duration: const Duration(milliseconds: 50),
            itemBuilder: (BuildContext _, int index) {
              return Text('index  $index');
            },

            itemCount: 7,
          ),
        ],
      ),
      // ViewSection(
      //   child: ViewListBuilder(
      //     primary: false,
      //     // NOTE: referred to ViewScrollBehavior
      //     // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      //     duration: const Duration(milliseconds: 50),
      //     itemBuilder: (BuildContext _, int index) {
      //       return bookItem(index, books.elementAt(index));
      //     },
      //     // itemSeparator: (BuildContext _, int index) {
      //     //   return const ViewSectionDivider(
      //     //     primary: false,
      //     //     padding: EdgeInsets.symmetric(horizontal: 15),
      //     //   );
      //     // },
      //     itemSnap: (BuildContext _, int index) {
      //       return const ListTile(
      //         minVerticalPadding: 16,
      //         enabled: false,
      //         title: Text('...'),
      //       );
      //     },
      //     itemCount: books.length,
      //   ),
      // ),
      const SliverPadding(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
      ),
    ];
  }

  Widget bookItem(int index, OfBook book) {
    bool isCurrentBook = app.data.bookId == book.info.id;

    bool isExpanded = expandedList.where((e) => e == index).isNotEmpty;
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: isExpanded ? 500 : 200),
      elevation: 0,
      dividerColor: Colors.red,
      expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      materialGapSize: 0,
      children: [
        ExpansionPanel(
          body: chapterList(isExpanded, book),
          // backgroundColor: isCurrentBook ? Theme.of(context).disabledColor : Colors.transparent,
          // backgroundColor: Colors.transparent,

          // backgroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Colors.transparent,
          // canTapOnHeader: isCurrentBook,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              onTap: () {
                // Navigator.pop<Map<String, int>>(context, {'book': book.id});
                // Navigator.maybePop<Map<String, int>>(context, {'book': book.id});

                Navigator.maybePop(context, {'book': book.info.id});
              },
              // alignment: Alignment.centerLeft,
              // enabled: !isCurrentBook,
              selected: isCurrentBook,
              textColor: theme.hintColor,
              // selectedTileColor: Colors.blue,
              // selectedTileColor: theme.cardColor,
              // selectedColor: theme.dividerColor,
              // contentPadding: EdgeInsets.zero,
              // horizontalTitleGap: 0,
              leading: Text(
                // App.preference.digit(book.id.toString()),
                scripture.digit(book.info.id),
                // book.id.toString(),
                textAlign: TextAlign.center,
                // style: TextStyle(
                //   color: theme.primaryColorDark,
                // ),
                style: style.titleSmall,
              ),

              title: Text(
                book.info.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: context.style.labelLarge!.fontSize,
                ),
              ),
              // trailing: Text(
              //   // App.preference.digit(book.id.toString()),
              //   // book.chapterCount.toString(),
              //   scripture.digit(book.chapterCount),
              //   textAlign: TextAlign.center,
              //   // style: TextStyle(
              //   //   color: theme.primaryColorDark,
              //   // ),
              //   style: style.titleSmall,
              // ),
            );
          },
          isExpanded: isExpanded,
        )
      ],
      expansionCallback: (int item, bool status) {
        // final abc = expandedList.where((e) => e == index).length;
        if (status) {
          expandedList.add(index);
        } else {
          expandedList.remove(index);
        }
        setState(() {
          // itemData[index].expanded = !itemData[index].expanded;
        });
      },
    );
  }

  Widget chapterList(bool isExpanded, OfBook book) {
    if (!isExpanded) return const SizedBox();
    // List<Widget> abc = isExpanded == false
    //     ? []
    //     : List<Widget>.generate(book.entries.first.value, (index) => chapterButton(1, index + 1));

    return LayoutBuilder(
      builder: (_, constraints) {
        return Wrap(
          // alignment: WrapAlignment.center,
          // spacing: 2.0,
          // runSpacing: 2.0,
          spacing: 7,
          runSpacing: 7,
          // crossAxisAlignment: WrapCrossAlignment.center,
          // textDirection: TextDirection.ltr,
          children: List<Widget>.generate(
            book.totalChapter,
            (index) => chapterButton(book.info.id, index + 1),
          ),
        );
      },
    );
    // return Wrap(
    //   alignment: WrapAlignment.center,
    //   spacing: 2.0,
    //   runSpacing: 2.0,
    //   // spacing: 0,
    //   // runSpacing: 1,
    //   crossAxisAlignment: WrapCrossAlignment.center,
    //   // textDirection: TextDirection.ltr,
    //   children: List<Widget>.generate(
    //     book.chapterCount,
    //     (index) => chapterButton(book.id, index + 1),
    //   ),
    // );
  }

  Widget chapterButton(int bookId, int chapterId) {
    // bool isCurrentChapter = 2 == index;
    bool isCurrentChapter = app.data.chapterId == chapterId;

    return ViewButtons(
      // borderRadius: const BorderRadius.all(Radius.circular(2.0)),
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(
        minWidth: 60,
        // minHeight: 70,
      ),
      // color: Colors.red,
      // child: ViewMarks(
      //   // label: scripture.digit(chapterId),
      //   label: chapterId.toString(),
      //   labelStyle: TextStyle(
      //     color: isCurrentChapter ? Theme.of(context).highlightColor : null,
      //   ),
      // ),
      // enable: !isCurrentChapter,
      onPressed: () {
        Navigator.maybePop(context, {'book': bookId, 'chapter': chapterId});
      },
      child: Text(
        // chapterId.toString(),
        scripture.digit(chapterId),
        textAlign: TextAlign.center,
        // style: TextStyle(
        //   fontSize: context.style.labelLarge!.fontSize,
        //   color: isCurrentChapter ? Theme.of(context).highlightColor : null,
        // ),
        style: context.style.labelLarge?.copyWith(
          color: isCurrentChapter ? Theme.of(context).highlightColor : null,
        ),
      ),
    );
  }
}
