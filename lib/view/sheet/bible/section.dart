import 'package:flutter/material.dart';
// import 'package:scripture/widget/button.dart';
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

  @override
  late final actualInitialSize = 0.5;
  @override
  late final actualMinSize = 0.4;
  @override
  List<Widget> slivers() {
    return <Widget>[
      /*
      ViewBarSliver(
        pinned: true,
        floating: false,
        // padding: MediaQuery.of(context).viewPadding,
        heights: const [kTextTabBarHeight],
        backgroundColor: theme.primaryColor,
        // backgroundColor: Colors.transparent,
        // padding: context.viewPaddingOf,
        overlapsBackgroundColor: theme.scaffoldBackgroundColor,
        // overlapsBorderColor: Theme.of(context).shadowColor,
        overlapsBorderColor: theme.dividerColor,
        builder: (_, vbd) {
          return ViewBarLayouts(
            data: vbd,
            left: [
              ViewButtons(
                padding: EdgeInsets.zero,
                child: const ViewLabels(
                  icon: Icons.close,
                  iconSize: 20,
                ),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
            ],
            primary: ViewBarTitle(
              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              shrinkMin: 17,
              shrinkMax: 20,
              // alignment: Alignment.lerp(
              //   const Alignment(0, 0),
              //   const Alignment(0, 0.2),
              //   vbd.snapShrink,
              // ),
              alignment: Alignment.lerp(
                const Alignment(0, 0),
                const Alignment(0, 0),
                vbd.snapShrink,
              ),
              label: lang.book('true'),
              data: vbd,
            ),
            right: [
              ViewButtons(
                padding: EdgeInsets.zero,
                child: const ViewLabels(
                  icon: Icons.ac_unit_outlined,
                  iconSize: 20,
                ),
                onPressed: () {},
              ),
            ],
          );
        },
      ),
      */
      AppBarSliver.adaptive(
        children: [
          AdaptiveAppBar(
            height: const [kTextTabBarHeight],
            builder: (_, vbd) {
              return ViewBarLayouts(
                data: vbd,
                left: [
                  ViewButtons(
                    padding: EdgeInsets.zero,
                    child: const ViewLabels(
                      icon: Icons.close,
                      iconSize: 20,
                    ),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                  ),
                ],
                primary: ViewBarTitle(
                  // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  shrinkMin: 17,
                  shrinkMax: 20,
                  // alignment: Alignment.lerp(
                  //   const Alignment(0, 0),
                  //   const Alignment(0, 0.2),
                  //   vbd.snapShrink,
                  // ),
                  alignment: Alignment.lerp(
                    const Alignment(0, 0),
                    const Alignment(0, 0),
                    vbd.snapShrink,
                  ),
                  label: lang.book('true'),
                  data: vbd,
                ),
                right: [
                  ViewButtons(
                    padding: EdgeInsets.zero,
                    child: const ViewLabels(
                      icon: Icons.ac_unit_outlined,
                      iconSize: 20,
                    ),
                    onPressed: () {},
                  ),
                ],
              );
            },
          ),
        ],
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
                // core.preference.digit(book.id.toString()),
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
              //   // core.preference.digit(book.id.toString()),
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
    bool isCurrentChapter = app.data.chapterId == chapterId;

    return ViewButtons(
      // borderRadius: const BorderRadius.all(Radius.circular(2.0)),
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(
        minWidth: 70,
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
