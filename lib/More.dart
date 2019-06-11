import 'package:flutter/material.dart';
// import 'StoreModel.dart';
import 'Store.dart';

class More extends StatefulWidget {
  More({
    Key key,
    this.scrollController,
    this.offset,
  }) : super(key: key);

  final ScrollController scrollController;
  final double offset;

  @override
  MoreView createState() => new MoreView();
}

abstract class MoreState extends State<More> with TickerProviderStateMixin{

  Store store = new Store();

  double shrinkOffsetPercentage=1.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(() => setState(() {}));
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

}

class MoreView extends MoreState {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Tooltip(
          message: 'Working',
          child: Text('More'),
        )
      ),
    );
  }
}
