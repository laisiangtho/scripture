part of 'main.dart';

mixin _Refresh on _State {
    String __msg ='Done';
    Widget sliverRefresh() {
      return CupertinoSliverRefreshControl(
        refreshIndicatorExtent: 60,
        refreshTriggerPullDistance: 100,
        onRefresh: () {
          final previousCount = collectionBibleList.length;
          return core.updateCollection().then((_){
            for (int index = previousCount; index < collectionBibleList.length; index++)  {
              sliverAnimatedListKey.currentState.insertItem(index);
            }
            core.analyticsShare('update', core.version);
          }).catchError((e){
            setState(() {
              __msg = e;
            });
            core.analyticsShare('update', 'error');
          }).whenComplete((){
            setState(() {
            });
          });
        },
        builder: (b,RefreshIndicatorMode mode,double offset,double d,double e) {
          final percentage = offset.clamp(0, 100)/100;
          final topPadding = offset.clamp(0, 3).toDouble();
          final size = (30*percentage+topPadding).clamp(5, 40).toDouble();
          Widget show = Container();
          switch (mode) {
            case RefreshIndicatorMode.inactive:
              show = Text('inactive');
              // controller.master.bottom.enable(true);
              break;
            case RefreshIndicatorMode.done:
              // show = Text('Done');
              show = Text(__msg);
              // controller.master.bottom.enable(true);
              break;
            case RefreshIndicatorMode.refresh:
              show = Text('Updated');
              // controller.master.bottom.enable(true);
              break;
            case RefreshIndicatorMode.armed:
              show = SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: Colors.grey[200],
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black45),
                ),
              );
              break;
            case RefreshIndicatorMode.drag:
              show = Opacity(
                opacity: percentage.clamp(0.3, 1.0),
                child: SizedBox(
                  height: size,
                  width: size,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: percentage,
                    backgroundColor: Colors.grey[200],
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black45),
                  ),
                ),
              );
              // controller.master.bottom.enable(false);
              break;
          }
        return Container(
          height: offset,
          padding: EdgeInsets.only(top:topPadding),
          child: Center(
            child: show
          )
        );
      }
    );
  }
}
