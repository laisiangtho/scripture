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
      const InspectProcess(),
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
      headerTitle: Text(
        lang.favorite('true'),
        style: style.titleSmall,
      ),
      headerTrailing: ViewButtons(
        show: items.isNotEmpty,
        message: lang.addTo(lang.favorite('true').toLowerCase()),
        onPressed: () {
          app.route.page.push('/bible');
        },
        child: Icon(
          Icons.more_horiz,
          color: theme.shadowColor,
        ),
      ),
      footer: items.isNotEmpty,
      footerTitle: OptionButtons.label(
        // current: false,
        onPressed: () {
          app.route.page.push('/bible');
        },

        // label: app.preference
        //     .of(context)
        //     .addMore(lang.favorite('true').toLowerCase()),
        label: lang.addMore(lang.favorite('true').toLowerCase()),
      ),
      child: ViewCards(
        child: ViewLists.separator(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final book = items.elementAt(index).value;
            return BookListItem(
              book: book,
              index: index,
              onPress: () {
                if (book.available > 0) {
                  showBibleContent(book);
                } else {
                  showBibleInfo(book);
                }
              },
              onLongPress: () {
                showBibleInfo(book);
              },
            );
          },
          separator: (BuildContext context, int index) {
            return const ViewDividers();
          },
          onEmpty: ViewButtons(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text(
              lang.addTo(lang.favorite('true')),
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
        message: lang.more,
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

class PullToRefresh extends ViewPulls {
  const PullToRefresh({super.key, super.distance, super.extent});

  @override
  Future<void> refreshUpdate() async {
    await Future.delayed(const Duration(milliseconds: 50));
    // await App.core.updateBookMeta();
    // await Future.delayed(const Duration(milliseconds: 100));
    // await App.core.data.updateToken();
    await Future.delayed(const Duration(milliseconds: 1500));
    debugPrint('refreshUpdate');
  }
}
