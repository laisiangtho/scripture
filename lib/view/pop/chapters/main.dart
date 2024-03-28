import 'package:flutter/material.dart';
import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});
  static String route = 'pop-chapters';
  static String label = 'Chapters';
  static IconData icon = Icons.opacity_outlined;

  @override
  State<Main> createState() => _MainState();
}

// TickerProviderStateMixin SingleTickerProviderStateMixin
class _MainState extends StateAbstract<Main> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 700),
    reverseDuration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticInOut,
  );

  @override
  void initState() {
    super.initState();
    _animationController.forward();
    // Future.microtask(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  late final RenderBox render = args!['render'];
  late final Size sizeOfRender = render.size;
  late final Offset positionOfRender = render.localToGlobal(Offset.zero);
  late final Size sizeOfContext = MediaQuery.of(context).size;

  double get hzSpace => 20;
  // double get maxWidth => 414;
  // double get maxWidth => 250;
  double get maxWidth {
    switch (itemCount) {
      case 1:
        return 250;
      case 2:
        return 300;
      case 3:
        return 300;

      default:
        return 414;
    }
  }

  double get hzSize => (sizeOfContext.width - maxWidth) / 2;
  bool get _hasMax => sizeOfContext.width > maxWidth;
  double get left => _hasMax ? hzSize : hzSpace;
  double get right => _hasMax ? hzSize : hzSpace;
  double get top => positionOfRender.dy + sizeOfRender.height + 10;

  double get arrowWidth => 10;
  double get arrowHeight => 12;

  // late final itemCount = App.core.data.randomNumber(150);
  // late final itemCount = 50;
  // int get itemCount => 50;

  Scripture get scripture => App.core.scripturePrimary;
  // int get itemCount => scripture.chapterCount;
  late final itemCount = scripture.chapterCount;

  bool get itemLimit => itemCount > 4;
  int get perItem => itemLimit ? 4 : itemCount;

  // double get defaultHeight => (itemCount / perItem).ceilToDouble() * (itemLimit ? 75 : 110);
  // double get maxHeight => defaultHeight * 0.4;

  double get defaultHeight => (itemCount / perItem).ceilToDouble() * 72;
  double get maxHeight => sizeOfContext.height * 0.72;
  // NOTE:
  // double get defaultHeight => (itemCount / perItem).ceilToDouble() * 75;
  // double get maxHeight => sizeOfContext.height * 0.75;

  double get height {
    switch (itemCount) {
      case 1:
        return 190;
      case 2:
        return 115;
      case 3:
        return 80;

      default:
        return defaultHeight > maxHeight ? maxHeight : defaultHeight;
    }
  }

  double? get buttonFontSize {
    // Theme.of(context).textTheme.labelLarge!.fontSize
    // return 0;
    final textSize = state.textTheme.labelLarge!.fontSize!;
    switch (itemCount) {
      case 1:
        return textSize + 16;
      case 2:
        return textSize + 8;
      case 3:
        return textSize + 3;

      default:
        return textSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewPopupShapedArrow(
      left: left,
      right: right,
      top: top,
      height: height,
      arrow: positionOfRender.dx - left + (sizeOfRender.width * 0.18),
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
      backgroundColor: Theme.of(context).colorScheme.background,
      // child: SizedBox(
      //   height: height,
      //   child: view(),
      // ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 75),
        child: SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          axisAlignment: -1,
          child: SizedBox(
            height: height,
            child: view(),
          ),
        ),
      ),
    );
  }

  Widget view() {
    return GridTile(
      header: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.background,
              blurRadius: 9,
              spreadRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
      footer: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.background,
              blurRadius: 9,
              spreadRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
      // child: GridView.count(
      //   padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
      //   // mainAxisSpacing: 0,
      //   // crossAxisSpacing: 0,
      //   // childAspectRatio: childAspectRatio,
      //   mainAxisSpacing: 7,
      //   crossAxisSpacing: 7,
      //   childAspectRatio: 1.36,
      //   crossAxisCount: perItem,
      //   physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      //   children: List<Widget>.generate(
      //     itemCount,
      //     (index) => chapterButton(index + 1),
      //   ),
      // ),
      child: GridView.builder(
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
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
      ),
    );
  }

  Widget chapterButton(int index) {
    // bool isCurrentChapter = false;
    bool isCurrentChapter = App.core.data.chapterId == index;
    // bool isCurrentChapter = chapter.id == index;

    return ViewButton(
      enable: !isCurrentChapter,
      style: TextStyle(fontSize: buttonFontSize),
      child: ViewMark(
        label: scripture.digit(index),
        // labelStyle: TextStyle(
        //   color: isCurrentChapter ? Theme.of(context).highlightColor : null,
        // ),
      ),
      onPressed: () {
        // Navigator.pop<int>(context, index);
        // Navigator.maybePop(context, index);
        core.chapterChange(chapterId: index).whenComplete(() {
          _animationController.reverse().whenComplete(() {
            Navigator.maybePop(context, index);
          });
        });
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
