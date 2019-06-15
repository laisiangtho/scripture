import 'package:flutter/material.dart';


import 'Note.dart';

// import 'StoreModel.dart';
// import 'Store.dart';

class NoteView extends NoteState {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: widget.key,
      body: FutureBuilder(
        future: store.bible,
        builder: (BuildContext context, AsyncSnapshot e){
          if (e.hasData){
            return buildScrollView();
          } else if (e.hasError) {
            if (store.identify.isEmpty){
              return WidgetEmptyIdentify(task: 'to view',message: 'bookmarks');
            } else {
              return WidgetError(message: e.error.toString());
            }
          } else {
            return WidgetLoad();
          }
        }
      )
    );
  }
  Widget buildScrollView() {
    return CustomScrollView(
      key: widget.key,
      // controller: widget.scrollController,
      semanticChildCount: 0,
      slivers: <Widget>[
        new SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: WidgetHeaderSliver(bar)
        ),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: 54),
          sliver: bookmarks()
        )
      ]
    );
  }
  Row bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Bookmark')
      ]
    );

  }
  Widget bookmarks(){
    // store.testingBookmark();
    return FutureBuilder(
      future: store.testingBookmark(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) => bookmarksContainer(snapshot)
    );
  }
  Widget bookmarksContainer(result){
    if (result.hasError) {
      return new SliverFillRemaining(
        child: WidgetError(message: result.error)
      );
    }

    if (result.hasData) {
      if (result.data.length > 0) {
        return new SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => bookmarksItems(context, result.data,index),
            childCount: result.data.length
          )
        );
      } else {
        return new SliverFillRemaining(
          child: Center(
            // child: Text('$query ...no verse found!')
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '"',
                style: Theme.of(context).textTheme.subhead,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Bookmarks',
                    style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.red,fontSize: 19),
                  ),
                  TextSpan(
                    text: '"\n...',
                  ),
                ],
              ),
            ),
          )
        );
      }
    }
    return new SliverFillRemaining();
  }
  Widget bookmarksItems(BuildContext context, o,index){
    Map<String,dynamic> bookmark = o[index];
    return new SlideMenu(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 30,top: 7, bottom: 7),
              // color: Colors.red,
              child: Text(bookmark['bookName'],
                maxLines: 1,overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subhead
              )
            )
          ),
          Padding(
            padding: EdgeInsets.only(right: 30),
            child: Text(store.digit(bookmark['chapter']))
          )
        ]
      ),
      onTap: (){
        store.bookId = bookmark['book'];
        store.chapterId = bookmark['chapter'];
        this.toBible();
      },
      menuItems: <Widget>[
        new IconButton(
          icon: new Icon(Icons.delete,color: Colors.red,),
          onPressed: (){
            setState((){
              store.removeCollectionBookmark(index);
            });
          }
        ),
      ]
    );
  }
}


class SlideMenu extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final List<Widget> menuItems;

  SlideMenu({Key key, this.child, this.menuItems,this.onTap}): super(key: key);

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = new Tween(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-0.3, 0.0)
    ).animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          // _controller.value -= data.primaryDelta / context.size.width  + 100;
          _controller.value -= data.primaryDelta / context.size.width / 0.3;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 2500)
          _controller.animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .3 || data.primaryVelocity < -500) // fully open if dragged a lot to left or on fast swipe to left
          _controller.animateTo(1.0);
        else // close if none of above
          _controller.animateTo(.0);
      },
      onLongPress: (){
        if (_controller.isCompleted) {
          _controller.reverse();
        } else if (_controller.isDismissed) {
          _controller.forward();
        }
      },
      onTap: widget.onTap,
      child: new Stack(
        children: <Widget>[
          new SlideTransition(position: animation, child: widget.child),
          new Positioned.fill(
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        new Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: new Container(
                            // color: Colors.black26,
                            child: new Row(
                              children: widget.menuItems.map((child) {
                                return new Expanded(
                                  child: child,
                                );
                              }).toList()
                            )
                          )
                        )
                      ]
                    );
                  }
                );
              }
            )
          )
        ]
      )
    );
  }
}