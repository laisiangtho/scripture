import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
// import 'package:scripture/widget/button.dart';

import '../../app.dart';
import '/widget/profile_icon.dart';
// import '/widget/button.dart';

part 'state.dart';
part 'header.dart';

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
    debugPrint('home->build');

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('abc'),
      // ),
      body: Views(
        child: CustomScrollView(
          // physics: const AlwaysScrollableScrollPhysics(),
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

      // const SliverFillRemaining(),
      // SliverConstrainedCrossAxis(maxExtent: maxExtent, sliver: sliver)
      // SliverCrossAxisExpanded(flex: flex, sliver: sliver)
      // SliverCrossAxisGroup(slivers: slivers)

      const PullToRefresh(),
      // SliverToBoxAdapter(
      //   child: RefreshIndicator(
      //     color: Colors.white,
      //     backgroundColor: Colors.blue,
      //     onRefresh: () async {
      //       debugPrint('RefreshIndicator');
      //       return Future<void>.delayed(const Duration(seconds: 3));
      //     },
      //     notificationPredicate: (ScrollNotification notification) {
      //       return notification.depth == 1;
      //     },
      //     child: const Text('RefreshIndicator'),
      //   ),
      // ),

      // ViewBlockCard(
      //   child: ListVi,
      // ),

      // featureWidget(),
      // SliverToBoxAdapter(
      //   child: Container(
      //     height: 100.0,
      //     child: ListView.builder(
      //       scrollDirection: Axis.horizontal,
      //       itemCount: 10,
      //       itemBuilder: (context, index) {
      //         return Container(
      //           width: 100.0,
      //           child: const Card(
      //             child: Text('data'),
      //           ),
      //         );
      //       },
      //     ),
      //   ),
      // ),
      // testWidget(),
      ViewFlats(
        child: SizedBox(
          height: 130.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ViewCards(
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 250,
                  // child: Text('abc...'),
                  child: ListTile(
                    title: const Text('File (test)'),
                    // subtitle: const Text('...'),
                    onTap: () async {
                      //  App.core.u
                      // final docs = Docs.user;
                      // docs.dir.then((e) {
                      //   final test = e != null;
                      //   debugPrint('file test: $test');
                      //   if (test) {
                      //     debugPrint('file test: ${e.path}/test.txt');
                      //     // docs.writeAsJSON('test.json', {"done": true});
                      //     docs.writeAsString('test.txt', 'Ok');
                      //   }
                      // });

                      core.scripturePrimary.marks.backup();
                      // if (docs != null) {
                      //   final dir = docs.path;
                      //   // join(await directory.then((e) => e.path), name);
                      //   debugPrint('file: $dir');
                      //   debugPrint('file: ${docs.absolute.uri}');
                      //   // join(await directory.then((e) => e.path), name);
                      // }
                    },
                  ),
                ),
              ),
              ViewCards(
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 250,
                  // child: Text('abc...'),
                  child: ListTile(
                    title: const Text('Card (test)'),
                    // subtitle: const Text('...'),
                    onTap: () {
                      App.route.pushNamed('home/test-card');
                    },
                  ),
                ),
              ),
              ViewCards(
                elevation: 0,
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 250,
                  // child: Text('abc...'),
                  child: ListTile(
                    title: const Text('OfBook (test)'),
                    // subtitle: const Text('...'),
                    onTap: () {
                      App.core.scripturePrimary.init().then((e) {
                        // final src = e.book;

                        // src.first.chapterCount;

                        // debugPrint('bookTesting ${src.length}');
                        // debugPrint('bookTesting name:${src.first.info.name}');
                        // debugPrint('bookTesting chapterCount:${src.first.chapterCount}');
                        // final res = src.where((b) {
                        //   return b.chapter.where((c) {
                        //     return c.verse.where((v) {
                        //       return v.contains('ki');
                        //     }).isNotEmpty;
                        //   }).isNotEmpty;
                        // });
                        // debugPrint('bookTesting search:${res.length}');
                        // final cur = src.where((b) {
                        //   return b.chapter.where((c) {
                        //     return b.id == 2 && c.id == 4;
                        //   }).isNotEmpty;
                        // });
                        // final cur = src.where((b) {
                        //   return b.id == 2;
                        // }).map((b) {
                        //   return b.chapter.where((c) => c.id == 4);
                        // });
                        // var cur = src.where((b) {
                        //   if (b.id == 2) {
                        //     return b.chapter.where((c) {
                        //       return c.id == 4;
                        //     }).isNotEmpty;
                        //   }
                        //   return false;
                        // });

                        // I need your help of searching this similar data using Dart language.
                        // [
                        //   {
                        //     bookid:1,
                        //     chapter: [1,2,3],
                        //   },
                        //   {
                        //     bookid:3,
                        //     chapter: [3,4,6],
                        //   },
                        //   {
                        //     bookid:6,
                        //     chapter: [5,6,7],
                        //   }
                        // ]

                        // Let say I am searching for bookid:3 then look for chapter:6, and
                        // want the result in the same format
                        // eg. result
                        // [
                        //   {
                        //     bookid:3,
                        //     chapter: [6],
                        //   },
                        // ]

                        // final cur = e.book.where((b) => b.info.id == 4).map((e) {
                        //   return e.getChapter(5);
                        // });

                        // debugPrint('bookTesting current count:${cur.length}');

                        // for (var b in cur) {
                        //   debugPrint('bookTesting current book:${b.info.name}');
                        //   for (var c in b.chapter) {
                        //     debugPrint('bookTesting current chapter:${c.name}');
                        //     for (var v in c.verse) {
                        //       debugPrint('bookTesting current verse:${v.name}');
                        //     }
                        //   }
                        // }

                        final res = e.getChapter(2, 1);

                        debugPrint('test: fold ${res.totalChapter} == 1');
                        debugPrint('test: fold ${res.totalVerse} == 22');
                      });
                    },
                  ),
                ),
              ),
              ViewCards(
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 250,
                  // child: Text('abc...'),
                  child: ListTile(
                    title: const Text('Sliver (test)'),
                    // subtitle: const Text('...'),
                    onTap: () {
                      App.route.pushNamed('home/test-sliver');
                    },
                  ),
                ),
              ),
              ViewCards(
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 250,
                  // child: Text('abc...'),
                  child: ListTile(
                    title: const Text('Search (test)'),
                    // subtitle: const Text('...'),
                    onTap: () {
                      App.route.pushNamed('home/test-search');
                    },
                  ),
                ),
              ),
              ViewCards(
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 250,
                  // child: Text('abc...'),
                  child: ListTile(
                    title: const Text('Section (test)'),
                    subtitle: const Text('preferred language'),
                    onTap: () {
                      App.route.pushNamed('home/leaf-section');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ViewFlatBuilder(
      //   child: featureWidget(),
      // ),
      // featureWidget(),

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

  Widget testWidget() {
    return SliverList.list(
      children: [
        ListTile(
          title: const Text('Test Groups'),
          onTap: () {
            App.route.pushNamed('home/test-group');
            // Navigator.of(context).pushNamed('/test-group');
            // Navigator.of(context, rootNavigator: true).pushNamed('/test-group');
          },
        ),
        ListTile(
          title: const Text('Sliver Tools (sticky)'),
          onTap: () {
            App.route.pushNamed('home/test-sticky');
          },
        ),
        ListTile(
          title: const Text('Book (sticky)'),
          onTap: () {
            App.route.pushNamed('home/test-book');
          },
        ),
        ListTile(
          title: const Text('Title (sticky, browse)'),
          onTap: () {
            App.route.pushNamed('home/test-title');
          },
        ),
        ListTile(
          title: const Text('Section (sticky, browse)'),
          onTap: () {
            App.route.pushNamed('home/test-section');
          },
        ),
      ],
    );
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
      sliver: true,
      // headerLeading: const Icon(Icons.ac_unit),
      headerTitle: Text(
        App.preference.text.favorite('true'),
        style: state.textTheme.titleSmall,
      ),

      headerTrailing: ViewButton(
        show: items.isNotEmpty,
        message: App.preference.text.addTo(App.preference.text.favorite('true').toLowerCase()),
        onPressed: () {
          App.route.pushNamed('home/bible');
        },
        child: ViewMark(
          icon: LideaIcon.dotHoriz,
          iconSize: 19,
          iconColor: state.theme.hintColor,
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
          App.preference.text.addMore(App.preference.text.favorite('true').toLowerCase()),
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
          onEmpty: ViewButton(
            padding: const EdgeInsets.symmetric(vertical: 30),
            // child: ViewMark(
            //   label: App.preference.text.addTo(App.preference.text.favorite(true)),
            // ),
            child: Text(
              App.preference.text.addTo(App.preference.text.favorite('true')),
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

  Widget bookItem(int index, MapEntry<dynamic, BooksType> item) {
    final book = item.value;
    bool isAvailable = book.available > 0;
    bool isPrimary = book.identify == App.core.data.primaryId;
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
        App.preference.text.recentSearch('true'),
        style: state.textTheme.titleSmall,
      ),
      headerTrailing: ViewButton(
        message: App.preference.text.addTo(App.preference.text.recentSearch('true')),
        onPressed: () {
          App.route.pushNamed('home/recent-search');
        },
        child: ViewMark(
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

// RefreshIndicator(
//         color: Colors.white,
//         backgroundColor: Colors.blue,
//         onRefresh: () async {
//           debugPrint('RefreshIndicator');
//           return Future<void>.delayed(const Duration(seconds: 3));
//         },
//         notificationPredicate: (ScrollNotification notification) {
//           // return notification.depth == 1;
//           return true;
//         },
//         child: Views(
//           child: CustomScrollView(
//             // physics: const AlwaysScrollableScrollPhysics(),
//             controller: _controller,
//             slivers: _slivers,
//           ),
//         ),
//       )