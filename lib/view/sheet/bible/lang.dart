import 'package:flutter/material.dart';
// import 'package:lidea/icon.dart';
// import 'package:flutter/gestures.dart';

import 'package:lidea/provider.dart';
// import 'package:lidea/launcher.dart';
// import 'package:lidea/icon.dart';
// import 'package:lidea/hive.dart';

import '../../../app.dart';

class Main extends SheetsDraggable {
  const Main({super.key});

  static String route = 'sheet-bible-lang';
  static String label = 'Bible';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends SheetsDraggableState<Main> {
  @override
  ViewData get viewData => App.viewData;

  late final iso = App.core.iso;

  // @override
  // ScrollNotifier get notifier => App.scroll;

  // @override
  // bool get persistent => false;
  @override
  double get actualInitialSize => 0.4;
  @override
  double get actualMinSize => 0.3;

  @override
  Widget build(BuildContext context) {
    // return super.build(context);

    return ChangeNotifierProvider.value(
      key: const ValueKey("sheet-lang"),
      value: iso,
      child: Consumer<ISOFilter>(
        builder: (context, value, child) {
          return super.build(context);
        },
      ),
    );
  }

  @override
  List<Widget> slivers() {
    return <Widget>[
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        // padding: MediaQuery.of(context).viewPadding,
        heights: const [kTextTabBarHeight],
        backgroundColor: state.theme.primaryColor,
        // padding: state.fromContext.viewPadding,
        // overlapsBackgroundColor: state.theme.scaffoldBackgroundColor,
        overlapsBorderColor: Theme.of(context).dividerColor,
        borderWidth: 0.3,
        // overlapsBorderColor: state.theme.dividerColor,
        builder: (_, vhd) {
          return ViewHeaderLayouts(
            data: vhd,
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
              //   const Alignment(-1, 0),
              //   const Alignment(0, 0),
              //   vhd.snapShrink,
              // ),
              // label: 'Language filter',
              label: App.preference.text.language('false'),
              data: vhd,
            ),
            left: [
              OptionButtons.cancel(
                navigator: state.navigator,
                label: App.preference.text.cancel,
              ),
            ],
            right: [
              // ViewButton(
              //   // color: Colors.red,
              //   onPressed: iso.toggleAll,
              //   // child: const ViewMark(
              //   //   // icon: LideaIcon.loop,
              //   //   label: 'Toggle',
              //   // ),
              //   child: Text(
              //     'Toggle',
              //     style: Theme.of(context).textTheme.labelSmall,
              //   ),
              // ),
              // ViewButton(
              //   // color: Theme.of(context).highlightColor,
              //   opacity: 0.6,
              //   onPressed: iso.toggleAll,
              //   message: 'Toggle',
              //   child: ViewMark(
              //     icon: Icons.graphic_eq,
              //     iconColor: Theme.of(context).highlightColor,
              //   ),
              // ),
              OptionButtons.icon(
                opacity: 0.6,
                onPressed: iso.toggleAll,
                // message: 'Toggle',
                icon: Icons.graphic_eq,
              ),
            ],
          );
        },
      ),
      ViewLists.separator(
        decoration: BoxDecoration(
          color: CardTheme.of(context).color,
          boxShadow: [
            BoxShadow(
              color: CardTheme.of(context).shadowColor!,
              blurRadius: 0.2,
              spreadRadius: 0.0,
              offset: const Offset(0.0, 0.0),
            )
          ],
        ),
        separator: (BuildContext context, int index) {
          return const ViewDividers();
        },
        itemBuilder: (BuildContext context, int index) {
          final item = iso.all.elementAt(index);

          // if (item.code == 'ctd') {
          //         final abc = boxOfBooks.entries.where(
          //   (e) {
          //     return iso.all
          //         .firstWhere(
          //           (element) => element.code == e.value.langCode,
          //           orElse: () => iso.all.first,
          //         )
          //         .show;
          //   },
          // );
          //   debugPrint(item.bible.toString());
          // }
          // item.totalBible;
          // return bookContainer(index, iso.all.elementAt(index));
          // return const BookItemSnap();
          final isAva = item.show;
          return ListTile(
            // selected: item.show,
            // leading: Text(item.code),
            // selectedColor: Colors.red,
            // tileColor: Colors.red,
            // textColor: Theme.of(context).hoverColor,
            // selectedTileColor: Colors.amber,

            // leading: Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 7),
            //   child: Container(
            //     constraints: const BoxConstraints(
            //       minWidth: 50.0,
            //     ),
            //     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
            //     // margin: const EdgeInsets.only(right: 7),
            //     decoration: BoxDecoration(
            //       borderRadius: const BorderRadius.all(Radius.circular(4)),
            //       // color: Theme.of(context).focusColor,
            //       // color:
            //       //     isAva ? Theme.of(context).highlightColor : Theme.of(context).dividerColor,
            //       color:
            //           isAva ? Theme.of(context).primaryColorDark : Theme.of(context).focusColor,
            //     ),
            //     child: Text(
            //       item.code.toUpperCase(),
            //       textAlign: TextAlign.center,
            //       style: Theme.of(context).textTheme.bodySmall!.copyWith(
            //             color: Theme.of(context).primaryColor,
            //           ),
            //     ),
            //   ),
            // ),
            leading: Text(
              App.preference.digit(index + 1),
              // book.id.toString(),
              textAlign: TextAlign.center,
              // style: TextStyle(
              //   color: state.theme.primaryColorDark,
              // ),
              style: state.textTheme.titleMedium?.copyWith(
                color: state.theme.hintColor,
              ),
            ),
            title: Paragraphs(
              text: item.langNameList.join(', '),
              // text: App.preference.language('totalBookLang'),
              style: state.textTheme.bodyMedium!.copyWith(
                color: isAva ? null : Theme.of(context).hoverColor.darken(amount: .9),
              ),
            ),
            // backgroundColor: state.theme.scaffoldBackgroundColor,

            // subtitle: Paragraphs(
            //   text: '#{{bookCount}} book',
            //   // text: App.preference.language('totalBookLang'),
            //   style: state.textTheme.labelSmall!.copyWith(
            //     color: isAva ? null : Theme.of(context).hoverColor.darken(amount: .9),
            //   ),
            //   // textAlign: TextAlign.center,
            //   decoration: [
            //     TextSpan(
            //       text: App.preference.digit(item.bible.length),
            //       semanticsLabel: 'bookCount',
            //       style: TextStyle(
            //         color: state.theme.hintColor,
            //       ),
            //     ),
            //   ],
            // ),
            // trailing: Text(
            //   App.preference.digit(item.bible.length),
            //   style: state.textTheme.labelSmall,
            // ),
            trailing: Container(
              constraints: const BoxConstraints(
                minWidth: 40.0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              // margin: const EdgeInsets.only(right: 7),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                // color: Theme.of(context).focusColor,
                // color:
                //     isAva ? Theme.of(context).highlightColor : Theme.of(context).dividerColor,
                color: isAva ? Theme.of(context).primaryColorDark : Theme.of(context).focusColor,
              ),
              child: Text(
                App.preference.digit(item.bible.length),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
            onTap: () {
              iso.toggle(item);
            },
          );
        },
        itemCount: iso.all.length,
      ),
    ];
  }

  @override
  Widget draggableDecoration({Widget? child}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        // color: persistent ? theme.scaffoldBackgroundColor.withOpacity(0.5) : theme.primaryColor,
        // color: theme.primaryColor,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: child,
    );
  }
}
