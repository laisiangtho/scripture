part of 'main.dart';

mixin _Refresh on _State {
  Widget refresh(){
    return CupertinoSliverRefreshControl(
      builder: (BuildContext context,RefreshIndicatorMode refreshState,pulledExtent,refreshTriggerPullDistance,refreshIndicatorExtent){
        // debugPrint('refreshIndicatorExtent $refreshIndicatorExtent pulledExtent $pulledExtent refreshTriggerPullDistance $refreshTriggerPullDistance');
        final double percentageComplete = (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);
        final size = (40*percentageComplete).clamp(10, 35).toDouble();

        return Center(
          child: SizedBox(
            height: size,
            width: size,
            child: _refreshIndicator(refreshState,12.0,percentageComplete)
          )
        );
      },
      onRefresh: _refreshTrigger,
    );
  }

  Future<void> _refreshTrigger() async {
    // await Future.delayed(Duration(milliseconds: 1500));
    // debugPrint('alive update is disabled');
    await core.updateBookMeta().catchError((e){
      debugPrint('refresh: $e');
    });
  }

  Widget _refreshIndicator(RefreshIndicatorMode mode, double radius, double percentageComplete) {
    // debugPrint('radius $radius');
    switch (mode) {
      case RefreshIndicatorMode.drag:
        // While we're dragging, we draw individual ticks of the spinner while simultaneously
        // easing the opacity in. Note that the opacity curve values here were derived using
        // Xcode through inspecting a native app running on iOS 13.5.
        // const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
        // return Opacity(
        //   // opacity: opacityCurve.transform(percentageComplete),
        //   opacity: percentageComplete.clamp(0.3, 1.0),
        //   // child: CupertinoActivityIndicator.partiallyRevealed(radius: radius, progress: percentageComplete),
        //   child: _refreshAnimation(percentageComplete,1.0)
        // );
        return _refreshAnimation(percentageComplete,percentageComplete);
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
        // Once we're armed or performing the refresh, we just show the normal spinner.
        // return CupertinoActivityIndicator(radius: radius);
        return _refreshAnimation(null,2.0);
      case RefreshIndicatorMode.done:
        // When the user lets go, the standard transition is to shrink the spinner.
        // return CupertinoActivityIndicator(radius: radius * percentageComplete);
        return _refreshAnimation(null,percentageComplete);
      case RefreshIndicatorMode.inactive:
        // Anything else doesn't show anything.
        return Container();
    }
  }

  Widget _refreshAnimation(double? percentage, double? stroke){
    return CircularProgressIndicator(
      semanticsLabel: 'percentage',
      semanticsValue: percentage.toString(),
      strokeWidth: stroke??2.0,
      // strokeWidth: percentage ==null?2.0:percentage,
      value: percentage,
      valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryTextTheme.button!.color!),
    );
  }

}
