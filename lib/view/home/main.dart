import 'dart:async';

import 'package:flutter/material.dart';

// import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '/app.dart';

part 'state.dart';
part 'header.dart';
part 'inspect_process.dart';
part 'inspect_route.dart';

class Main extends StatefulWidget {
  const Main({super.key});

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
        padding: state.media.viewPadding,
        // padding: const EdgeInsets.only(top: 30),
        // heights: const [kToolbarHeight, 100],
        heights: const [kToolbarHeight, kToolbarHeight],
        // overlapsBackgroundColor: theme.primaryColor,
        overlapsBorderColor: theme.dividerColor,
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
        app.preference.of(context).favorite('true'),
        style: style.titleSmall,
      ),

      headerTrailing: ViewButtons(
        show: items.isNotEmpty,
        message: app.preference
            .of(context)
            .addTo(app.preference.of(context).favorite('true').toLowerCase()),
        onPressed: () {
          app.route.page.push('/bible');
        },
        child: Icon(
          Icons.more_horiz,
          color: theme.shadowColor,
        ),
      ),
      footer: items.isNotEmpty,
      // footerTitle: ViewButtons(
      //   // padding: EdgeInsets.zero,
      //   // style: const TextStyle(
      //   //   color: Colors.red,
      //   //   fontSize: 12,
      //   // ),
      //   // color: Colors.red,
      //   onPressed: () {
      //     app.route.page.push('/bible');
      //   },
      //   // child: ViewMarks(
      //   //   label: app.preference.of(context).addMore(app.preference.of(context).favorite(true)),
      //   // ),
      //   child: Text(
      //     app.preference
      //         .of(context)
      //         .addMore(app.preference.of(context).favorite('true').toLowerCase()),
      //     textAlign: TextAlign.center,
      //   ),
      // ),
      footerTitle: OptionButtons.label(
        // current: false,
        onPressed: () {
          app.route.page.push('/bible');
        },
        // child: ViewMarks(
        //   label: app.preference.of(context).addMore(app.preference.of(context).favorite(true)),
        // ),
        // style: style.labelSmall,
        // style: style.labelSmall?.copyWith(
        //   // color: theme.buttonTheme.colorScheme?.onPrimary,
        //   // color: colorScheme.onError,
        //   // color: Colors.red,
        //   color: theme.hintColor,
        // ),

        label: app.preference
            .of(context)
            .addMore(app.preference.of(context).favorite('true').toLowerCase()),
      ),
      // footerTitle: TextButton(
      //   onPressed: () {},
      //   // style: TextButton.styleFrom(
      //   //   foregroundColor: Colors.pink,
      //   // ),
      //   child: const Text(
      //     'TextButton (New)',
      //     // style: TextStyle(fontSize: 30),
      //   ),
      // ),
      // footerTitle: Text(
      //   app.preference.of(context).addMore(app.preference.of(context).favorite(true)),
      //   textAlign: TextAlign.center,
      // ),
      // footerOnPressed: () {
      //   app.route.page.push('/bible');
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
            //   label: app.preference.of(context).addTo(app.preference.of(context).favorite(true)),
            // ),
            child: Text(
              app.preference.of(context).addTo(app.preference.of(context).favorite('true')),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              app.route.page.push('/bible');
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
                      ? theme.highlightColor
                      : theme.primaryColorDark
                  : theme.disabledColor,
            ),
            child: Text(
              book.langCode.toUpperCase(),
              textAlign: TextAlign.center,
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 12,
                    color: isAvailable ? theme.primaryColor : null,
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

      trailing: ViewMarks(
        child: Text(
          book.year.toString(),
        ),
      ),
      // onTap: () => isAvailable ? showBible(book) : showMore(book),
      onTap: () {
        if (isAvailable) {
          showBibleContent(book);
        } else {
          showBibleInfo(item.value);
        }
      },
      onLongPress: () {
        showBibleInfo(item.value);
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
      footerTitle: ViewButtons(
        show: items.isNotEmpty,
        message: app.preference.of(context).more,
        onPressed: () {
          app.route.page.push('/recent-search');
        },
        child: Icon(
          Icons.more_horiz,
          color: theme.shadowColor,
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        textDirection: TextDirection.ltr,
        spacing: 7,
        children: items.take(3).map(
          (e) {
            return TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                backgroundColor: theme.dividerColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onPressed: () => onSearch(e),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  e.word,
                  overflow: TextOverflow.ellipsis,
                  semanticsLabel: 'Keyword',
                  style: style.labelLarge,
                ),
              ),
            );
          },
        ).toList(),
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
    await App.core.data.updateToken();
    await Future.delayed(const Duration(milliseconds: 700));
  }
}
