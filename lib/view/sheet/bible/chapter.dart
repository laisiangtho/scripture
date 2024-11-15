import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';

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
  @override
  late final actualInitialSize = 0.5;
  @override
  late final actualMinSize = 0.3;

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

  Scripture get scripture => app.scripturePrimary;
  // int get itemCount => scripture.chapterCount;
  late final itemCount = scripture.chapterCount;

  bool get itemLimit => itemCount > 4;
  int get perItem => itemLimit ? 4 : itemCount;

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
        // overlapsBorderColor: Colors.black,
        builder: (_, vbd) {
          return ViewBarLayouts(
            data: vbd,
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
                label: lang.cancel,
              ),
            ],
            primary: ViewBarTitle(
              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              // shrinkMin: 17,
              // shrinkMax: 20,
              // alignment: Alignment.lerp(
              //   const Alignment(0, 0),
              //   const Alignment(0, 0.2),
              //   vbd.snapShrink,
              // ),
              // alignment: Alignment.lerp(
              //   const Alignment(0, 0),
              //   const Alignment(0, 0),
              //   vbd.snapShrink,
              // ),
              label: lang.chapter('true'),
              data: vbd,
            ),
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
                    label: lang.cancel,
                  ),
                ],
                primary: ViewBarTitle(
                  // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  // shrinkMin: 17,
                  // shrinkMax: 20,
                  // alignment: Alignment.lerp(
                  //   const Alignment(0, 0),
                  //   const Alignment(0, 0.2),
                  //   vbd.snapShrink,
                  // ),
                  // alignment: Alignment.lerp(
                  //   const Alignment(0, 0),
                  //   const Alignment(0, 0),
                  //   vbd.snapShrink,
                  // ),
                  label: lang.chapter('true'),
                  data: vbd,
                ),
              );
            },
          ),
        ],
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
    bool isCurrentChapter = app.data.chapterId == chapterId;
    // bool isCurrentChapter = chapter.id == index;

    return ViewButtons.filled(
      // enable: !isCurrentChapter,
      // style: TextStyle(
      //   fontSize: buttonFontSize,
      // ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      // color: Theme.of(context).cardColor.withOpacity(0.05),
      color: theme.scaffoldBackgroundColor.withOpacity(isCurrentChapter ? 0.4 : 1),
      // showShadow: true,
      showShadow: isCurrentChapter,
      // offsetShadow: const Offset(0, 0),
      // border: Border.all(width: isCurrentChapter ? 1.0 : 0.3, color: theme.dividerColor),
      // border: isCurrentChapter ? Border.all(width: 1, color: theme.dividerColor) : null,
      child: ViewMarks(
        label: scripture.digit(chapterId),
        // labelColor: isCurrentChapter ? Colors.red : null,
        // labelStyle: TextStyle(
        //   fontSize: 22,
        //   // color: isCurrentChapter ? Theme.of(context).cardColor : null,
        // ),
        labelStyle: style.labelLarge?.copyWith(
          color: isCurrentChapter ? Theme.of(context).cardColor : null,
        ),
      ),
      onPressed: () {
        // Navigator.pop<int>(context, index);
        // Navigator.maybePop(context, index);
        // core.chapterChange(chapterId: index).whenComplete(() {
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
    final tpl = Theme.of(context);
    return ViewButtons.filled(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      color: tpl.primaryColor.withOpacity(0.4),
      // showShadow: true,
      enable: false,
      child: ViewMarks(
        icon: Icons.linear_scale_rounded,
        iconColor: tpl.disabledColor,
      ),
      // onPressed: () {},
    );
  }
}
