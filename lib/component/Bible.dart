import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'scroll.dart';

class Bible extends StatefulWidget {
  Bible({Key key}) : super(key: key);

  @override
  _PageView createState() => new _PageView();
}

abstract class _PageState extends State<Bible> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Bible> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // ScrollController scrollController = ScrollController(initialScrollOffset:0,keepScrollOffset:true);
  GlobalKey keyBookButton = new GlobalKey();
  GlobalKey keyChapterButton = new GlobalKey();
  // PersistentBottomSheetController<void> bottomSheetOption;
  // NAME activeName;
  // List<String> selectedVerse=[];

  final controller = ScrollController();


  @override
  // @mustCallSuper
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // scrollController.addListener(() => store.scrollPosition(scrollController));
    // controller.addListener(() { setState((){});});
  }

  @override
  dispose() {
    controller.dispose();
    // controller.master.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

}

class _PageView extends _PageState {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return _body();
    return Scaffold(
      body: ScrollPage(
        controller: controller,
        child: _body(),
      ),
    );
    // return new Scaffold(
    //   key: scaffoldKey,
    //   body: _body(),
    //   // extendBody: true,
    //   // bottomNavigationBar: bottomStack()
    // );
  }

  Widget _body() {
    return CustomScrollView(
      // controller: controller.master,
      // controller: controller,

      // shrinkWrap: true,
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating:true,delegate: new ScrollPageBarDelegate(bar)),
        new SliverPadding(
          // padding: EdgeInsets.only(bottom: store.contentBottomPadding),
          padding: EdgeInsets.only(bottom: controller.bottom.height),
          // sliver: SliverToBoxAdapter(
          //   child: Center(
          //     child: Text('hello')
          //   )
          // )
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _listItem(context, index),
              childCount: 103,
            ),
          ),
        )
        // SliverList(
        //   delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        //     return Container(
        //       height: 200,
        //       color: Color(Random().nextInt(0xffffffff)),
        //     );
        //   },
        //   )
        // )
      ]
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double percentage){
    return Container(
      height: 70,
      child: Center(child: Text('Okey $percentage'))
    );
  }

  Widget _listItem(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 23),
      color: Color(Random().nextInt(0xffffffff)),
      child: Center(child: Text("Bible $index")),
    );
  }
}
