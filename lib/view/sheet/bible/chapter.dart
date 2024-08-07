import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';

// import 'package:lidea/launcher.dart';
// import 'package:lidea/icon.dart';
// import 'package:lidea/hive.dart';

import '../../../app.dart';

class Main extends SheetsDraggable {
  const Main({super.key});

  static String route = 'sheet-bible-chapter';
  static String label = 'Chapter';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends SheetsDraggableState<Main> {
  @override
  ViewData get viewData => App.viewData;

  // late final iso = App.core.iso;

  // @override
  // ScrollNotifier get notifier => App.scroll;

  // @override
  // bool get persistent => false;
  @override
  double get actualInitialSize => 0.5;
  @override
  double get actualMinSize => 0.3;

  // @override
  // Widget build(BuildContext context) {
  //   // return super.build(context);
  //   return ChangeNotifierProvider.value(
  //     key: const ValueKey("chapter"),
  //     value: iso,
  //     child: Consumer<ISOFilter>(
  //       builder: (context, value, child) {
  //         return super.build(context);
  //       },
  //     ),
  //   );
  // }

  Scripture get scripture => App.core.scripturePrimary;
  // int get itemCount => scripture.chapterCount;
  late final itemCount = scripture.chapterCount;

  bool get itemLimit => itemCount > 4;
  int get perItem => itemLimit ? 4 : itemCount;

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
        // overlapsBorderColor: Colors.black,
        builder: (_, vhd) {
          return ViewHeaderLayouts(
            data: vhd,
            left: [
              // ViewButtons(
              //   padding: EdgeInsets.zero,
              //   child: const ViewLabels(
              //     icon: Icons.close,
              //     iconSize: 20,
              //   ),
              //   onPressed: () {
              //     Navigator.maybePop(context);
              //   },
              // ),
              OptionButtons.cancel(
                navigator: state.navigator,
                label: App.preference.text.cancel,
              ),
            ],
            primary: ViewHeaderTitle(
              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              // shrinkMin: 17,
              // shrinkMax: 20,
              // alignment: Alignment.lerp(
              //   const Alignment(0, 0),
              //   const Alignment(0, 0.2),
              //   vhd.snapShrink,
              // ),
              // alignment: Alignment.lerp(
              //   const Alignment(0, 0),
              //   const Alignment(0, 0),
              //   vhd.snapShrink,
              // ),
              label: App.preference.text.chapter('true'),
              data: vhd,
            ),
          );
        },
      ),
      ViewSections(
        child: ViewGrids(
          // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //   // maxCrossAxisExtent: 200,
          //   // childAspectRatio: 3 / 2,
          //   // crossAxisSpacing: 20,
          //   // mainAxisSpacing: 20,
          //   // mainAxisSpacing: 0,
          //   // crossAxisSpacing: 0,
          //   // childAspectRatio: childAspectRatio,
          //   maxCrossAxisExtent: 100,
          //   mainAxisSpacing: 7,
          //   crossAxisSpacing: 7,
          //   childAspectRatio: 1.36,
          // ),
          // shrinkWrap: true,
          // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: perItem,
            childAspectRatio: 1.36,
            // mainAxisSpacing: 7,
            // crossAxisSpacing: 7,
          ),
          itemCount: itemCount,
          itemBuilder: (BuildContext ctx, index) {
            return chapterButton(index + 1);
          },
          duration: const Duration(milliseconds: 500),
          itemSnap: const ChapterItemSnap(),
        ),
      ),
      // const SliverPadding(
      //   padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
      // ),
    ];
  }

  Widget chapterButton(int chapterId) {
    // bool isCurrentChapter = false;
    bool isCurrentChapter = App.core.data.chapterId == chapterId;
    // bool isCurrentChapter = chapter.id == index;

    return ViewButtons.filled(
      // enable: !isCurrentChapter,
      // style: TextStyle(
      //   fontSize: buttonFontSize,
      // ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      // color: Theme.of(context).cardColor.withOpacity(0.05),
      color: state.theme.scaffoldBackgroundColor.withOpacity(isCurrentChapter ? 0.4 : 1),
      // showShadow: true,
      showShadow: isCurrentChapter,
      // offsetShadow: const Offset(0, 0),
      // border: Border.all(width: isCurrentChapter ? 1.0 : 0.3, color: state.theme.dividerColor),
      // border: isCurrentChapter ? Border.all(width: 1, color: state.theme.dividerColor) : null,
      child: ViewMarks(
        label: scripture.digit(chapterId),
        // labelColor: isCurrentChapter ? Colors.red : null,
        // labelStyle: TextStyle(
        //   fontSize: 22,
        //   // color: isCurrentChapter ? Theme.of(context).cardColor : null,
        // ),
        labelStyle: state.textTheme.labelLarge?.copyWith(
          color: isCurrentChapter ? Theme.of(context).cardColor : null,
        ),
      ),
      onPressed: () {
        // Navigator.pop<int>(context, index);
        // Navigator.maybePop(context, index);
        // App.core.chapterChange(chapterId: index).whenComplete(() {
        //   Navigator.maybePop(context, index);
        // });
        Navigator.of(context).maybePop({'chapter': chapterId});
      },
    );
    // return Padding(
    //   padding: const EdgeInsets.all(3.0),
    //   child: WidgetButton(
    //     // minSize: 55,
    //     // borderRadius: BorderRadius.all(Radius.circular(2.0)),
    //     padding: EdgeInsets.zero,
    //     // color: Theme.of(context).scaffoldBackgroundColor,
    //     child: Text(
    //       scripture.digit(index),
    //       style: TextStyle(
    //         color: isCurrentChapter ? Theme.of(context).highlightColor : null,
    //       ),
    //     ),
    //     onPressed: () => Navigator.pop<int>(context, index),
    //   ),
    // );
  }
}

class ChapterItemSnap extends StatelessWidget {
  const ChapterItemSnap({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ViewButtons.filled(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      color: theme.primaryColor.withOpacity(0.4),
      // showShadow: true,
      enable: false,
      child: ViewMarks(
        icon: Icons.linear_scale_rounded,
        iconColor: theme.disabledColor,
      ),
      // onPressed: () {},
    );
  }
}
