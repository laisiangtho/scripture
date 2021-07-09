import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';
import 'package:lidea/idea.dart';

import 'package:bible/core.dart';
import 'package:bible/widget.dart';
// import 'package:bible/icon.dart';
// import 'package:bible/model.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  Main({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();

  late Core core;
  // late AnimationController animationController;

  int testCounter = 0;
  final List<String> themeName = ["System","Light","Dark"];

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
    // animationController = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 400),
    // );
    // animationController.animateTo(1.0);
  }

  @override
  dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }
}

class View extends _State with _Bar {

  @override
  Widget build(BuildContext context) {
    return ViewPage(
      key: widget.key,
      // controller: scrollController,
      child: Selector<Core,bool>(
        selector: (_, e) => e.nodeFocus,
        builder: (BuildContext context, bool focus, Widget? child) => NestedScrollView(
          floatHeaderSlivers: true,
          controller: scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          // dragStartBehavior: DragStartBehavior.start,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
            bar(innerBoxIsScrolled),
          ],
          body:body()
        ),
      )
    );
  }

  Widget body() {
    return CustomScrollView(
      // controller: scrollController,
      primary: true,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        new SliverToBoxAdapter(
          child: buildMode()
        ),
        // new SliverToBoxAdapter(
        //   child: Selector<Core,String>(
        //     selector: (_, e) => e.store.message,
        //     builder: (BuildContext context, String message, Widget? child) {
        //       return ElevatedButton(
        //         child: Text('Message: $message'),
        //         onPressed: (){
        //           context.read<Core>().store.testUpdate('Yes');
        //         }
        //       );
        //     }
        //   )
        // ),
        // Selector<Core,String>(
        //   selector: (_, e) => e.store.message,
        //   builder: (BuildContext context, String message, Widget? child) {
        //     return ElevatedButton(
        //        child: Text('Message: $message'),
        //        onPressed: (){
        //          context.read<Core>().store.testUpdate('Yes');
        //        }
        //     );
        //   }
        // )
      ]
    );
  }

  Widget buildMode() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7.0))
      ),
      elevation: 2,
      margin: EdgeInsets.all(12.0),
      // child: Text('abc'),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Semantics(
                label: "Switch theme mode",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb,size:20),
                    Text('Switch theme',
                      style: TextStyle(
                        fontSize: 20
                      )
                    )
                  ],
                ),
              )
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ThemeMode.values.map<Widget>((e){
                  bool active = IdeaTheme.of(context).themeMode == e;
                  // IdeaTheme.update(context,IdeaTheme.of(context).copyWith(themeMode: ThemeMode.system));
                  return Semantics(
                    label: "Switch to",
                    selected: active,
                    child: CupertinoButton(
                      borderRadius: new BorderRadius.circular(30.0),
                      padding: EdgeInsets.symmetric(vertical:5, horizontal:10),
                      // minSize: 20,
                      // color: Theme.of(context).primaryColorDark,
                      child: Text(
                        themeName[e.index],
                        semanticsLabel: themeName[e.index],
                      ),
                      onPressed: active?null:()=>IdeaTheme.update(context,IdeaTheme.of(context).copyWith(themeMode: e))
                    ),
                  );
                }).toList()
              )
            )
          ]
        ),
      )
    );
  }
}
