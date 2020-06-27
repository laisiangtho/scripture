import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/cupertino.dart';
import 'scroll.dart';
import 'scroll.working.page.dart';
import 'scroll.working.CustomScrollView.dart';
// import 'scroll.working.NestedScrollView.dart';

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainView();
}

class _MainView extends State<MainView> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = ScrollController(initialScrollOffset:0,keepScrollOffset:true);
  final pageController = PageController();
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    // controller.addListener(() {});
    // animationController = AnimationController(
    //   vsync: this, // the SingleTickerProviderStateMixin
    //   duration: Duration(milliseconds:200),
    // );
  }

  @override
  void dispose() {
    controller.dispose();
    // controller.master.dispose();
    animationController.dispose();
    super.dispose();
  }

  void _pageChanged(int index){
    // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
    // pageController.jumpToPage(index);
    // Navigator.pushNamed(context, '/bible');
    Navigator.of(context, rootNavigator: false).push(
      MaterialPageRoute(builder: (context) => _PageOwnScrollController(), maintainState: false)
    );
  }

  // void _pageChanged(int page) {
  //   // setState(() { });
  //   // pageChange(page);
  // }

  // void pageChange(int index) {
  //   controller.bottom.pageNotify.value= index;
  // }

  // @override
  // void didUpdateWidget(Foo oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   _controller.duration = widget.duration;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      // appBar: _bar(),
      body: _body(),
      bottomNavigationBar: _bottom(),
      extendBody: true
      // appBar: AppBar(
      //   title: ValueListenableBuilder<int>(
      //     valueListenable: controller.bottomNavigationBar.tabNotifier,
      //     builder: (context, value, child) => items[value].title,
      //   ),
      // ),
      // body: Snap(
      //   controller: controller.bottomNavigationBar,
      //   child: ValueListenableBuilder<int>(
      //     valueListenable: controller.bottomNavigationBar.tabNotifier,
      //     builder: (context, value, child) => ListView.builder(
      //       controller: controller,
      //       itemBuilder: _listItem,
      //     ),
      //   ),
      // ),
      // bottomNavigationBar: ScrollBottomNavigationBar(
      //   controller: controller,
      //   items: items,
      // ),
    );
  }

  // Widget _bar() {
  //   return AppBar(
  //     title: _textCenter('bar')
  //   );
  // }

  Widget _body() {
    // return ScrollPage(
    //   // controller: controller,
    //   controller: controller.master,
    //   // controller: controller.bottom,
    //   child: PageView(
    //     // controller: pageController,
    //     onPageChanged: (index) {
    //     },
    //     children: <Widget>[
    //       _PageNoScrollController(),
    //       _PageWithScrollController(),
    //       _PageOwnScrollController(),
    //       PageTesting()
    //     ]
    //   )
    // );
    return PageView(
      controller: pageController,
      // pageSnapping: false,
      onPageChanged: controller.bottom.pageChange,
      children: <Widget>[
        PageCustomScrollView(),
        // PageNestedScrollView(),
        _PageNoScrollController(),
        _PageWithScrollController(),
        _PageOwnScrollController(),
        PageTesting(),
      ]
    );
  }

  Widget _bottom() {
    return ScrollPageBottom(
      controller: controller,
      pageChange:_pageChanged,
      child: Text('bottom'),
    );
  }
}

class _PageNoScrollController extends StatelessWidget {
  final controller = ScrollController();
  _PageNoScrollController({
    Key key,
  }) :
  super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollPage(
      // controller: controller,
      child: Container(
        child: ListView.builder(
          // controller: controller.master,
          itemCount: 15,
          itemBuilder: _listItem
        ),
      ),
    );
  }

  Widget _listItem(BuildContext context, int index) {
    return Container(
      color: Color(Random().nextInt(0xffffffff)),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(child: Text("_PageNoScrollController $index")),
    );
  }
}

class _PageWithScrollController extends StatelessWidget {
  final controller = ScrollController();
  _PageWithScrollController({
    Key key,
  }) :
  // assert(controller != null),
  super(key: key);


  @override
  Widget build(BuildContext context) {
    return ScrollPage(
      controller: controller,
      child: Container(
        child: ListView.builder(
          // controller: controller.master,
          itemCount: 20,
          itemBuilder: _listItem
        ),
      ),
    );
  }

  Widget _listItem(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 23),
      color: Color(Random().nextInt(0xffffffff)),
      child: Center(child: Text("_PageWithScrollController $index")),
    );
  }
}

class _PageOwnScrollController extends StatelessWidget {
  final controller = ScrollController();
  _PageOwnScrollController({
    Key key,
  }) :
  super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollPage(
        child: ListView.builder(
          controller: controller,
          itemCount: List<String>.generate(30, (i) => "Item $i").length,
          itemBuilder: _listItem,
        ),
      ),
    );
  }

  Widget _listItem(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      color: Color(Random().nextInt(0xffffffff)),
      child: Center(child: Text("_PageOwnScrollController $index")),
    );
  }
}