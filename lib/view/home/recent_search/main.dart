import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

// import 'package:lidea/hive.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
import 'package:lidea/view.dart';
import 'package:lidea/icon.dart';

import 'package:bible/core.dart';
import 'package:bible/settings.dart';
import 'package:bible/widget.dart';
import 'package:bible/type.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({
    Key? key,
    this.settings,
    this.navigatorKey,
    this.arguments,
  }) : super(key: key);

  final SettingsController? settings;
  final GlobalKey<NavigatorState>? navigatorKey;
  final Object? arguments;

  static const route = '/recent-search';
  static const icon = Icons.manage_search_rounded;
  static const name = 'Recent search';
  static const description = '...';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

  late Core core;

  // SettingsController get settings => SettingsController.of(context);
  AppLocalizations get translate => AppLocalizations.of(context)!;

  ViewNavigationArguments get arguments => widget.arguments as ViewNavigationArguments;
  // AudioAlbumType get album => arguments.meta as AudioAlbumType;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onSearch(String word) {
    // core.navigate(to: '/search/result', routePush: true);
    // core.navigate(to: '/search/result', routePush: true);
    core.collection.searchQuery = word;
    // core.conclusionGenerate().whenComplete(() => core.navigate(to: '/search/result'));
    // core.navigate(to: '/search/result');
    Future.delayed(const Duration(milliseconds: 300), () {
      core.navigate(to: '/search/result');
    });
  }

  void onDelete(String word) {
    Future.delayed(Duration.zero, () {
      core.collection.recentSearchDelete(word);
    }).whenComplete(core.notify);
  }

  void onClearAll() {
    Future.microtask(() {
      core.collection.boxOfRecentSearch.clear().whenComplete(core.notify);
    });
  }
}

// FlutterError (A dismissed Dismissible widget is still part of the tree.
// Make sure to implement the onDismissed handler and to immediately remove the Dismissible widget from the application once that handler has fired.
class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      // key: widget.key,
      controller: scrollController,
      // child: body(),
      child: Selector<Core, List<MapEntry<dynamic, RecentSearchType>>>(
        selector: (_, e) => e.collection.recentSearches.toList(),
        builder: (BuildContext _, List<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
          return body(items);
        },
      ),
    );
  }

  CustomScrollView body(List<MapEntry<dynamic, RecentSearchType>> items) {
    items.sort((a, b) => b.value.date!.compareTo(a.value.date!));
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        bar(items.isNotEmpty),
        if (items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('...')),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return listContainer(index, items.elementAt(index));
              },
              childCount: items.length,
            ),
          ),
      ],
    );
  }

  Widget listContainer(int index, MapEntry<dynamic, RecentSearchType> item) {
    final keyWord = item.value.word;
    return Dismissible(
      key: Key(item.value.date.toString()),
      // key: UniqueKey(),
      direction: DismissDirection.endToStart,
      // onDismissed: (direction) async {
      //   onDelete(index);
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$item dismissed')));
      // },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool? confirmation = await doConfirmWithDialog(
            context: context,
            message: 'Do you want to delete "$keyWord"?',
          );
          if (confirmation != null && confirmation) {
            onDelete(keyWord);
            return true;
          } else {
            return false;
          }
        }
      },
      // Show a red background as the item is swiped away.
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(CupertinoIcons.delete_simple),
      ),
      child: ListTile(
        leading: const Icon(Icons.manage_search_rounded),
        minLeadingWidth: 10,
        title: Text(keyWord),
        trailing: (item.value.hit > 1)
            ? Chip(
                avatar: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.saved_search_outlined),
                ),
                label: Text(item.value.hit.toString()),
              )
            : const SizedBox(),
        onTap: () => onSearch(keyWord),
      ),
    );
  }
}
