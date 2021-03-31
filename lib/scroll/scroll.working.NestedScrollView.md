import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'scroll.dart';


class PageNestedScrollView extends StatefulWidget {
  PageNestedScrollView({Key key}) : super(key: key);

  @override
  _PageView createState() => new _PageView();
}

abstract class _PageState extends State<PageNestedScrollView> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<PageNestedScrollView> {
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

  void updateState() {
  }
}

class _PageView extends _PageState {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return Container(
    //   child: ListView.builder(
    //     controller: controller.master,
    //     itemCount: 20,
    //     itemBuilder: _listItem
    //   ),
    // );
    return ScrollPage(
      controller: controller,
      child: _nested(),
    );
    // return _nested();
  }

  Widget _nested() {
    return NestedScrollView(
      // controller: controller.master,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          new SliverPersistentHeader(pinned: true,floating: true,delegate: new _SliverAppBarDelegate(bar))
        ];
      },
      body: _body()
    );
  }

  Widget _body() {
    return CustomScrollView(
      // controller: controller.master,
      // primary: true,
      slivers: <Widget>[
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
      ]
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps){
    // return Stack(
    //   children: <Widget>[
    //     Text('read $offset')
    //   ]
    // );
    return Center(child: Text('read $offset'));
  }

  Widget _listItem(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 23),
      color: Color(Random().nextInt(0xffffffff)),
      child: Center(child: Text("NestedScrollView $index")),
    );
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(
    this.builder,
    {
      this.minHeight:45.0, this.maxHeight:125.0
    }
  );
  final double minHeight;
  final double maxHeight;

  double stretch = 0.0;
  double shrink = 1.0;
  final Function builder;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(

      padding: EdgeInsets.only(bottom: 0.5),
      child: Container(
        padding: EdgeInsets.only(top: 25),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: new BorderRadius.vertical(bottom: Radius.elliptical(5, 2))
        ),
        child: new SizedBox.expand(
          child: builder(context,shrinkOffset,overlapsContent)
        )
        // child: Text('read $shrinkOffset'),
      )
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;
}