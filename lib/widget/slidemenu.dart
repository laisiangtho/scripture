import 'package:flutter/material.dart';

class SlideMenu extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPress;
  final List<Widget> right;
  final VoidCallback? builder;

  SlideMenu({
    Key? key,
    required this.child,
    required this.right,
    this.onPress,
    this.builder
  }): super(key: key);

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<Offset>  animationOffset;
  late Animation<double> animationDouble;

  @override
  initState() {
    super.initState();

    double offsetWidth = -0.18* widget.right.length;

    controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    animationOffset = new Tween<Offset>(
      begin: const Offset(0.0, 0.0),  end: Offset(offsetWidth, 0.0)
    ).animate(new CurveTween(curve: Curves.decelerate).animate(controller));

    animationDouble = new Tween<double>(
      begin: 0.0,  end: 1.0
    ).animate(new CurveTween(curve: Curves.decelerate).animate(controller));
  }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  // @override
  // void didUpdateWidget(SlideMenu oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.right == null && animatedListController.isCompleted) {
  //     animatedListController.reverse();
  //     // animatedListController.reverse().whenComplete(widget.onPress);
  //   }
  //   // animationController.fling();
  // }

  void onDragUpdate(DragUpdateDetails data) {
    setState(() {
      controller.value -= (data.primaryDelta! / context.size!.width / .3);
    });
  }

  void onDragEnd(DragEndDetails data) {
    if (data.primaryVelocity! > 2500)
      controller.animateTo(.0); //close menu on fast swipe in the right direction
    else if (controller.value >= .3 || data.primaryVelocity! < -500) // fully open if dragged a lot to left or on fast swipe to left
      controller.animateTo(1.0);
    else // close if none of above
      controller.animateTo(.0);
  }

  void onLongPress() {
    if (controller.isCompleted) {
      controller.reverse();
    } else if (controller.isDismissed) {
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {

    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      // behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
      onLongPress: onLongPress,
      child: new Stack(
        key: widget.key,
        children: <Widget>[
          new SlideTransition(
            position: animationOffset,
            child: widget.child
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
                            children: widget.right.map((Widget item) {
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
