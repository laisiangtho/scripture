import 'package:flutter/material.dart';
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
      key: const ValueKey("sdfd"),
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
        heights: const [kToolbarHeight, 30],
        backgroundColor: state.theme.primaryColor,
        // backgroundColor: Colors.transparent,
        // padding: state.fromContext.viewPadding,
        overlapsBackgroundColor: state.theme.scaffoldBackgroundColor,
        // overlapsBorderColor: Theme.of(context).shadowColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: (_, vhd) {
          return ViewHeaderLayoutStack(
            data: vhd,
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
                const Alignment(-1.2, 0),
                const Alignment(-1, 0),
                vhd.snapShrink,
              ),
              label: 'Filter',
              data: vhd,
            ),
          );
        },
      ),
      ViewSection(
        child: ViewListBuilder(
          primary: false,
          itemBuilder: (BuildContext context, int index) {
            final item = iso.all.elementAt(index);
            // return bookContainer(index, iso.all.elementAt(index));
            // return const BookItemSnap();
            final isAva = item.show;
            return ListTile(
              // selected: item.show,
              // leading: Text(item.code),
              // selectedColor: Colors.red,
              textColor: Theme.of(context).hoverColor,
              // selectedTileColor: Colors.amber,

              leading: Container(
                constraints: const BoxConstraints(
                  minWidth: 50.0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 0),
                // margin: const EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  // color: Theme.of(context).focusColor,
                  // color: isAva ? Theme.of(context).highlightColor : Theme.of(context).dividerColor,
                  color: isAva ? Theme.of(context).primaryColorDark : Theme.of(context).focusColor,
                ),
                child: Text(
                  item.code.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),

              title: TextDecoration(
                text: item.langNameList.join(', '),
                // text: App.preference.language('totalBookLang'),
                style: state.textTheme.bodyMedium!.copyWith(
                  color: isAva ? null : Theme.of(context).hoverColor.darken(amount: .9),
                ),
              ),

              subtitle: TextDecoration(
                text: '#{{bookCount}} book',
                // text: App.preference.language('totalBookLang'),
                style: state.textTheme.labelSmall!.copyWith(
                  color: isAva ? null : Theme.of(context).hoverColor.darken(amount: .9),
                ),
                // textAlign: TextAlign.center,
                decoration: [
                  TextSpan(
                    text: App.preference.digit(item.bible.length),
                    semanticsLabel: 'bookCount',
                    style: TextStyle(
                      color: state.theme.hintColor,
                    ),
                  ),
                ],
              ),
              onTap: () {
                iso.toggle(item);
              },
            );
          },
          itemCount: iso.all.length,
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.all(7),
        sliver: SliverToBoxAdapter(
          child: Text(''),
        ),
      ),
    ];
  }
}
