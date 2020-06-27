import 'dart:math';
import 'package:flutter/cupertino.dart';
// import 'scroll.dart';
class PageTesting extends StatelessWidget {
  final controller = ScrollController();
  PageTesting({
    Key key,
  }) :
  // assert(controller != null),
  super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        // controller: controller.master,
        itemCount: 20,
        itemBuilder: _listItem
      ),
    );
  }

  Widget _listItem(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 23),
      color: Color(Random().nextInt(0xffffffff)),
      child: Center(child: Text("PageTesting $index")),
    );
  }
}
