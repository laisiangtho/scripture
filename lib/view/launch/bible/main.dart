import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:lidea/keepAlive.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/widget/main.dart';
import '/type/main.dart';

part 'bar.dart';
part 'refresh.dart';
part 'swipe.dart';
part 'modal.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/home/bible';
  static const icon = LideaIcon.book;
  static const name = 'Bible';
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
  final GlobalKey<SliverReorderableListState> _kList = GlobalKey<SliverReorderableListState>();

  Preference get preference => core.preference;

  late final AnimationController dragController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  late final Animation<double> dragAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(dragController);
  late final Animation<Color?> colorAnimation = ColorTween(
    begin: null,
    end: Theme.of(context).highlightColor,
  ).animate(dragController);

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
    // Future.microtask((){});
  }

  @override
  void dispose() {
    dragController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onSort() {
    if (dragController.isCompleted) {
      dragController.reverse();
    } else {
      dragController.forward();
    }
  }

  void toBible(int index, BookType bible) async {
    // bible.selected = !bible.selected;
    // core.collection.boxOfBook.putAt(index, bible);

    // if (Navigator.canPop(context)) {
    //   if (core.collection.parallelId != bible.identify) {
    //     core.collection.parallelId = bible.identify;
    //     core.notify();
    //   }
    //   if (!core.scripturePrimary.isReady) {
    //     core.message = 'a momment please';
    //   }
    //   core.navigate(at: 1);
    //   core.scriptureParallel.init().whenComplete(() {
    //     core.message = '';
    //   });
    //   Navigator.of(context).pop();
    // } else {
    //   if (core.collection.primaryId != bible.identify) {
    //     core.collection.primaryId = bible.identify;
    //     core.notify();
    //   }
    //   if (!core.scripturePrimary.isReady) {
    //     core.message = 'a momment please';
    //   }
    //   core.navigate(at: 1);
    //   core.scripturePrimary.init().whenComplete(() {
    //     core.message = '';
    //   });
    // }

    if (widget.arguments == null) {
      if (core.collection.parallelId != bible.identify) {
        core.collection.parallelId = bible.identify;
        core.notify();
      }
      if (!core.scripturePrimary.isReady) {
        core.message = preference.text.aMoment;
      }
      core.navigate(at: 1);
      core.scriptureParallel.init().whenComplete(() {
        core.message = '';
      });
      Navigator.of(context).pop();
    } else {
      bible.selected = !bible.selected;
      core.collection.boxOfBook.putAt(index, bible);
    }
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
    return Scaffold(
      body: ViewPage(
        // key: widget.key,
        controller: scrollController,
        child: body(),
      ),
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
    // final items = box.values.where((e) => e.selected);
    // items.sort((a, b) => a.value.order.compareTo(b.value.order));
    return SliverReorderableList(
      key: _kList,
      itemBuilder: (BuildContext context, int index) => bookContainer(index, box.getAt(index)!),
      itemCount: box.length,
      onReorder: (int oldIndex, int newIndex) async {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        if (oldIndex == newIndex) return;

        // final oldItem = box.getAt(oldIndex)!.copyWith(order:oldIndex);
        // final newItem = box.getAt(newIndex)!.copyWith(order:newIndex);
        // box.putAt(oldIndex, newItem);
        // box.putAt(newIndex, oldItem);

        // final items = box.toMap().values.toList();
        final items = box.values.toList();
        items.insert(newIndex, items.removeAt(oldIndex));
        box.putAll(items.asMap());
      },
    );
  }

  Widget bookContainer(int index, BookType book) {
    return SwipeForMore(
      key: Key('$index'),
      child: Card(
        elevation: 0.5,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: bookItem(index, book),
      ),
      menu: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(5),
            ),
            // color: Theme.of(context).primaryColorLight,
            color: Theme.of(context).focusColor,
          ),
          child: Tooltip(
            message: preference.text.more,
            child: CupertinoButton(
              child: const Icon(
                LideaIcon.dotHoriz,
                // color: Theme.of(context).primaryColor,
                // color: Theme.of(context).hintColor,
              ),
              onPressed: () => showModal(book),
            ),
          ),
        ),
      ],
    );
  }

  Widget bookItem(int index, BookType book) {
    bool isAvailable = book.available > 0;
    bool isPrimary = book.identify == core.collection.primaryId;
    return ListTile(
      enabled: true,
      // selected: true,
      /*
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Icon(
                Icons.check_circle,
                size: 20,
                color: book.selected
                    ? Theme.of(context).highlightColor
                    : Theme.of(context).disabledColor,
              ),
            ),
            Text(
              // book.name,
              'oerdlgj sld jgalsjflasdf jlasdfasf jasldjfasl jfasd',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              semanticsLabel: book.name,
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 20,
                    fontWeight: isAvailable ? FontWeight.w400 : FontWeight.w300,
                    // color: isAvailable?Colors.black:Colors.grey,
                  ),
            ),
          ],
        ),
      ),
      */
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: DefaultTextStyle(
          child: Text(book.name),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 20,
                fontWeight: isAvailable ? FontWeight.w400 : FontWeight.w300,
                // color: isAvailable?Colors.black:Colors.grey,
              ),
        ),

        // child: Text(
        //   book.name,
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        //   semanticsLabel: book.name,
        //   style: DefaultTextStyle.of(context).style.copyWith(
        //         fontSize: 20,
        //         fontWeight: isAvailable ? FontWeight.w400 : FontWeight.w300,
        //         // color: isAvailable?Colors.black:Colors.grey,
        //       ),
        // ),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 7),
          //   child: Icon(
          //     Icons.check_circle,
          //     size: 20,
          //     color: book.selected
          //         ? Theme.of(context).highlightColor
          //         : Theme.of(context).disabledColor,
          //   ),
          // ),
          // Container(
          //   constraints: const BoxConstraints(
          //     minWidth: 30.0,
          //     minHeight: 20,
          //   ),
          //   // padding: const EdgeInsets.symmetric(vertical: 2),
          //   margin: const EdgeInsets.only(right: 7),
          //   decoration: BoxDecoration(
          //     borderRadius: const BorderRadius.all(Radius.circular(3)),
          //     color: book.selected
          //         ? Theme.of(context).highlightColor
          //         : Theme.of(context).disabledColor,
          //   ),
          //   child: Icon(
          //     Icons.favorite,
          //     size: 18,
          //     color: book.selected
          //         ? Theme.of(context).primaryColor
          //         : Theme.of(context).primaryColorDark,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: Icon(
              Icons.favorite,
              size: 18,
              color: book.selected
                  ? Theme.of(context).highlightColor
                  : Theme.of(context).primaryColorDark,
            ),
          ),
          Container(
            constraints: const BoxConstraints(
              minWidth: 37.0,
              // minHeight: 20,
            ),
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
            margin: const EdgeInsets.only(right: 7),
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
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 12,
                    color: isAvailable ? Theme.of(context).primaryColor : null,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              book.shortname,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedBuilder(
            animation: dragController,
            builder: (context, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                child: dragAnimation.isCompleted ? dragHandler(index) : child!,
              );
            },
            child: Text(
              book.year.toString(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 16,
                    color: isAvailable ? null : Theme.of(context).hintColor,
                  ),
            ),
          ),
        ],
      ),
      // onTap: () => isAvailable ? toBible(book) : showModal(book),
      onTap: () => toBible(index, book),
    );
  }

  Widget dragHandler(int index) {
    return ReorderableDragStartListener(
      index: index,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Icon(
          Icons.drag_handle_rounded,
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }
}
