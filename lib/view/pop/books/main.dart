import 'package:flutter/material.dart';
import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});
  static String route = 'pop-books';
  static String label = 'Books';
  static IconData icon = Icons.opacity_outlined;

  @override
  State<Main> createState() => _MainState();
}

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
  double get maxWidth => 414;
  double get hzSize => (sizeOfContext.width - maxWidth) / 2;
  bool get _hasMax => sizeOfContext.width > maxWidth;
  double get left => _hasMax ? hzSize : hzSpace;
  double get right => _hasMax ? hzSize : hzSpace;
  double get top => positionOfRender.dy + sizeOfRender.height + 20;

  double get arrowWidth => 10;
  double get arrowHeight => 12;

  double get defaultHeight => sizeOfContext.height;
  double get maxHeight => defaultHeight * 0.75;
  double get height => defaultHeight > maxHeight ? maxHeight : defaultHeight;

  // Scripture get scripture => core.scripturePrimary;
  // List<DefinitionBook> get books => scripture.bookList;

  Scripture get scripture => App.core.scripturePrimary;

  // late final List<DefinitionBook> books = List.generate(50, (index) {
  //   return DefinitionBook(
  //     testamentId: 1,
  //     id: index,
  //     name: App.core.data.randomString(15),
  //     shortName: 'ss',
  //     chapterCount: App.core.data.randomNumber(150),
  //   );
  // });
  List<DefinitionBook> get books => scripture.bookList;

  final List<int> expandedList = [];

  @override
  Widget build(BuildContext context) {
    return ViewPopupShapedArrow(
      left: left,
      right: right,
      top: top,
      height: height,
      arrow: positionOfRender.dx - left + (sizeOfRender.width * 0.40),
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
      backgroundColor: Theme.of(context).colorScheme.background,
      // child: SizedBox(
      //   height: height,
      //   child: view(),
      // ),
      child: SizeTransition(
        sizeFactor: _animation,
        axis: Axis.vertical,
        axisAlignment: -1,
        child: SizedBox(
          height: height,
          child: view(),
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
              blurRadius: 5,
              spreadRadius: 7,
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
      child: ViewListBuilder(
        primary: false,
        // NOTE: referred to ViewScrollBehavior
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        duration: const Duration(milliseconds: 50),
        itemBuilder: (BuildContext _, int index) {
          return bookItem(index, books.elementAt(index));
        },
        itemSeparator: (BuildContext _, int index) {
          return const ViewSectionDivider(
            primary: false,
            padding: EdgeInsets.symmetric(horizontal: 15),
          );
        },
        itemSnap: (BuildContext _, int index) {
          return const ListTile(
            minVerticalPadding: 16,
            enabled: false,
            title: Text('...'),
          );
        },
        itemCount: books.length,
      ),
    );
  }

  Widget bookItem(int index, DefinitionBook book) {
    bool isCurrentBook = App.core.data.bookId == book.id;

    bool isExpanded = expandedList.where((e) => e == index).isNotEmpty;
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: isExpanded ? 500 : 200),
      elevation: 0,
      expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      children: [
        ExpansionPanel(
          body: chapterList(isExpanded, book),
          // backgroundColor: isCurrentBook ? Theme.of(context).disabledColor : Colors.transparent,
          // backgroundColor: Colors.transparent,

          backgroundColor: Theme.of(context).colorScheme.background,
          // backgroundColor: Colors.red,
          // canTapOnHeader: isCurrentBook,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              onTap: () {
                // Navigator.pop<Map<String, int>>(context, {'book': book.id});
                // Navigator.maybePop<Map<String, int>>(context, {'book': book.id});
                // debugPrint('Navigator ${book.id}');
                Navigator.maybePop(context, {'book': book.id});
              },
              // alignment: Alignment.centerLeft,
              // enabled: !isCurrentBook,
              selected: isCurrentBook,
              textColor: state.theme.hintColor,
              // selectedTileColor: Colors.blue,
              // selectedTileColor: state.theme.cardColor,
              // selectedColor: state.theme.dividerColor,
              // contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: Text(
                App.preference.digit(book.id.toString()),
                style: TextStyle(
                  color: state.theme.primaryColorDark,
                ),
              ),

              title: Text(
                book.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
                ),
              ),
            );
            // return Text(
            //   book.name,
            //   overflow: TextOverflow.ellipsis,
            //   textAlign: TextAlign.start,
            //   style: TextStyle(
            //     fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
            //   ),
            // );
            // return ViewButton(
            //   // padding: const EdgeInsets.only(left: 25),
            //   // child: ViewLabel(
            //   //   label: book.name,
            //   //   alignment: Alignment.centerLeft,
            //   //   overflow: TextOverflow.ellipsis,
            //   //   textAlign: TextAlign.start,
            //   //   labelStyle: TextStyle(
            //   //     color: isCurrentBook ? Theme.of(context).highlightColor : null,
            //   //   ),
            //   // ),
            //   onPressed: () {
            //     // Navigator.pop<Map<String, int>>(context, {'book': book.id});
            //     // Navigator.maybePop<Map<String, int>>(context, {'book': book.id});
            //     // debugPrint('Navigator ${book.id}');
            //     Navigator.maybePop(context, {'book': book.id});
            //   },
            //   // alignment: Alignment.centerLeft,
            //   enable: !isCurrentBook,
            //   child: Text(
            //     book.name,
            //     overflow: TextOverflow.ellipsis,
            //     textAlign: TextAlign.start,
            //     style: TextStyle(
            //       fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
            //     ),
            //   ),
            // );
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

  Widget chapterList(bool isExpanded, DefinitionBook book) {
    if (!isExpanded) return const SizedBox();
    // List<Widget> abc = isExpanded == false
    //     ? []
    //     : List<Widget>.generate(book.entries.first.value, (index) => chapterButton(1, index + 1));

    return LayoutBuilder(
      builder: (_, constraints) {
        return Wrap(
          alignment: WrapAlignment.center,
          // spacing: 2.0,
          // runSpacing: 2.0,
          spacing: 1,
          runSpacing: 1,
          crossAxisAlignment: WrapCrossAlignment.center,
          // textDirection: TextDirection.ltr,
          children: List<Widget>.generate(
            book.chapterCount,
            (index) => chapterButton(book.id, index + 1),
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
    bool isCurrentChapter = App.core.data.chapterId == chapterId;

    return ViewButton(
      // borderRadius: const BorderRadius.all(Radius.circular(2.0)),
      // padding: const EdgeInsets.all(5),
      constraints: const BoxConstraints(
        minWidth: 70,
        minHeight: 70,
      ),
      // child: ViewMark(
      //   // label: scripture.digit(chapterId),
      //   label: chapterId.toString(),
      //   labelStyle: TextStyle(
      //     color: isCurrentChapter ? Theme.of(context).highlightColor : null,
      //   ),
      // ),
      enable: !isCurrentChapter,
      onPressed: () {
        Navigator.maybePop(context, {'book': bookId, 'chapter': chapterId});
      },
      child: Text(
        // chapterId.toString(),
        scripture.digit(chapterId),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
        ),
      ),
    );
  }
}
