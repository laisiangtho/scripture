import 'package:flutter/material.dart';

class ScrollsAnimation extends StatefulWidget {
  @override
  State createState() => new ScrollsAnimationState();
}

class ScrollsAnimationState extends State<ScrollsAnimation> with SingleTickerProviderStateMixin {


  double cWidth = 0.0;
  double itemHeight = 28.0;
  double itemsCount = 20;
  double screenWidth;

  final controller = ScrollController();

  AnimationController animationController;
  var animation;

  // Tween<double> animation = new Tween<double>(begin: 0.0, end: 50.0);
  // Tween<double> animation = new Tween<double>(begin: 0.0, end: 50.0).animate(controller);

  // Animation<Color> animation;


  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);

    // animationController = new AnimationController(
    //   duration: const Duration(milliseconds: 3000), vsync: this,
    // );

    // animation = new Tween<double>(begin: 0.0, end: 50.0).animate(animationController)..addListener(onScroll);
    // animation.forward();
  }

  @override
  void dispose() {
    animationController.removeListener(onScroll);
    super.dispose();
  }

  onScroll() {
    setState(() {
      cWidth = controller.offset * screenWidth / (itemHeight * itemsCount);
    });
  }

  // get animation => new Tween<double>(begin: 0.0, end: 50.0).animate(controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: PreferredSize(
          child: Container(
            color: Colors.grey,
            padding: EdgeInsets.all(10),


          ),

          preferredSize: Size.fromHeight(animation.value)
      ),
      bottomNavigationBar: Container(
        height: animation.value,
        color: Colors.grey,
        child: Text('bottom'),
      ),
      floatingActionButton: Container(
        width: 50.0,
        height: 50.0,
        child: Center(
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.arrow_upward),
            ),
          ),
        ),
      ),
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          if ((notification.scrollDelta < 0) && (animation.isDismissed)) {
            // animationController.forward();
            print('forward');
          } else if ((notification.scrollDelta > 0) &&
              (animation.isCompleted)) {
            // animationController.reverse();
            print('reverse');
          }
        },
        child: ListView(
          controller: controller,
          children: List.generate(50,(index) => ListTile(
            title: Text(index.toString()),
          )),
        ),
      ),
    );
  }

}