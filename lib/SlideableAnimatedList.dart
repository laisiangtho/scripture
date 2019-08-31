import 'package:flutter/material.dart';

class SlideableAnimatedList extends StatefulWidget {
  final Widget menu;
  final VoidCallback onPress;
  final List<Widget> menuRight;
  final Animation<double> animation;

  SlideableAnimatedList({Key key,this.animation, this.menu, this.menuRight,this.onPress}): super(key: key);

  @override
  _SlideableAnimatedListState createState() => new _SlideableAnimatedListState();
}

class _SlideableAnimatedListState extends State<SlideableAnimatedList> with SingleTickerProviderStateMixin {
  AnimationController animatedListController;

  @override
  initState() {
    animatedListController = new AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    super.initState();
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
  // void didUpdateWidget(SlideableAnimatedList oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.menuRight == null && animatedListController.isCompleted) {
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
      // sizeFactor: animationDouble,
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
              position: animationOffset, child: widget.menu
            ),
            new Positioned.fill(
              child: new LayoutBuilder(
                builder: (context, constraint) {
                  return new AnimatedBuilder(
                    animation: animatedListController,
                    builder: (context, child) {
                      return new Stack(
                        alignment: Alignment(0, 0),
                        children: <Widget>[
                          new Positioned(
                            right: .0,
                            top: .0,
                            bottom: .0,
                            width: constraint.maxWidth * animationOffset.value.dx * -1,
                            child: new Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: widget.menuRight?.map((Widget item) {
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