import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

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

  static const route = '/blog';
  static const icon = Icons.low_priority_outlined;
  static const name = 'Blog';
  static const description = '...';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

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
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onClearAll() {
    Future.microtask(() {});
  }

  void onSearch(String word) {}

  void onDelete(String word) {
    Future.delayed(Duration.zero, () {});
  }
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
      // primary: true,
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              CupertinoButton(
                child: const Chip(
                  avatar: Icon(CupertinoIcons.back),
                  labelPadding: EdgeInsets.zero,
                  label: Text('Back'),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoButton(
                child: const Chip(
                  label: Text('Continue to article'),
                ),
                onPressed: () => core.navigate(to: '/article'),
              ),
              CupertinoButton(
                child: const Chip(
                  label: Text('Navigate to search'),
                ),
                onPressed: () => core.navigate(
                  to: '/search',
                  routePush: false,
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Card(
                margin: const EdgeInsets.all(15),
                // color: Colors.grey[100 * (index % 9 + 1)],
                color: Colors.grey[100 * (index % 5 + 1)],
                // alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  // height: 80,
                  child: Text(
                    "Item $index",
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              );
            },
            childCount: 1000,
          ),
        ),
      ],
    );
  }
}
