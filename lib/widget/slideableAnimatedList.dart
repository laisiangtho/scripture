import 'package:flutter/material.dart';

class SlideableAnimatedList extends StatefulWidget {
  final Widget menu;
  final VoidCallback onPress;
  final List<Widget> right;
  final Animation<double> animation;
  // final AnimationController controller;
  final VoidCallback builder;

  SlideableAnimatedList({
    Key key,
    // this.controller,
    this.animation,
    this.menu,
    this.right,
    this.onPress,
    this.builder
  }): super(key: key);

  @override
  _SlideableAnimatedListState createState() => new _SlideableAnimatedListState();
}

class _SlideableAnimatedListState extends State<SlideableAnimatedList> with SingleTickerProviderStateMixin {

  // AnimationController get controller => widget.controller;
  AnimationController controller;
  Animation<Offset>  animationOffset;
  Animation<double> animationDouble;

  @override
  initState() {
    super.initState();
    controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    animationOffset = new Tween(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-0.15, 0.0)
    ).animate(new CurveTween(curve: Curves.decelerate).animate(controller));
    animationDouble = new Tween<double>(
      begin: 0.5,
      end: 1.0
    ).animate(new CurveTween(curve: Curves.decelerate).animate(controller));
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
  //   if (widget.right == null && animatedListController.isCompleted) {
  //     animatedListController.reverse();
  //     // animatedListController.reverse().whenComplete(widget.onPress);
  //   }
  //   // animationController.fling();
  // }

  // Widget what(BuildContext context) {
  //   return builder(context,shrinkOffset,overlapsContent,shrink,stretch)
  // }
  @override
  Widget build(BuildContext context) {

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
            controller.value -= data.primaryDelta / context.size.width / 0.3;
          });
        },
        onHorizontalDragEnd: (data) {
          if (data.primaryVelocity > 2500)
            controller.animateTo(.0); //close menu on fast swipe in the right direction
          else if (controller.value >= .3 || data.primaryVelocity < -500) // fully open if dragged a lot to left or on fast swipe to left
            controller.animateTo(1.0);
          else // close if none of above
            controller.animateTo(.0);
        },
        onLongPress: (){
          if (controller.isCompleted) {
            controller.reverse();
          } else if (controller.isDismissed) {
            controller.forward();
          }
        },
        child: new Stack(
          children: <Widget>[
            new SlideTransition(
              position: animationOffset,
              child: widget.menu
            ),
            new Positioned.fill(
              child: new LayoutBuilder(
                builder: (context, constraint) {
                  return new AnimatedBuilder(
                    animation: controller,
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
                              children: widget.right?.map((Widget item) {
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
