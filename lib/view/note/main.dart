import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

// import 'package:lidea/intl.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';
import 'package:lidea/authentication.dart';
import 'package:lidea/icon.dart';

import 'package:bible/core.dart';
import 'package:bible/settings.dart';
import 'package:bible/widget.dart';
import 'package:bible/type.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.settings, this.navigatorKey}) : super(key: key);
  final SettingsController? settings;
  final GlobalKey<NavigatorState>? navigatorKey;

  static const route = '/note';
  static const icon = LideaIcon.listNested;
  static const name = 'Note';
  static const description = 'Note';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late final Core core = context.read<Core>();
  late final SettingsController settings = context.read<SettingsController>();
  // late final AppLocalizations translate = AppLocalizations.of(context)!;
  late final Authentication authenticate = context.read<Authentication>();
  late final scrollController = ScrollController();
  // late final Future<DefinitionBible> _initiator = core.scripturePrimary.init();

  // SettingsController get settings => context.read<SettingsController>();
  AppLocalizations get translate => AppLocalizations.of(context)!;
  // Authentication get authenticate => context.read<Authentication>();

  @override
  void initState() {
    super.initState();
    // Future.microtask((){});
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onDeleteAll() {
    doConfirmWithDialog(
      context: context,
      message: translate.confirmToDelete('all'),
      title: translate.confirmation,
      cancel: translate.cancel,
      confirm: translate.confirm,
    ).then((confirmation) {
      if (confirmation != null && confirmation) {
        core.clearBookmarkWithNotify();
      }
    });
  }

  void onSearch(String word) {}

  void onNav(int book, int chapter) {
    // NotifyNavigationButton.navigation.value = 1;
    core.chapterChange(bookId: book, chapterId: chapter);
    Future.delayed(const Duration(milliseconds: 150), () {
      // core.definitionGenerate(word);
      core.navigate(at: 1);
    });
    // Future.delayed(Duration.zero, () {
    //   core.historyAdd(word);
    // });
  }

  Future<bool> onDelete(int index) {
    // Future.microtask((){});
    // Future.delayed(Duration.zero, () {
    //   core.collection.bookmarkDelete(index);
    // });
    // Do you want to delete this Bookmark?
    // Do you want to delete all the Bookmarks?
    return doConfirmWithDialog(
      context: context,
      // message: 'Do you want to delete this Bookmark?',
      message: translate.confirmToDelete(''),
      title: translate.confirmation,
      cancel: translate.cancel,
      confirm: translate.confirm,
    ).then((confirmation) {
      if (confirmation != null && confirmation) {
        core.deleteBookmarkWithNotify(index);
        return true;
      }
      return false;
    });
  }
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<DefinitionBible>(
    //   future: _initiator,
    //   builder: (BuildContext context, AsyncSnapshot<DefinitionBible> snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    //         // return reader();
    //         return messageContainer('Done');
    //       default:
    //         return messageContainer('A moment');
    //     }
    //   },
    // );
    return ViewPage(
      key: widget.key,
      controller: scrollController,
      child: body(),
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      // primary: true,
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        // SliverList(
        //   delegate: SliverChildListDelegate(
        //     <Widget>[
        //       CupertinoContextMenu(
        //         child: Container(
        //           color: Colors.red,
        //           child: const Text('asdf'),
        //         ),
        //         actions: <Widget>[
        //           CupertinoContextMenuAction(
        //             child: const Text('Action one'),
        //             onPressed: () {
        //               Navigator.pop(context);
        //             },
        //           ),
        //           CupertinoContextMenuAction(
        //             child: const Text('Action two'),
        //             onPressed: () {
        //               Navigator.pop(context);
        //             },
        //           ),
        //         ],
        //       ),
        //       Text(translate.bookmarkPlural(0)),
        //       Text(translate.bookmarkPlural(1)),
        //       Text(translate.bookmarkPlural(2)),
        //       Text(translate.bookmarkCount(0)),
        //       Text(translate.bookmarkCount(1)),
        //       Text(translate.bookmarkCount(2)),
        //     ],
        //   ),
        // ),
        Selector<Core, List<MapEntry<dynamic, BookmarkType>>>(
          selector: (_, e) => e.collection.boxOfBookmark.toMap().entries.toList(),
          builder: (BuildContext _, List<MapEntry<dynamic, BookmarkType>> items, Widget? child) {
            if (items.isNotEmpty) {
              return listContainer(items);
            }
            return child!;
            // return listContainer(items);
          },
          child: messageContainer(translate.bookmarkCount(0)),
        ),
      ],
    );
  }

  Widget messageContainer(String message) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(message),
      ),
    );
  }

  Widget listContainer(Iterable<MapEntry<dynamic, BookmarkType>> box) {
    // return SliverList(
    //   delegate: SliverChildBuilderDelegate(
    //     (BuildContext context, int index) => itemContainer(index, box.elementAt(index)),
    //     childCount: box.length > 30 ? 30 : box.length,
    //   ),
    // );
    return SliverToBoxAdapter(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return itemContainer(index, box.elementAt(index));
          },
          separatorBuilder: (_, index) {
            return const Divider(
              height: 0,
            );
          },
          itemCount: box.length,
        ),
      ),
    );
  }

  Dismissible itemContainer(int index, MapEntry<dynamic, BookmarkType> bookmark) {
    final abc = core.scripturePrimary.bookById(bookmark.value.bookId);
    return Dismissible(
      // key: Key(index.toString()),
      key: Key(bookmark.value.date.toString()),
      direction: DismissDirection.endToStart,
      child: ListTile(
        // contentPadding: EdgeInsets.zero,
        title: Text(
          // history.value.word,
          abc.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // style: TextStyle(
          //   fontSize: 20,
          //   // color: Theme.of(context).textTheme.caption!.color,
          //   color: Theme.of(context).primaryTextTheme.button!.color,
          //   fontWeight: FontWeight.w300,
          // ),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        minLeadingWidth: 10,
        leading: const Icon(Icons.bookmark_added),
        trailing: Chip(
          avatar: Text(
            core.scripturePrimary.digit(bookmark.value.chapterId),
            style: const TextStyle(fontSize: 18),
          ),
          label: Text(
            core.scripturePrimary.digit(abc.chapterCount),
            style: const TextStyle(fontSize: 18),
          ),
        ),
        onTap: () => onNav(
          bookmark.value.bookId,
          bookmark.value.chapterId,
        ),
      ),
      background: dismissiblesFromRight(),
      // secondaryBackground: dismissiblesFromLeft(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await onDelete(index);
        } else {
          // Navigate to edit page;
        }
      },
    );
  }

  Widget dismissiblesFromRight() {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 0),
      color: Theme.of(context).errorColor,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              translate.delete,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
