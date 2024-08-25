import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';

// import 'package:lidea/provider.dart';
// import 'package:lidea/launcher.dart';
// import 'package:lidea/icon.dart';
// import 'package:lidea/hive.dart';

import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'sheet-bible-section';
  static String label = 'Section';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends DraggableSheets<Main> {
  @override
  late final Core app = App.core;
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
      // body: NestedScrollView(
      //   // controller: scrollController,
      //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      //     // These are the slivers that show up in the "outer" scroll view.
      //     return <Widget>[
      //       SliverOverlapAbsorber(
      //         // This widget takes the overlapping behavior of the SliverAppBar,
      //         // and redirects it to the SliverOverlapInjector below. If it is
      //         // missing, then it is possible for the nested "inner" scroll view
      //         // below to end up under the SliverAppBar even when the inner
      //         // scroll view thinks it has not been scrolled.
      //         // This is not necessary if the "headerSliverBuilder" only builds
      //         // widgets that do not overlap the next sliver.
      //         handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      //         sliver: SliverAppBar(
      //           title: Text('Books  $innerBoxIsScrolled'), // This is the title in the app bar.
      //           pinned: true,
      //           // expandedHeight: 150.0,
      //           // The "forceElevated" property causes the SliverAppBar to show
      //           // a shadow. The "innerBoxIsScrolled" parameter is true when the
      //           // inner scroll view is scrolled beyond its "zero" point, i.e.
      //           // when it appears to be scrolled below the SliverAppBar.
      //           // Without this, there are cases where the shadow would appear
      //           // or not appear inappropriately, because the SliverAppBar is
      //           // not actually aware of the precise position of the inner
      //           // scroll views.
      //           forceElevated: innerBoxIsScrolled,
      //         ),
      //       ),

      //       // SliverAppBar(
      //       //   title: Text('Books $innerBoxIsScrolled'),
      //       //   pinned: true,
      //       //   forceElevated: innerBoxIsScrolled,
      //       // ),
      //     ];
      //   },
      //   body: child!,
      // ),
      body: child!,
    );
  }

  @override
  List<Widget> slivers() {
    return <Widget>[
      // ViewHeaderSliver(
      //   pinned: true,
      //   floating: false,
      //   // padding: MediaQuery.of(context).viewPadding,
      //   heights: const [kTextTabBarHeight],
      //   backgroundColor: state.theme.primaryColor,
      //   // backgroundColor: Colors.transparent,
      //   // padding: state.fromContext.viewPadding,
      //   overlapsBackgroundColor: state.theme.scaffoldBackgroundColor,
      //   // overlapsBorderColor: Theme.of(context).shadowColor,
      //   overlapsBorderColor: state.theme.dividerColor,
      //   builder: (_, vhd) {
      //     return ViewHeaderLayoutStack(
      //       data: vhd,
      //       // left: const [
      //       //   // BackButton(),
      //       // ],
      //       primary: ViewHeaderTitle(
      //         // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      //         shrinkMin: 17,
      //         shrinkMax: 20,
      //         // alignment: Alignment.lerp(
      //         //   const Alignment(0, 0),
      //         //   const Alignment(0, 0.2),
      //         //   vhd.snapShrink,
      //         // ),
      //         alignment: Alignment.lerp(
      //           const Alignment(0, 0),
      //           const Alignment(0, 0),
      //           vhd.snapShrink,
      //         ),
      //         label: App.preference.text.book('true'),
      //         data: vhd,
      //       ),
      //       // secondary: TabBar(
      //       //   controller: _tabController,
      //       //   labelStyle: TextStyle(
      //       //     fontFamily: 'Raleway',
      //       //     fontSize: 17,
      //       //     fontWeight: FontWeight.w400,
      //       //     color: Theme.of(context).colorScheme.background,
      //       //   ),
      //       //   indicatorColor: Theme.of(context).hintColor,
      //       //   // labelColor: Theme.of(context).buttonColor,
      //       //   unselectedLabelColor: Theme.of(context).dividerColor,
      //       //   tabs: const [
      //       //     Tab(text: "Menu"),
      //       //     Tab(text: "About"),
      //       //     Tab(text: "Contact"),
      //       //   ],
      //       // ),
      //     );
      //   },
      // ),
      // const SliverPadding(padding: EdgeInsets.all(50)),
      SliverMainAxisGroup(
        slivers: <Widget>[
          SliverAppBar(
            title: const Text('Old Testament'),
            titleTextStyle: Theme.of(context).textTheme.labelMedium,
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
            titleTextStyle: Theme.of(context).textTheme.labelMedium,
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
            titleTextStyle: Theme.of(context).textTheme.labelMedium,
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
              textColor: state.theme.hintColor,
              // selectedTileColor: Colors.blue,
              // selectedTileColor: state.theme.cardColor,
              // selectedColor: state.theme.dividerColor,
              // contentPadding: EdgeInsets.zero,
              // horizontalTitleGap: 0,
              leading: Text(
                // App.preference.digit(book.id.toString()),
                scripture.digit(book.info.id),
                // book.id.toString(),
                textAlign: TextAlign.center,
                // style: TextStyle(
                //   color: state.theme.primaryColorDark,
                // ),
                style: state.textTheme.titleSmall,
              ),

              title: Text(
                book.info.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
                ),
              ),
              // trailing: Text(
              //   // App.preference.digit(book.id.toString()),
              //   // book.chapterCount.toString(),
              //   scripture.digit(book.chapterCount),
              //   textAlign: TextAlign.center,
              //   // style: TextStyle(
              //   //   color: state.theme.primaryColorDark,
              //   // ),
              //   style: state.textTheme.titleSmall,
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
        //   fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
        //   color: isCurrentChapter ? Theme.of(context).highlightColor : null,
        // ),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isCurrentChapter ? Theme.of(context).highlightColor : null,
            ),
      ),
    );
  }
}
