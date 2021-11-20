import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// import 'package:lidea/keepAlive.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/authentication.dart';
import 'package:lidea/cached_network_image.dart';
import 'package:lidea/hive.dart';

import 'package:bible/core.dart';
import 'package:bible/settings.dart';
import 'package:bible/widget.dart';
import 'package:bible/type.dart';

part 'bar.dart';
part 'refresh.dart';
part 'swipe.dart';
part 'modal.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/home/launch';
  static const icon = LideaIcon.home;
  static const name = 'Launch';
  static const description = '...';
  // static final uniqueKey = UniqueKey();
  // static final navigatorKey = GlobalKey<NavigatorState>();
  // static late final scaffoldKey = GlobalKey<ScaffoldState>();
  // static const scaffoldKey = Key('launch-adfeeppergt');

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late Core core;

  final scrollController = ScrollController();

  Authentication get authenticate => context.read<Authentication>();
  AppLocalizations get translate => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
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

  void toBible(BookType bible) async {
    if (Navigator.canPop(context)) {
      if (core.collection.parallelId != bible.identify) {
        core.collection.parallelId = bible.identify;
        core.notify();
      }
      if (!core.scripturePrimary.isReady) {
        core.message = 'a momment please';
      }
      core.navigate(at: 1);
      core.scriptureParallel.init().whenComplete(() {
        core.message = '';
      });
      Navigator.of(context).pop();
    } else {
      if (core.collection.primaryId != bible.identify) {
        core.collection.primaryId = bible.identify;
        core.notify();
      }
      if (!core.scripturePrimary.isReady) {
        core.message = 'a momment please';
      }
      core.navigate(at: 1);
      core.scripturePrimary.init().whenComplete(() {
        core.message = '';
      });

      // Scripture scripture = core.scripturePrimary;
      // if (scripture.isReady) {
      //   if (core.message.isNotEmpty){
      //     core.message ='';
      //   }
      // } else {
      //   core.message ='a momment plase';
      // }
      // if (core.collection.primaryId != bible.identify){
      //   core.collection.primaryId = bible.identify;
      // }
      // debugPrint('reader: ${core.scripturePrimary.isReady}');
      // core.scripturePrimary.init().catchError((e){
      //   debugPrint('scripturePrimary: $e');
      // }).whenComplete(
      //   (){
      //     core.message ='';
      //     debugPrint('reader: done');
      //   }
      // );
    }
  }

  // void onClearAll() {
  //   Future.microtask(() {});
  // }

  // void onSearch(String word) {}

  // void onDelete(String word) {
  //   Future.delayed(Duration.zero, () {});
  // }

  // bool get canPop => Navigator.of(context).canPop();
}

class _View extends _State with _Bar, _Refresh, _Modal {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      // key: widget.key,
      controller: scrollController,
      child: body(),
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        refresh(),
        ValueListenableBuilder(
          valueListenable: core.collection.boxOfBook.listenable(),
          builder: (BuildContext context, Box<BookType> items, Widget? child) {
            return bookList(items);
          },
        ),
      ],
    );
  }

  Widget bookList(Box<BookType> box) {
    // final items = box.toMap().entries.toList();
    final items = box.values.where((e) => e.selected);

    // items.sort((a, b) => a.value.order.compareTo(b.value.order));
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          // if items.isEmpty
          // if items.isNotEmpty
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 15, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // verticalDirection: VerticalDirection.up,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  translate.favorites,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  // color: Colors.amber,
                  // minSize: 30,
                  // alignment: Alignment.centerRight,
                  child: WidgetLabel(
                    icon: Icons.more_horiz,
                    iconColor: Theme.of(context).hintColor,
                  ),
                  // child: const Text('more'),
                  onPressed: () {
                    core.navigate(to: '/home/bible');
                  },
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            const Card(
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text('\n\n'),
              ),
            ),
          Card(
            clipBehavior: Clip.hardEdge,
            child: ListView.separated(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return bookItem(
                  index,
                  items.elementAt(index),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 0,
                );
              },
              itemCount: items.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget bookItem(int index, BookType book) {
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
      onTap: () => isAvailable ? toBible(book) : showModal(book),
    );
  }
}
