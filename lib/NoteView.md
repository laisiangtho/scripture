import 'package:flutter/material.dart';


import 'Note.dart';

// import 'StoreModel.dart';
// import 'Store.dart';

class NoteView extends NoteState {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
        future: store.bible,
        builder: (BuildContext context, AsyncSnapshot e){
          if (e.hasData){
            return body();
          } else if (e.hasError) {
            if (store.identify.isEmpty){
              return WidgetEmptyIdentify(task: ' to\nview ',message: 'bookmarks');
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

  Widget body() {
    return CustomScrollView(
      // controller: store.scrollController,
      semanticChildCount: 0,
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating: true,delegate: WidgetHeaderSliver(bar)),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: store.contentBottomPadding),
          sliver: bookmarks()
        )
      ]
    );
  }

  Row bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    return Row(
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
  // final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
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
        // return SliverToBoxAdapter(
        //   child: AnimatedList(
        //     key: _listKey,
        //     initialItemCount: result.data.length,
        //     itemBuilder: _buildItem,
        //   ),
        // );
      } else {
        return new SliverFillRemaining(
          child: Center(
            child: WidgetEmptyIdentify(atLeast:'collection of\n',enable:'Bookmarks',task: ' &\nother ',message: 'library')
          )
        );
      }
    }
    return new SliverFillRemaining();
  }
  // Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
  //   return CardItem(
  //     animation: animation,
  //     item: _list[index],
  //     selected: _selectedItem == _list[index],
  //     onTap: () {
  //       setState(() {
  //         _selectedItem = _selectedItem == _list[index] ? null : _list[index];
  //       });
  //     },
  //   );
  // }

  Widget bookmarksItems(BuildContext context, o,index){
    Map<String,dynamic> bookmark = o[index];
    return new SlideMenu(
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 28),
        title: Text(
          bookmark['bookName'],
          maxLines: 1,overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 19)
        ),
        subtitle: Text(bookmark['testamentName']),
        // subtitle: Text('...testamentShortname'),
        trailing: Text(store.digit(bookmark['chapter']),style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 19)),
        onTap: (){
          store.bookId = bookmark['book'];
          store.chapterId = bookmark['chapter'];
          this.toBible();
        },
      ),
      // onTap: (){
      //   store.bookId = bookmark['book'];
      //   store.chapterId = bookmark['chapter'];
      //   this.toBible();
      // },
      menuItems: <Widget>[
        new RawMaterialButton(
          elevation: 0,
          highlightElevation: 0.0,
          // fillColor: Theme.of(context).backgroundColor,
          fillColor: Colors.grey,
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.elliptical(10, 20))),
          constraints: BoxConstraints(minHeight: 35, minWidth: 40, maxWidth: 50),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: new Icon(Icons.delete,color: Colors.white),
          onPressed: (){
            setState((){
              store.removeCollectionBookmark(index);
            });
          }
        ),
        // new IconButton(
        //   icon: new Icon(Icons.tag_faces,color: Colors.red,),
        //   onPressed: (){}
        // ),
        // new IconButton(
        //   icon: new Icon(Icons.tag_faces,color: Colors.red,),
        //   onPressed: (){}
        // ),
        // Container(
        //   alignment: Alignment.center,
        //   color: Colors.blue,
        //   child: new IconButton(
        //     icon: new Icon(Icons.tag_faces,color: Colors.red,),
        //     onPressed: (){}
        //   ),
        // ),
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
    final animationOffset = new Tween(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-0.15, 0.0)
    ).animate(new CurveTween(curve: Curves.decelerate).animate(_controller));
    final animationDouble = new Tween<double>(
      begin: 0.0,
      end: 1.0
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
          new SlideTransition(position: animationOffset, child: widget.child),
          // FadeTransition(),
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
                          width: constraint.maxWidth * animationOffset.value.dx * -1,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: widget.menuItems.map((Widget item) {
                              return new Expanded(
                                child: FadeTransition(
                                  opacity: animationDouble, child: item
                                )
                              );
                            }).toList()
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