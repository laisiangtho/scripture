part of 'root.dart';

class ScrollPage extends StatelessWidget {
  final ScrollController controller;
  final Widget child;
  final int depth;

  ScrollPage({
    Key key,
    this.controller,
    this.depth:0,
    @required this.child,
  }) : assert(child != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollPageBehavior(),
      child: NotificationListener<ScrollNotification>(
        onNotification: _notification,
        child: child,
      )
   );
  }

  bool _notification(ScrollNotification notification) {
    // print(notification.metrics.pixels);
    // if (controller.hasClients) {
    if (controller != null && controller.hasClients && notification.depth == depth) controller.notification.value = notification;
    return false;
  }
}

class ScrollPageBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) => child;
}

class ScrollMainDecoratedBox extends StatelessWidget {
  final Widget child;
  ScrollMainDecoratedBox({Key key,this.child}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: new BorderRadius.vertical(
          top: Radius.elliptical(3, 2),
          bottom: Radius.elliptical(3, 2)
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            // color: Colors.grey[300],
            // color: Theme.of(context).primaryColor,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.3,
            offset: Offset(0.0, .0),
          )
        ]
      ),
      child: this.child
    );
  }
}