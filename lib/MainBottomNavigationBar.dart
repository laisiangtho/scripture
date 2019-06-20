import 'dart:ui';

import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'dart:math';

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

  Store store = new Store();

  final List<Widget> _page = [];
  final List<BottomBarItem> _pageButton = [];
  int _pageIndex = 0;

  double navMaxheight, navMinheight = 0.0, _scrollOffset = 0, _scrollDelta = 0, _scrollOldOffset = 0;


  @override
  void initState() {
    store.focusNode.addListener(() => setState(() {}));

    _pageButton.add(BottomBarItem(icon:Icons.flag, label:"Book"));
    _pageButton.add(BottomBarItem(icon:Icons.local_library, label:"Read"));
    _pageButton.add(BottomBarItem(icon:Icons.collections_bookmark, label:"Bookmark"));
    _pageButton.add(BottomBarItem(icon:CupertinoIcons.search, label:"Search"));
    // _pageButton.add(BottomBarItem(icon:Icons.more_horiz, label:"More"));

    _page.add(Home(bottomSheet:showBottomSheets));
    _page.add(Bible());
    _page.add(Note());
    _page.add(Search());
    // _page.add(More());

    WidgetsBinding.instance.addPostFrameCallback(initAfterLayout);

    store.scrollController.addListener(() {
      setState(() {
        double offset = store.scrollController.offset;
        _scrollDelta += (offset - _scrollOldOffset);
        if (_scrollDelta > navMaxheight){
          _scrollDelta = navMaxheight;
        } else if (_scrollDelta < navMinheight) {
          _scrollDelta = navMinheight;
        }
        _scrollOldOffset = offset;

        double maxExtent = store.scrollController.position.maxScrollExtent, limit = maxExtent - navMaxheight;
        double minExtent = store.scrollController.position.minScrollExtent;
        if (offset >= limit ){
          _scrollDelta = max(-(offset - maxExtent),-_scrollDelta);
          _scrollOffset = -_scrollDelta;
        } else if (offset <= minExtent ) {
          _scrollOffset = navMinheight;
        } else {
          _scrollOffset = -_scrollDelta;
        }
        store.offset = (_scrollOffset.abs()-navMinheight)/(navMaxheight-navMinheight);

      });
    });

    super.initState();
  }

  void initAfterLayout(Duration duration) {
    navMaxheight = store.contentBottomPadding;
    // navMaxheight = store.bottomBarHeight;
  }

  @override
  void dispose() {
    store.pageController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void navPressed(int index) {
    // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
    store.pageController.jumpToPage(index);
  }

  void pageChanged(int page) {
    setState(() {
      // this._scrollOffset = 0;
      this._pageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    store.contextMedia = MediaQuery.of(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: new Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: true,
          body: new PageView(
            controller: store.pageController,onPageChanged: pageChanged,
            physics:new NeverScrollableScrollPhysics(),
            // physics:nodeFocus?new NeverScrollableScrollPhysics():null,
            children:_page
          ),
          extendBody: true,
          bottomNavigationBar: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraint) => viewNavigation()
          )
        )
      )
    );
  }
  showBottomSheets(builder) {
    // setState((){
    //   // store.bottomSheetShow = true;
    // });
    // PersistentBottomSheetController sheet
    // return scaffoldKey.currentState.showBottomSheet<void>(builder)
    // ..closed.whenComplete(() => setState(() {
    //   // store.bottomSheetShow = false;
    // }));
    // bottomSheet.close()
     return showModalBottomSheet(context: context, builder: builder)
     ..whenComplete(() => setState(() {}));
  }

  Widget viewNavigation() {
    if (store.focusNode.hasFocus || store.bottomSheetShow) return null;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
          bottom: (_scrollOffset > 0)?0:_scrollOffset,
          width: MediaQuery.of(context).size.width,
          height: store.contentBottomPadding,
          child: BottomBarAnimated(items:_pageButton, tap:navPressed, index:_pageIndex)
        )
      ]
    );
  }
}

class BottomBarItem {
  BottomBarItem({
    this.label,
    this.icon
  });
  final String label;
  final IconData icon;
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
    double width = MediaQuery.of(context).size.width/widget.items.length;
    for (int i = 0; i < widget.items.length; i++) {
      BottomBarItem item = widget.items[i];
      bool isSelectedButton = widget.index == i;

      button.add(
        CupertinoButton(
          pressedOpacity: 0.5,
          // minSize: width-7,
          padding: EdgeInsets.all(0.5),
          child: AnimatedContainer(
            // margin: EdgeInsets.symmetric(vertical: 7,horizontal: 2),
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 12),
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
                Icon(item.icon, size:25,color: isSelectedButton? Colors.white:Colors.grey[500]),

                SizedBox(width:2),
                AnimatedSize(
                  vsync: this,
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: width-10,
                      maxHeight: double.infinity
                    ),
                    child: Text(
                      isSelectedButton?item.label:'', overflow: TextOverflow.clip, maxLines: 1,
                      style: TextStyle(color: Colors.white,fontSize: 15)
                    )
                  )
                )
              ]
            )
          ),
          onPressed: ()=>widget.tap(i)
        )
      );
    }
    return button;
  }
}