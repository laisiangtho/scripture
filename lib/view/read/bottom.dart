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
        Align(
          // alignment: Alignment(1.0, 0.97),
          alignment: Alignment((1.0+stretch), 0.97),
          // alignment: Alignment.bottomRight,
          child: RawMaterialButton(
            elevation: 0,
            highlightElevation: 0.0,
            fillColor: Theme.of(context).backgroundColor.withOpacity(0.8),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.horizontal(left: Radius.elliptical(10, 20))
            ),
            constraints: BoxConstraints(minHeight: 35, minWidth: 40, maxWidth: 50),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: new Icon(Icons.chevron_right,color: Colors.white),
            onPressed: setChapterNext
          ),
        ),
        Align(
          // alignment: Alignment.bottomLeft,
          // alignment: Alignment(-1.0, 0.97),
          alignment: Alignment((-1.0-stretch), 0.97),
          child: RawMaterialButton(
            elevation: 0,
            highlightElevation: 0.0,
            fillColor: Theme.of(context).backgroundColor.withOpacity(0.8),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.horizontal(right: Radius.elliptical(10, 20))
            ),
            constraints: BoxConstraints(minHeight: 35, minWidth: 40, maxWidth: 50),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: new Icon(Icons.chevron_left,color: Colors.white),
            onPressed: setChapterPrevious
          ),
        )
      ]
    );
  }

}