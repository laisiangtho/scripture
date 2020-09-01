# v1

```dart
part of 'main.dart';

mixin _Bottom on _State {
  Widget bottomStack() {
    return ValueListenableBuilder<double>(
      valueListenable: controller.master.bottom.heightNotify,
      builder: _animatedContainer,
      // child: _page(),
    );
  }

  Widget _animatedContainer(BuildContext context, double shrink,Widget child) {
    double stretch = 1.0-shrink;
    // print('shrink $shrink stretch $stretch');
    return Stack(
      // fit: StackFit.passthrough,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        // Align(
        //   alignment:Alignment.bottomCenter,
        //   child: DraggableScrollableSheet(
        //     initialChildSize: 0.2,
        //     minChildSize: 0.1,
        //     maxChildSize: 0.4,
        //     builder: (BuildContext context, ScrollController scrollController) {
        //       return Container(
        //           color: Colors.grey,
        //           child: ListView.builder(
        //             itemCount: 10,
        //             shrinkWrap: true,
        //             itemBuilder: (BuildContext context, int index) {
        //               return Container(
        //                 padding: EdgeInsets.all(10),
        //                 child: Text('index'),
        //               );
        //             }
        //           ),
        //         );
        //     },
        //   ),
        // ),
        Align(
          // alignment: Alignment(1.0, 0.97),
          alignment: Alignment((1.0+stretch), 0.97),
          // alignment: Alignment.bottomRight,
          child: Tooltip(
            message: "Next chapter",
            child: RawMaterialButton(
              elevation: 0,
              highlightElevation: 0.0,
              fillColor: Theme.of(context).backgroundColor.withOpacity(0.8),
              highlightColor: Colors.black45,
              shape: new RoundedRectangleBorder(
                // borderRadius: new BorderRadius.horizontal(left: Radius.elliptical(10, 20))
                borderRadius: new BorderRadius.horizontal(left: Radius.elliptical(10, 30))
              ),
              // constraints: BoxConstraints(minHeight: 35, minWidth: 40, maxWidth: 50),
              constraints: BoxConstraints(minHeight: 50, minWidth: 60),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: new Icon(Icons.chevron_right,color: Colors.white, size: 40,),
              onPressed: setChapterNext
            ),
          ),
        ),
        Align(
          // alignment: Alignment.bottomLeft,
          // alignment: Alignment(-1.0, 0.97),
          alignment: Alignment((-1.0-stretch), 0.97),
          child: Tooltip(
            message: "Previous chapter",
            child: RawMaterialButton(
              elevation: 0,
              highlightElevation: 0.0,
              fillColor: Theme.of(context).backgroundColor.withOpacity(0.9),
              highlightColor: Colors.black45,
              shape: new RoundedRectangleBorder(
                // borderRadius: new BorderRadius.horizontal(right: Radius.elliptical(10, 20))
                borderRadius: new BorderRadius.horizontal(right: Radius.elliptical(10, 30))
              ),
              // constraints: BoxConstraints(minHeight: 35, minWidth: 40, maxWidth: 50),
              constraints: BoxConstraints(minHeight: 50, minWidth: 60),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: new Icon(Icons.chevron_left,color: Colors.white, size: 40,),
              onPressed: setChapterPrevious
            ),
          ),
        )
      ]
    );
  }

}