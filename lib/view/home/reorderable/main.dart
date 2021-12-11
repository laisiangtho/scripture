import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

// import 'package:lidea/hive.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
import 'package:lidea/view.dart';
// import 'package:lidea/icon.dart';

import 'package:bible/core.dart';
import 'package:bible/settings.dart';
import 'package:bible/widget.dart';
// import 'package:bible/type.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.settings, this.navigatorKey, this.arguments}) : super(key: key);

  final SettingsController? settings;
  final GlobalKey<NavigatorState>? navigatorKey;
  final Object? arguments;

  static const route = '/reorderable';
  static const icon = Icons.sort;
  static const name = 'Reorderable';
  static const description = '...';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();
  final GlobalKey<SliverReorderableListState> _kList = GlobalKey<SliverReorderableListState>();

  late final AnimationController dragController = AnimationController(
    duration: const Duration(milliseconds: 500),
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

  late Core core;

  ViewNavigationArguments get arguments => widget.arguments as ViewNavigationArguments;
  // AudioAlbumType get album => arguments.meta as AudioAlbumType;

  // SettingsController get settings => context.read<SettingsController>();
  AppLocalizations get translate => AppLocalizations.of(context)!;
  // Authentication get authenticate => context.read<Authentication>();

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
  }

  @override
  void dispose() {
    dragController.dispose();
    super.dispose();
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onSort() {
    debugPrint('sorting');
    // if ()
    // dragController.forward()
    if (dragController.isCompleted) {
      dragController.reverse();
    } else {
      dragController.forward();
    }
  }

  final List<String> itemList = List<String>.generate(20, (i) => "Item ${i + 1}");
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      body: ViewPage(
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
        SliverReorderableList(
          key: _kList,
          itemBuilder: (BuildContext _, int i) => listContainer(i, itemList.elementAt(i)),
          itemCount: itemList.length,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            if (oldIndex == newIndex) return;

            final String item = itemList.removeAt(oldIndex);
            itemList.insert(newIndex, item);

            // NOTE: hiveDB
            // final itemList = box.toMap().values.toList();
            // itemList.insert(newIndex, itemList.removeAt(oldIndex));
            // box.putAll(itemList.asMap());
          },
        ),
      ],
    );
  }

  Widget listContainer(int index, String item) {
    // return ListTile(
    //   key: Key('$index'),
    //   title: Text(item),
    //   leading: Text('$index'),
    //   trailing: dragHandler(index),
    // );
    return SwipeForMore(
      key: Key('$index'),
      child: ListTile(
        title: Text(item),
        leading: Text('$index'),
        trailing: dragHandler(index),
      ),
      menu: <Widget>[
        Container(
          color: Colors.black26,
          child: const IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: null,
          ),
        ),
        Container(
          color: Colors.red,
          child: const IconButton(
            icon: Icon(Icons.access_alarms_rounded),
            onPressed: null,
          ),
        ),
      ],
    );
  }

  Widget dragHandler(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizeTransition(
          sizeFactor: dragAnimation,
          axisAlignment: 0.5,
          child: ReorderableDragStartListener(
            index: index,
            child: Icon(
              Icons.drag_handle_rounded,
              color: Theme.of(context).highlightColor,
            ),
          ),
        ),
      ],
    );
  }
}

class SwipeForMore extends StatefulWidget {
  const SwipeForMore({
    Key? key,
    required this.child,
    required this.menu,
    this.dx = 0.2,
  }) : super(key: key);

  final Widget child;
  final List<Widget> menu;
  final double dx;

  @override
  _SwipeForMoreState createState() => _SwipeForMoreState();
}

class _SwipeForMoreState extends State<SwipeForMore> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final offset = Tween(
    begin: const Offset(0.0, 0.0),
    end: Offset(-(widget.dx * widget.menu.length), 0.0),
  ).animate(
    CurveTween(curve: Curves.linear).animate(controller),
  );

  late final double = Tween(
    begin: 0.7,
    end: 1.0,
  ).animate(CurveTween(curve: Curves.easeIn).animate(controller));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (data) {
        controller.value -= (data.primaryDelta! / context.size!.width / 0.3);
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity! > 2500) {
          controller.animateTo(.0, duration: const Duration(milliseconds: 200));
        } else if (controller.value >= .3 || data.primaryVelocity! < -2500) {
          controller.animateTo(1.0, duration: const Duration(milliseconds: 200));
        } else {
          controller.animateTo(.0, duration: const Duration(milliseconds: 200));
        }
      },
      onLongPress: () {
        if (controller.isCompleted) {
          controller.reverse();
        } else if (controller.isDismissed) {
          controller.forward();
        }
      },
      child: Stack(
        children: <Widget>[
          SlideTransition(position: offset, child: widget.child),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Stack(
                      alignment: const Alignment(0, 0),
                      children: <Widget>[
                        Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * offset.value.dx * -1,
                          child: SizedBox(
                            // color: Colors.black26,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: widget.menu.map((item) {
                                return Expanded(
                                  child: FadeTransition(opacity: double, child: item),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
