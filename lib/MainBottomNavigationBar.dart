import 'dart:ui';

import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'dart:math' as math;

import 'Store.dart';

import 'Home.dart';
import 'Bible.dart';
import 'Note.dart';
import 'Search.dart';
// import 'More.dart';

import 'Common.dart';


class MainBottomNavigationBar extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => StateExtended();
}

class StateExtended extends State<MainBottomNavigationBar> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  PageController pageController = new PageController();
  FocusNode focusNode = new FocusNode();
  Store store = new Store();


  final List<Widget> _page = [];
  final List<BottomBarItem> _pageButton = [];
  int _pageIndex = 0;


  double navMaxheight = 40.0, navMinheight = 0.0, _scrollOffset = 0, _scrollDelta = 0, _scrollOldOffset = 0;
  double scrollOffsetCalc = 0.0;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() => setState(() {}));

    _pageButton.add(BottomBarItem(icon:Icons.local_library, label:"Book"));
    _pageButton.add(BottomBarItem(icon:Icons.library_books, label:"Read"));
    _pageButton.add(BottomBarItem(icon:Icons.collections_bookmark, label:"Bookmark"));
    _pageButton.add(BottomBarItem(icon:CupertinoIcons.search, label:"Search"));
    // _pageButton.add(BottomBarItem(icon:Icons.more_horiz, label:"More"));

    _page.add(Home(scrollController: scrollController,offset:scrollOffsetCalc,pageController:pageController));
    _page.add(Bible(scrollController: scrollController,offset:scrollOffsetCalc));
    _page.add(Note(scrollController: scrollController,offset:scrollOffsetCalc,pageController:pageController));
    _page.add(Search(scrollController: scrollController,offset:scrollOffsetCalc,focusNode: focusNode));
    // _page.add(More(scrollController: scrollController,offset:scrollOffsetCalc,));

    scrollController..addListener(() {
      setState(() {
        double offset = scrollController.offset;
        _scrollDelta += (offset - _scrollOldOffset);
        if (_scrollDelta > navMaxheight){
          _scrollDelta = navMaxheight;
        } else if (_scrollDelta < navMinheight) {
          _scrollDelta = navMinheight;
        }
        _scrollOldOffset = offset;

        // double max = scrollController.position.maxScrollExtent, limit = max - navMaxheight;
        // if (offset >= limit){
        //   _scrollDelta = math.max(-(offset - max),-_scrollDelta);
        // }
        double max = scrollController.position.maxScrollExtent, limit = max - navMaxheight;
        if (offset >= limit){
          _scrollDelta = math.max(-(offset - max),-_scrollDelta);
        }
        _scrollOffset = -_scrollDelta;
        scrollOffsetCalc = ((_scrollOffset.abs() - navMinheight) * 100) / (navMaxheight - navMinheight) / 100;
        store.offset=scrollOffsetCalc;
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  bool get isNodeFocus => focusNode.hasFocus;

  void navPressed(int index) {
    // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
    pageController.jumpToPage(index);
  }

  void navPageChanged(int page) {
    setState(() {
      this._scrollOffset = 0;
      this._pageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: new PageView(
          controller: pageController,onPageChanged: navPageChanged,
          physics:new NeverScrollableScrollPhysics(),
          // physics:nodeFocus?new NeverScrollableScrollPhysics():null,
          children:_page
        ),
        extendBody: true,
        bottomNavigationBar: viewNavigation()
      )
    );
  }
  /*
  LayoutBuilder body() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // _page[_pageIndex];
            new PageView(
              controller: pageController,onPageChanged: navPageChanged,
              physics:new NeverScrollableScrollPhysics(),
              // physics:nodeFocus?new NeverScrollableScrollPhysics():null,
              children:_page
            ),
            viewNavigation()
          ]
        );
      }
    );
  }
  */
  Widget viewNavigation() {
    if (isNodeFocus) return null;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
          bottom: _scrollOffset,
          width: MediaQuery.of(context).size.width,
          child: Container(
            width: double.infinity,
            height: navMaxheight,
            child: SizedBox.shrink(
              child: viewBottomNavigationCustom()
            )
          )
        )
      ]
    );
  }
  Widget viewBottomNavigationCustom() {
    return BottomBarAnimated(
      items:_pageButton,
      tap:navPressed,
      index:_pageIndex,
    );
  }
}

class BottomBarItem {
  BottomBarItem({
    this.label,
    this.icon,
    this.color
  });
  final String label;
  final IconData icon;
  final Color color;
}

class BottomBarAnimated extends StatefulWidget {
  BottomBarAnimated({
    this.items,
    this.index,
    this.tap,
    this.animationDuration: const Duration(milliseconds: 400)
  });
  final int index;

  final Function tap;
  final List<BottomBarItem> items;
  final Duration animationDuration;
  @override
  _BottomBarAnimatedState createState() => _BottomBarAnimatedState();
}

class _BottomBarAnimatedState extends State<BottomBarAnimated> with TickerProviderStateMixin {
  int selectedButton = 0;
  @override
  Widget build(BuildContext context) {
    return WidgetBottomNavigation(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children()
      )
    );
  }

  List<Widget> children() {
    List<Widget> button = List();
    // double width = MediaQuery.of(context).size.width/widget.items.length;
    for (int i = 0; i < widget.items.length; i++) {
      BottomBarItem item = widget.items[i];
      bool isSelectedButton = widget.index == i;
      // button.add(
      //   new InkWell(
      //     splashColor: Colors.transparent,
      //     highlightColor: Colors.transparent,
      //     child: AnimatedContainer(
      //       constraints: BoxConstraints(
      //         maxWidth: width,
      //         minWidth: width-7,
      //         minHeight: double.infinity
      //       ),
      //       margin: EdgeInsets.symmetric(vertical: 7,horizontal: 2),
      //       decoration: BoxDecoration(
      //       ),
      //       duration: widget.animationDuration,
      //       child: Column(
      //         mainAxisSize: MainAxisSize.max,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: <Widget>[
      //           Icon(item.icon,color: isSelectedButton? Colors.black:Colors.black38,size: 20,),
      //         ]
      //       )
      //     ),
      //     onTap: ()=>widget.tap(i)
      //   )
      // );
      button.add(
        CupertinoButton(
          pressedOpacity: 0.5,
          padding: EdgeInsets.all(6),
          child: AnimatedContainer(
            // margin: EdgeInsets.symmetric(vertical: 7,horizontal: 2),
            padding: EdgeInsets.symmetric(vertical: 3,horizontal: 12),
            decoration: BoxDecoration(
              color: isSelectedButton?Colors.grey.withOpacity(1):null,
              borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            duration: widget.animationDuration,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.icon, size:20,color: isSelectedButton? Colors.white:Colors.grey[500]),

                SizedBox(width:2),
                AnimatedSize(
                  vsync: this,
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  child: Text(isSelectedButton?item.label:'',style: TextStyle(color: Colors.white,fontSize: 10),),
                )
              ]
            ),
          ),
          onPressed: ()=>widget.tap(i),
        )
      );
    }
    return button;
  }
}