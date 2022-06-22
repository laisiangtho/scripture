import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'state.dart';
part 'swipe.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/launch/home';
  static const icon = LideaIcon.home;
  static const name = 'Launch';
  static const description = '...';

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        controller: scrollController,
        child: Consumer<Authentication>(
          builder: middleware,
        ),
      ),
    );
  }

  Widget middleware(BuildContext context, Authentication aut, Widget? child) {
    return CustomScrollView(
      controller: scrollController,
      slivers: sliverWidgets(),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        // reservedPadding: MediaQuery.of(context).padding.top,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 50],
        overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: bar,
      ),
      const PullToRefresh(),
      ValueListenableBuilder(
        valueListenable: core.collection.boxOfBooks.listen(),
        builder: bookList,
      ),
      // SliverList(
      //   delegate: SliverChildListDelegate(
      //     [
      //       WidgetButton(
      //         onPressed: () {
      //           core.navigate(to: '/launch/vote');
      //         },
      //         child: const Text('Vote'),
      //       ),
      //     ],
      //   ),
      // ),
    ];
  }

  Widget bookList(BuildContext context, Box<BooksType> box, Widget? child) {
    // final items = box.toMap().entries.toList();
    final items = box.values.where((e) => e.selected);

    // items.sort((a, b) => a.value.order.compareTo(b.value.order));

    return WidgetBlockSection(
      headerTitle: WidgetMark(
        mainAxisAlignment: MainAxisAlignment.start,
        label: preference.text.favorite(true),
      ),
      headerTrailing: WidgetButton(
        message: preference.text.addTo(preference.text.favorite(true)),
        onPressed: () {
          core.navigate(to: '/launch/bible');
        },
        child: const WidgetLabel(
          icon: Icons.more_horiz,
        ),
      ),
      footerTitle: WidgetButton(
        show: items.isNotEmpty,
        onPressed: () {
          core.navigate(to: '/launch/bible');
        },
        child: WidgetMark(
          label: preference.text.addMore(preference.text.favorite(true)),
        ),
      ),
      child: WidgetBlockCard(
        child: WidgetListBuilder(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return bookItem(
              index,
              items.elementAt(index),
            );
          },
          itemSeparator: (BuildContext context, int index) {
            return const WidgetListDivider();
          },
          itemVoid: WidgetButton(
            padding: const EdgeInsets.all(15),
            child: WidgetMark(
              label: preference.text.addTo(preference.text.favorite(true)),
            ),
            onPressed: () {
              core.navigate(to: '/launch/bible');
            },
          ),
          itemCount: items.length,
        ),
      ),
    );
  }

  Widget bookItem(int index, BooksType book) {
    bool isAvailable = book.available > 0;
    bool isPrimary = book.identify == core.collection.primaryId;
    return ListTile(
      enabled: true,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          book.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: book.name,
          style: DefaultTextStyle.of(context).style.copyWith(
                fontSize: 20,
                fontWeight: isAvailable ? FontWeight.w400 : FontWeight.w300,
                // color: isAvailable?Colors.black:Colors.grey,
              ),
        ),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(
              minWidth: 30.0,
            ),
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: isAvailable
                  ? isPrimary
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).primaryColorDark
                  : Theme.of(context).disabledColor,
            ),
            child: Text(
              book.langCode.toUpperCase(),
              textAlign: TextAlign.center,
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 12,
                    color: isAvailable ? Theme.of(context).primaryColor : null,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              book.shortname,
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
            ),
          )
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            book.year.toString(),
            style: DefaultTextStyle.of(context).style.copyWith(
                  fontSize: 16,
                  color: isAvailable ? null : Theme.of(context).hintColor,
                ),
          ),
        ],
      ),
      onTap: () => isAvailable ? toBible(book) : showOptions(book),
    );
  }
}
