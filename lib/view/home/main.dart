import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '/app.dart';

part 'state.dart';
part 'header.dart';
part 'inspect_process.dart';
part 'inspect_route.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'home';
  static String label = 'Home';
  static IconData icon = LideaIcon.flag;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('abc'),
      // ),
      body: Views(
        child: CustomScrollView(
          // physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          slivers: _slivers,
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        padding: state.fromContext.viewPadding,
        // padding: const EdgeInsets.only(top: 30),
        // heights: const [kToolbarHeight, 100],
        heights: const [kToolbarHeight, kToolbarHeight],
        // overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),

      const PullToRefresh(),
      // const InspectProcess(),
      // const InspectRoute(),

      // featureWidget(),

      /// Favorite book
      ValueListenableBuilder(
        valueListenable: data.boxOfBooks.listen(),
        builder: bookList,
      ),

      /// Recent search
      ValueListenableBuilder(
        valueListenable: data.boxOfRecentSearch.listen(),
        builder: recentSearch,
      ),
    ];
  }

  Widget featureWidget() {
    return ViewFlats(
      child: ViewCards(
        child: ViewLists(
          // shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 100,
              height: 100,
              child: Text('abc'),
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }

  Widget bookList(BuildContext context, Box<BooksType> box, Widget? child) {
    // final items = box.toMap().entries.toList();
    // final items = box.values.where((e) => e.selected).toList();
    final items = box.toMap().entries.where((e) => e.value.selected).toList();
    // items.sort((a, b) => a.value.order.compareTo(b.value.order));

    return ViewSections(
      // headerLeading: const Icon(Icons.ac_unit),
      headerTitle: Text(
        preference.text.favorite('true'),
        style: state.textTheme.titleSmall,
      ),

      headerTrailing: ViewButtons(
        show: items.isNotEmpty,
        message: preference.text.addTo(preference.text.favorite('true').toLowerCase()),
        onPressed: () {
          route.pushNamed('home/bible');
        },
        child: ViewMarks(
          icon: LideaIcon.dotHoriz,
          iconSize: 19,
          iconColor: state.theme.hintColor,
        ),
      ),
      footer: items.isNotEmpty,
      footerTitle: ViewButtons(
        // padding: EdgeInsets.zero,
        // style: const TextStyle(
        //   color: Colors.red,
        //   fontSize: 12,
        // ),
        // color: Colors.red,
        onPressed: () {
          route.pushNamed('home/bible');
        },
        // child: ViewMarks(
        //   label: preference.text.addMore(preference.text.favorite(true)),
        // ),
        child: Text(
          preference.text.addMore(preference.text.favorite('true').toLowerCase()),
          textAlign: TextAlign.center,
        ),
      ),
      // footerTitle: Text(
      //   preference.text.addMore(preference.text.favorite(true)),
      //   textAlign: TextAlign.center,
      // ),
      // footerOnPressed: () {
      //   route.pushNamed('home/bible');
      // },

      child: ViewCards(
        child: ViewLists.separator(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return bookItem(
              index,
              items.elementAt(index),
            );
          },
          separator: (BuildContext context, int index) {
            return const ViewDividers();
          },
          onEmpty: ViewButtons(
            padding: const EdgeInsets.symmetric(vertical: 30),
            // child: ViewMarks(
            //   label: preference.text.addTo(preference.text.favorite(true)),
            // ),
            child: Text(
              preference.text.addTo(preference.text.favorite('true')),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              route.pushNamed('home/bible');
            },
          ),
          itemCount: items.length,
        ),
      ),
    );
  }

  Widget bookItem(int index, MapEntry<dynamic, BooksType> item) {
    final book = item.value;
    bool isAvailable = book.available > 0;
    bool isPrimary = book.identify == data.primaryId;
    return ListTile(
      minVerticalPadding: 10,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
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
              minWidth: 40.0,
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
            // style: DefaultTextStyle.of(context).style.copyWith(
            //       fontSize: 16,
            //       color: isAvailable ? null : Theme.of(context).hintColor,
            //     ),
            style: state.textTheme.bodySmall,
          ),
        ],
      ),
      // onTap: () => isAvailable ? showBible(book) : showMore(book),
      onTap: () {
        if (isAvailable) {
          showBibleContent(book);
        } else {
          showBibleInfo(item);
        }
      },
      onLongPress: () {
        showBibleInfo(item);
      },
    );
  }

  Widget recentSearch(BuildContext context, Box<RecentSearchType> box, Widget? child) {
    // return const SliverToBoxAdapter(
    //   child: Text('abc'),
    // );
    // items.sort((a, b) => b.value.date!.compareTo(a.value.date!));

    final items = box.values.toList();

    items.sort((a, b) => b.date!.compareTo(a.date!));

    return ViewSections(
      show: items.isNotEmpty,
      sliver: true,
      headerTitle: Text(
        preference.text.recentSearch('true'),
        style: state.textTheme.titleSmall,
      ),
      headerTrailing: ViewButtons(
        message: preference.text.addTo(preference.text.recentSearch('true')),
        onPressed: () {
          route.pushNamed('home/recent-search');
        },
        child: ViewMarks(
          icon: LideaIcon.dotHoriz,
          iconSize: 19,
          iconColor: state.theme.hintColor,
        ),
      ),
      child: ViewCards(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            textDirection: TextDirection.ltr,
            children: items.take(3).map(
              (e) {
                return ViewButtons(
                  style: state.theme.textTheme.bodyLarge,
                  child: ViewMarks(
                    // padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    label: e.word,
                  ),
                  // onPressed: () => onSearch(e.value.word),
                  onPressed: () {
                    route.pushNamed(
                      'home/search',
                      arguments: {'keyword': e.word},
                    );
                  },
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}

class PullToRefresh extends PullToActivate {
  const PullToRefresh({super.key, super.distance, super.extent});

  @override
  State<PullToActivate> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends PullOfState {
  // late final Core core = context.read<Core>();
  @override
  Future<void> refreshUpdate() async {
    await Future.delayed(const Duration(milliseconds: 50));
    await App.core.updateBookMeta();
    // await Future.delayed(const Duration(milliseconds: 100));
    // debugPrint('refreshUpdate');
    await App.data.updateToken();
    await Future.delayed(const Duration(milliseconds: 700));
  }
}
