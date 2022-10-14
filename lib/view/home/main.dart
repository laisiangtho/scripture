import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '../../app.dart';
import '/widget/profile_icon.dart';
import '/widget/button.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static String route = 'home';
  static String label = 'Home';
  static IconData icon = LideaIcon.flag;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    debugPrint('home->build');
    return Scaffold(
      // extendBodyBehindAppBar: true,
      primary: true,
      body: Views(
        // scrollBottom: ScrollBottomNavigation(
        //   listener: _controller.bottom,
        //   notifier: App.viewData.bottom,
        // ),

        // snap: _viewSnap,
        child: CustomScrollView(
          controller: _controller,
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
      // const SliverAppBar(
      //   title: Text('data'),
      // ),
      const PullToRefresh(),

      /// Favorite book
      ValueListenableBuilder(
        valueListenable: App.core.data.boxOfBooks.listen(),
        builder: bookList,
      ),

      /// Recent search
      ValueListenableBuilder(
        valueListenable: App.core.data.boxOfRecentSearch.listen(),
        builder: recentSearch,
      ),
    ];
  }

  Widget bookList(BuildContext context, Box<BooksType> box, Widget? child) {
    // final items = box.toMap().entries.toList();
    final items = box.values.where((e) => e.selected).toList();
    // items.sort((a, b) => a.value.order.compareTo(b.value.order));

    return ViewSection(
      // headerLeading: const Icon(Icons.ac_unit),
      headerTitle: Text(App.preference.text.favorite(true)),
      // headerTitle: ViewMark(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   label: App.preference.text.favorite(true),
      // ),
      headerTrailing: ViewButton(
        show: items.isNotEmpty,
        message: App.preference.text.addTo(App.preference.text.favorite(true)),
        onPressed: () {
          App.route.pushNamed('home/bible');
        },
        child: const ViewMark(
          icon: Icons.more_horiz,
        ),
      ),
      footer: items.isNotEmpty,
      footerTitle: ViewButton(
        // padding: EdgeInsets.zero,
        // style: const TextStyle(
        //   color: Colors.red,
        //   fontSize: 12,
        // ),
        // color: Colors.red,
        onPressed: () {
          App.route.pushNamed('home/bible');
        },
        // child: ViewMark(
        //   label: App.preference.text.addMore(App.preference.text.favorite(true)),
        // ),
        child: Text(
          App.preference.text.addMore(App.preference.text.favorite(true)),
          textAlign: TextAlign.center,
        ),
      ),
      // footerTitle: Text(
      //   App.preference.text.addMore(App.preference.text.favorite(true)),
      //   textAlign: TextAlign.center,
      // ),
      // footerOnPressed: () {
      //   App.route.pushNamed('home/bible');
      // },

      child: ViewBlockCard(
        child: ViewListBuilder(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return bookItem(
              index,
              items.elementAt(index),
            );
          },
          itemSeparator: (BuildContext context, int index) {
            return const ViewSectionDivider(
              primary: false,
            );
          },
          onEmpty: ViewButton(
            padding: const EdgeInsets.symmetric(vertical: 30),
            // child: ViewMark(
            //   label: App.preference.text.addTo(App.preference.text.favorite(true)),
            // ),
            child: Text(
              App.preference.text.addTo(App.preference.text.favorite(true)),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              App.route.pushNamed('home/bible');
            },
          ),
          itemCount: items.length,
        ),
      ),
    );
  }

  Widget bookItem(int index, BooksType book) {
    bool isAvailable = book.available > 0;
    bool isPrimary = book.identify == App.core.data.primaryId;
    return ListTile(
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
      // onTap: () => isAvailable ? showBible(book) : showMore(book),
      onTap: () {
        if (isAvailable) {
          showBibleContent(book);
        } else {
          showBibleInfo(book);
        }
      },
      onLongPress: () {
        showBibleInfo(book);
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

    return ViewSection(
      show: items.isNotEmpty,
      headerTitle: Text(
        App.preference.text.recentSearch(true),
      ),
      headerTrailing: ViewButton(
        message: App.preference.text.addTo(App.preference.text.recentSearch(true)),
        onPressed: () {
          App.route.pushNamed('home/recent-search');
        },
        child: const ViewMark(
          icon: Icons.more_horiz,
        ),
      ),
      child: ViewBlockCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            textDirection: TextDirection.ltr,
            children: items.take(3).map(
              (e) {
                return ViewButton(
                  style: state.theme.textTheme.bodyLarge,
                  child: ViewMark(
                    // padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    label: e.word,
                  ),
                  // onPressed: () => onSearch(e.value.word),
                  onPressed: () {
                    App.route.pushNamed(
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
  const PullToRefresh({Key? key}) : super(key: key);

  @override
  State<PullToActivate> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends PullOfState {
  // late final Core core = context.read<Core>();
  @override
  Future<void> refreshUpdate() async {
    await Future.delayed(const Duration(milliseconds: 50));
    await App.core.updateBookMeta();
    await Future.delayed(const Duration(milliseconds: 100));
    await App.core.data.updateToken();
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
