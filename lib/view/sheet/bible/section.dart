import 'package:flutter/material.dart';
// import 'package:scripture/widget/button.dart';
// import 'package:flutter/gestures.dart';

// import 'package:lidea/provider.dart';
// import 'package:lidea/launcher.dart';
// import 'package:lidea/icon.dart';
// import 'package:lidea/hive.dart';

import '../../../app.dart';

class Main extends SheetsDraggable {
  const Main({super.key});

  static String route = 'sheet-bible-section';
  static String label = 'Section';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends SheetsDraggableState<Main> {
  Scripture get scripture => App.core.scripturePrimary;

  List<OfBook> get books => scripture.bookList;

  final List<int> expandedList = [];

  @override
  ViewData get viewData => App.viewData;

  // @override
  // ScrollNotifier get notifier => App.scroll;

  // @override
  // bool get persistent => false;
  @override
  double get actualInitialSize => 0.5;
  @override
  double get actualMinSize => 0.4;

  @override
  List<Widget> slivers() {
    return <Widget>[
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        // padding: MediaQuery.of(context).viewPadding,
        heights: const [kTextTabBarHeight],
        backgroundColor: state.theme.primaryColor,
        // backgroundColor: Colors.transparent,
        // padding: state.fromContext.viewPadding,
        overlapsBackgroundColor: state.theme.scaffoldBackgroundColor,
        // overlapsBorderColor: Theme.of(context).shadowColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: (_, vhd) {
          return ViewHeaderLayouts(
            data: vhd,
            left: [
              ViewButton(
                padding: EdgeInsets.zero,
                child: const ViewLabel(
                  icon: Icons.close,
                  iconSize: 20,
                ),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
            ],
            primary: ViewHeaderTitle(
              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              shrinkMin: 17,
              shrinkMax: 20,
              // alignment: Alignment.lerp(
              //   const Alignment(0, 0),
              //   const Alignment(0, 0.2),
              //   vhd.snapShrink,
              // ),
              alignment: Alignment.lerp(
                const Alignment(0, 0),
                const Alignment(0, 0),
                vhd.snapShrink,
              ),
              label: App.preference.text.book('true'),
              data: vhd,
            ),
            right: [
              ViewButton(
                padding: EdgeInsets.zero,
                child: const ViewLabel(
                  icon: Icons.ac_unit_outlined,
                  iconSize: 20,
                ),
                onPressed: () async {
                  /// TODO: testing
                  Navigator.pushNamed(context, 'test-group', arguments: {'abc': true});

                  // App.route.
                  // App.route.showSheetModal(
                  //   context: context,
                  //   name: 'sheet-bible-section/sheet-bible-tmp',
                  // );
                  // App.route.pushNamed('sheet-bible-section/sheet-bible-tmp');
                  // Navigator.of(context).pushNamed('sheet-bible-section/sheet-bible-tmp');
                  // App.route.pushNamed('read/sheet-bible-tmp');

                  // App.route.showSheetModal(
                  //   showDragHandle: true,
                  //   useRootNavigator: true,
                  //   context: context,
                  //   name: 'sheet-bible-chapter',
                  // );
                  // final backButton = await Navigator.of(context).push<bool?>(
                  //   PageRouteBuilder(
                  //     // opaque: false,
                  //     // barrierDismissible: true,
                  //     pageBuilder: (_, __, ___) => const ChapterWidget(),
                  //   ),
                  // );

                  // if (backButton == null || backButton == false) {
                  //   if (mounted) Navigator.of(context).pop();
                  // }
                },
              ),
            ],
          );
        },
      ),
      ViewSections(
        sliver: true,
        child: ViewLists(
          // NOTE: referred to ViewScrollBehavior
          // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          duration: const Duration(milliseconds: 50),
          itemBuilder: (BuildContext _, int index) {
            return bookItem(index, books.elementAt(index));
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
          itemCount: books.length,
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
      ),
    ];
  }

  Widget bookItem(int index, OfBook book) {
    bool isCurrentBook = App.core.data.bookId == book.info.id;

    bool isExpanded = expandedList.where((e) => e == index).isNotEmpty;
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: isExpanded ? 500 : 200),
      elevation: 0,
      dividerColor: Colors.red,
      expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      materialGapSize: 0,
      children: [
        ExpansionPanel(
          // body: chapterList(isExpanded, book),
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              // return Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: List<Widget>.generate(4, (int index) {
              //     return Radio<int>(
              //       value: index,
              //       groupValue: selectedRadio,
              //       onChanged: (int? value) {
              //         setState(() => selectedRadio = value);
              //       },
              //     );
              //   }),
              // );
              return chapterList(isExpanded, book);
            },
          ),
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
                // debugPrint('Navigator ${book.id}');
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
        growable: false,
      ),
    );
  }

  Widget chapterButton(int bookId, int chapterId) {
    // bool isCurrentChapter = 2 == index;
    bool isCurrentChapter = App.core.data.chapterId == chapterId;

    return ViewButton(
      // borderRadius: const BorderRadius.all(Radius.circular(2.0)),
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(
        minWidth: 70,
        // minHeight: 70,
      ),
      // color: Colors.red,
      // child: ViewMark(
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

class ChapterWidget extends StatefulWidget {
  const ChapterWidget({super.key});

  @override
  State<ChapterWidget> createState() => _ChapterWidgetState();
}

class _ChapterWidgetState extends State<ChapterWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        elevation: 1,
        title: const Text("Tmp"),
      ),
      body: ListView.builder(
        // key: ValueKey('value-$msg'),
        // key: PageStorageKey('value-$msg'),

        key: const PageStorageKey('Tmp'),
        primary: false,
        // shrinkWrap: true,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text('Tmp: $index'),
          );
        },
        itemCount: 66,
      ),
    );
  }
}
