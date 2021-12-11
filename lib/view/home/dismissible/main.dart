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

  static const route = '/dismissible';
  static const icon = Icons.delete_sweep;
  static const name = 'Dismissible';
  static const description = '...';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();
  final GlobalKey<SliverReorderableListState> reorderableKey =
      GlobalKey<SliverReorderableListState>();

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
    super.dispose();
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onDelete(int index) {
    setState(() {
      itemList.removeAt(index);
    });
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return listContainer(index, itemList.elementAt(index));
            },
            childCount: itemList.length,
          ),
        ),
      ],
    );
  }

  Widget listContainer(int index, String item) {
    return Dismissible(
      key: Key(item),
      direction: DismissDirection.endToStart,
      // onDismissed: (direction) async {
      //   onDelete(index);
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$item dismissed')));
      // },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool? confirmation = await doConfirmWithDialog(
            context: context,
            message: 'Do you want to delete Index: "$index"?',
          );
          if (confirmation != null && confirmation) {
            onDelete(index);
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
        leading: Text('$index'),
        title: Text(item),
      ),
    );
  }
}
