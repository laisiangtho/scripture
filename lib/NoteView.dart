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
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating: true,delegate: WidgetHeaderSliver(bar)),
        new SliverPadding(
          padding: EdgeInsets.only(top:0,bottom: store.contentBottomPadding),
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
        return SliverToBoxAdapter(
          child: AnimatedList(
            key: animatedListKey,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            // primary: true,
            // reverse: true,
            padding: EdgeInsets.zero,
            initialItemCount: result.data.length,
            itemBuilder: (context, index, animation) => bookmarkBuildItem(context, result.data,index,animation),
          ),
        );
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

  Widget bookmarkBuildItem(BuildContext context, List o,int index, Animation<double> animation) {
    Map<String,dynamic> item = o[index];
    Key id = Key(store.uniqueIdentify.toString());
    return BookmarkContainer(
      key: id,
      animation: animation,
      bookmark: item,
      // bookmark: item...update('chapter', (e)=>store.digit(e)),
      // bookmark: item.cast()..putIfAbsent('chapter', (e)=>store.digit(e)),
      onPress: (){
        store.bookId = item['book'];
        store.chapterId = item['chapter'];
        this.toBible();
      },
      menuItems: <RawMaterialButton>[
        new RawMaterialButton(
          elevation: 0,
          highlightElevation: 0.0,
          fillColor: Colors.grey,
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.elliptical(10, 20))),
          constraints: BoxConstraints(minHeight: 35, minWidth: 40, maxWidth: 50),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: new Icon(Icons.remove_circle,color: Colors.white, size: 27),
          onPressed: (){
            // o.removeAt(index);
            animatedListKey.currentState.removeItem(index, (BuildContext context, Animation<double> animation) {
                return new BookmarkContainer(bookmark: item,animation: animation);
            });
            setState(() {
              store.removeCollectionBookmark(index);
            });
          }
        )
      ]
    );
  }
}

class BookmarkContainer extends StatefulWidget {
  final VoidCallback onPress;
  final List<RawMaterialButton> menuItems;
  final Animation<double> animation;
  final Map<String,dynamic> bookmark;
  // final bool selected;

  BookmarkContainer({Key key,this.animation, this.bookmark, this.menuItems,this.onPress}): super(key: key);

  @override
  _BookmarkContainerState createState() => new _BookmarkContainerState();
}

class _BookmarkContainerState extends State<BookmarkContainer> with SingleTickerProviderStateMixin {
  AnimationController animatedListController;

  @override
  initState() {
    super.initState();
    animatedListController = new AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  }

  // @override
  // dispose() {
  //   super.dispose();
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  // @override
  // void didUpdateWidget(BookmarkContainer oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.menuItems == null && animatedListController.isCompleted) {
  //     animatedListController.reverse();
  //     // animatedListController.reverse().whenComplete(widget.onPress);
  //   }
  //   // animationController.fling();
  // }

  @override
  Widget build(BuildContext context) {
    final animationOffset = new Tween(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-0.15, 0.0)
    ).animate(new CurveTween(curve: Curves.decelerate).animate(animatedListController));
    final animationDouble = new Tween<double>(
      begin: 0.0,
      end: 1.0
    ).animate(new CurveTween(curve: Curves.decelerate).animate(animatedListController));

    return new SizeTransition(
      key: widget.key,
      axis: Axis.vertical,
      sizeFactor: widget.animation,
      child: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        // behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (data) {
          setState(() {
            animatedListController.value -= data.primaryDelta / context.size.width / 0.3;
          });
        },
        onHorizontalDragEnd: (data) {
          if (data.primaryVelocity > 2500)
            animatedListController.animateTo(.0); //close menu on fast swipe in the right direction
          else if (animatedListController.value >= .3 || data.primaryVelocity < -500) // fully open if dragged a lot to left or on fast swipe to left
            animatedListController.animateTo(1.0);
          else // close if none of above
            animatedListController.animateTo(.0);
        },
        onLongPress: (){
          if (animatedListController.isCompleted) {
            animatedListController.reverse();
          } else if (animatedListController.isDismissed) {
            animatedListController.forward();
          }
        },
        child: new Stack(
          children: <Widget>[
            new SlideTransition(
              position: animationOffset,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 28),
                title: Text(
                  widget.bookmark['bookName'],
                  maxLines: 1,overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 19)
                ),
                subtitle: Text(widget.bookmark['testamentName']),
                trailing: Text(widget.bookmark['chapterName'],style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 19)),
                onTap: widget.onPress
              )
            ),
            new Positioned.fill(
              child: new LayoutBuilder(
                builder: (context, constraint) {
                  return new AnimatedBuilder(
                    animation: animatedListController,
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
                              children: widget.menuItems?.map((RawMaterialButton item) {
                                return new Expanded(
                                  child: FadeTransition(
                                    opacity: animationDouble, child: item
                                  )
                                );
                              })?.toList()??[]
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
      )
    );
  }
}