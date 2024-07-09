// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/share.dart';
import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});
  static String route = 'pop-options';
  static String label = 'Options';
  static IconData icon = LideaIcon.popup;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends StateAbstract<Main> {
  // Preference get preference => App.preference;
  Scripture get primaryScripture => core.scripturePrimary;
  Marks get marks => primaryScripture.marks;
  List<OfVerse> get primaryVerse => primaryScripture.verse;
  bool get hasSelection => marks.hasSelection;

  BoxOfSettings<SettingsType> get bOS => data.boxOfSettings;

  void doFontSize(bool increase) {
    bOS.fontSizeModify(increase);
  }

  void doFontSizeReset() {
    final fontSize = data.env.settings['fontSize'];
    bOS.fontSize(value: fontSize);
  }

  void doShare() {
    primaryScripture.getSelection().then(Share.share);
  }

  void doNote() {
    final bookName = primaryScripture.bookName;
    final chapterName = primaryScripture.chapterName;
    final svs = marks.verseSelection.first;
    final a = marks.currentVerse.where((e) => e.id == svs);
    String? toEdit = '';
    if (a.isNotEmpty) {
      if (a.first.note != null) {
        toEdit = a.first.note;
      }
    }

    App.route.showSheetModal(
      context: context,
      name: 'sheet-bible-navigation/leaf-editor',
      arguments: {
        'text': toEdit,
        'focus': true,
        // 'pageLabel': prefence.text.addTo(prefence.text.data('').toLowerCase()),
        // 'pageTitle': prefence.text.note('true'),
        'pageLabel': preference.text.addTo(preference.text.note('').toLowerCase()),
        'pageTitle': '$bookName $chapterName:$svs',
      },
    ).then((e) {
      if (e != null) {
        marks.selectionApply(note: e['text']);
      }
    });
  }

  void doReset() {
    marks.resetSelection();
    // Navigator.maybePop(context);
    Future.delayed(const Duration(milliseconds: 400), () {
      Navigator.maybePop(context);
    });
  }

  void Function(bool) get fontSize => args['setFontSize'];

  late final RenderBox render = args['render'];
  late final Size sizeOfRender = render.size;
  late final Offset positionOfRender = render.localToGlobal(Offset.zero);
  late final Size sizeOfContext = MediaQuery.of(context).size;

  double get hzSpace => 5;
  double get maxWidth => 200;
  double get right => hzSpace;
  double get left => sizeOfContext.width > maxWidth ? sizeOfContext.width - maxWidth : hzSpace;
  double get top => positionOfRender.dy + sizeOfRender.height + 7;

  double get arrowWidth => 10;
  double get arrowHeight => 12;

  double get elevation => hasSelection ? 7 : 3;

  // double get defaultHeight => sizeOfRender.height + 72;
  // double get maxHeight => defaultHeight * 0.72;
  // // double get height => defaultHeight > maxHeight ? maxHeight : defaultHeight;
  // double get minHeight => 45 * 4;

  double get item => hasSelection ? 4 : 1;
  double get defaultHeight => 45 * item;
  double get maxHeight => sizeOfContext.height * 0.62;
  double get height => defaultHeight > maxHeight ? maxHeight : defaultHeight;

  @override
  Widget build(BuildContext context) {
    // debugPrint('marks hasSelection $hasSelection');
    return ViewPopupShapedArrow(
      left: left,
      right: right,
      top: top,
      height: height,
      arrow: positionOfRender.dx - left + (sizeOfRender.width * 0.3),
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
      // backgroundColor: Theme.of(context).colorScheme.surface,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: elevation,
      child: SizedBox(
        height: height,
        child: body(),
        // child: ListenableBuilder(
        //   listenable: marks,
        //   builder: (BuildContext context, Widget? child) {
        //     return body();
        //   },
        // ),
      ),
    );
  }

  Widget body() {
    List<Widget> children = [
      rowCommon(
        height: 45,
        child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            // childAspectRatio: 1.36,
            childAspectRatio: 1.4,
            crossAxisCount: 3,
          ),
          shrinkWrap: true,
          children: <Widget>[
            // ViewButton(
            //   style: state.textTheme.labelLarge,
            //   message: preference.text.decreaseSize(preference.text.fontSize.toLowerCase()),
            //   onPressed: () => doFontSize(false),
            //   child: const Icon(Icons.remove),
            // ),
            // ViewButton(
            //   onPressed: doFontSizeReset,
            //   message: preference.text.resetSize(preference.text.fontSize.toLowerCase()),
            //   child: StreamBuilder(
            //     initialData: bOS.fontSize(),
            //     stream: bOS.watch(key: 'fontSize'),
            //     builder: (BuildContext _, AsyncSnapshot<Object> e) {
            //       return ViewMark(
            //         decoration: BoxDecoration(
            //           border: Border.symmetric(
            //             vertical: BorderSide(
            //               width: 1,
            //               color: Theme.of(context).dividerColor,
            //             ),
            //           ),
            //         ),
            //         label: bOS.fontSize().asDouble.toStringAsFixed(0),
            //         labelStyle: TextStyle(
            //           color: Theme.of(context).hintColor,
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // ViewButton(
            //   onPressed: () => doFontSize(true),
            //   style: state.textTheme.labelLarge,
            //   message: preference.text.increaseSize(preference.text.fontSize.toLowerCase()),
            //   child: const Icon(Icons.add),
            // ),
            OptionButtons.icon(
              onPressed: () => doFontSize(false),
              message: preference.text.decreaseSize(preference.text.fontSize.toLowerCase()),
              icon: Icons.remove,
            ),
            // ViewButton(
            //   onPressed: () => doFontSize(true),
            //   style: state.textTheme.labelLarge,
            //   message: preference.text.increaseSize(preference.text.fontSize.toLowerCase()),
            //   child: const Icon(Icons.add),
            // ),
            ViewButton(
              onPressed: doFontSizeReset,
              message: preference.text.resetSize(preference.text.fontSize.toLowerCase()),
              padding: EdgeInsets.zero,
              child: StreamBuilder(
                initialData: bOS.fontSize(),
                stream: bOS.watch(key: 'fontSize'),
                builder: (BuildContext _, AsyncSnapshot<Object> e) {
                  return ViewMark(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    label: preference.digit(bOS.fontSize().asDouble.toStringAsFixed(0)),
                    labelStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  );
                },
              ),
            ),
            OptionButtons.icon(
              onPressed: () => doFontSize(true),
              message: preference.text.increaseSize(preference.text.fontSize.toLowerCase()),
              icon: Icons.add,
            )
          ],
        ),
      ),
    ];

    if (hasSelection) {
      children.addAll(
        [
          // ListenableBuilder(
          //   listenable: marks,
          //   builder: (BuildContext context, Widget? _) {
          //     return ViewButton.filled(
          //       color: color.withOpacity(0.2),
          //       borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          //       onPressed: marks.hasSelection ? onPressed : null,
          //       border: Border.all(width: 1, color: Theme.of(context).dividerColor),
          //       child: const SizedBox(),
          //     );
          //   },
          // ),
          rowCommon(
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  // color: Colors.black,
                  width: 1,
                ),
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  // color: Colors.black,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  // 'Selection',
                  preference.text.selection(''),
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ],
            ),
          ),
          rowCommon(
            height: 55,
            // child: GridView(
            //   physics: const NeverScrollableScrollPhysics(),
            //   // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            //   padding: const EdgeInsets.only(left: 5, right: 5, top: 9),
            //   // padding: EdgeInsets.zero,
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     // childAspectRatio: 1.36,
            //     mainAxisSpacing: 5,
            //     crossAxisSpacing: 5,
            //     childAspectRatio: 1.1,
            //     crossAxisCount: marks.colorOptions.length,
            //   ),
            //   shrinkWrap: true,
            //   // children: <Widget>[
            //   //   colorButton(color: marks.colorList.elementAt(0), onPressed: doColorRed),
            //   //   colorButton(color: marks.colorList.elementAt(1), onPressed: doColorBlue),
            //   //   colorButton(color: marks.colorList.elementAt(2), onPressed: doColorGreen),
            //   //   colorButton(color: marks.colorList.elementAt(3), onPressed: doColorOrange),
            //   // ],
            //   children: marks.colorOptions
            //       .map(
            //         (e) => colorButton(
            //           color: e["color"],
            //           onPressed: () => marks.selectionApply(color: e["index"]),
            //         ),
            //       )
            //       .toList(),
            // ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                // return const Text(' ? ');
                // return Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                //   child: colorButton(
                //     color: marks.colorOptions.elementAt(index),
                //     onPressed: () => marks.selectionApply(color: index),
                //   ),
                // );
                return colorButton(index: index);
                // return colorButton(
                //   color: marks.colors.elementAt(index).color,
                //   onPressed: () => marks.selectionApply(color: index),
                // );
              },
              itemCount: marks.colors.length,
            ),
          ),
          rowCommon(
            height: 50,
            decoration: BoxDecoration(
              // color: Colors.red,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  // color: Colors.black,
                  width: 1,
                ),
              ),
            ),
            child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              // padding: const EdgeInsets.only(left: 5, right: 5),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                // childAspectRatio: 1.36,
                // mainAxisSpacing: 10,
                // crossAxisSpacing: 5,
                childAspectRatio: 1.3,
                crossAxisCount: 3,
              ),
              shrinkWrap: true,
              children: <Widget>[
                actionButton(
                  msg: preference.text.share,
                  onPressed: doShare,
                  icon: Icons.ios_share_outlined,
                ),
                actionButton(
                  msg: preference.text.note(''),
                  onPressed: doNote,
                  // icon: Icons.chat_rounded,
                  icon: Icons.edit_note_rounded,
                ),
                actionButton(
                  msg: preference.text.reset,
                  onPressed: doReset,
                  icon: Icons.remove_circle_outline_rounded,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: children,
    );
  }

  Widget rowCommon({required double height, Decoration? decoration, required Widget child}) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: decoration ?? const BoxDecoration(),
        child: child,
      ),
    );
  }

  Widget colorButton({required int index}) {
    final oj = marks.colors.elementAt(index);
    final color = oj.color;
    return ListenableBuilder(
      listenable: marks,
      builder: (BuildContext context, Widget? _) {
        return Opacity(
          opacity: marks.hasSelection ? 1 : 0.3,
          child: ViewButton.filled(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            onPressed: marks.hasSelection ? () => marks.selectionApply(color: index) : null,
            // message: preference.text.color(''),
            message: preference.language('color-${oj.name}'),
            child: ViewMark(
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              // constraints: const BoxConstraints(minWidth: 30),

              decoration: BoxDecoration(
                // color: color.lighten(amount: 0.39),
                color: color.withOpacity(marks.colorOpacityButton),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                // border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                // boxShadow: [
                //   BoxShadow(
                //     color: Theme.of(context).shadowColor,
                //     blurRadius: 1, // soften the shadow
                //     spreadRadius: 0, //extend the shadow
                //     offset: const Offset(
                //       0.0, // Move to right 10  horizontally
                //       0.0, // Move to bottom 10 Vertically
                //     ),
                //   )
                // ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget actionButton({required String msg, required IconData icon, void Function()? onPressed}) {
    return ListenableBuilder(
      listenable: marks,
      builder: (BuildContext context, Widget? _) {
        return ViewButton(
          onPressed: marks.hasSelection ? onPressed : null,
          message: msg,
          child: ViewMark(
            icon: icon,
          ),
        );
      },
    );
    // return ViewButton(
    //   onPressed: hasSelection ? onPressed : null,
    //   message: msg,
    //   child: ViewMark(
    //     icon: icon,
    //     // labelPadding: const EdgeInsets.only(left: 7),
    //     // iconSize: 17,
    //     // label: 'Note',
    //     // label: prefence.text.note(''),
    //   ),
    // );
  }
}
