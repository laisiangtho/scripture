part of 'main.dart';

mixin _Refresh on _State {
  String _refreshMessage = '';
  Widget refresh() {
    return CupertinoSliverRefreshControl(
      refreshTriggerPullDistance: 100,
      refreshIndicatorExtent: 70,
      builder: (
        BuildContext _,
        RefreshIndicatorMode mode,
        pulledExtent,
        triggerPullDistance,
        indicatorExtent,
      ) {
        final double percentage = (pulledExtent / triggerPullDistance); //.clamp(0.0, 1.0);
        return Center(
          child: _refreshMode(mode, percentage),
        );
      },
      onRefresh: _refreshTrigger,
    );
  }

  Future<void> _refreshTrigger() async {
    await core.updateBookMeta().catchError((e) {
      _refreshMessage = e;
    });
  }

  Widget _refreshMode(RefreshIndicatorMode mode, double percentage) {
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
        return _refreshIndicator(percentage, percentage);
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
        // Once we're armed or performing the refresh, we just show the normal spinner.
        // return CupertinoActivityIndicator(radius: radius);
        return _refreshIndicator(percentage, null);
      case RefreshIndicatorMode.done:
        // When the user lets go, the standard transition is to shrink the spinner.
        // return CupertinoActivityIndicator(radius: radius * percentageComplete);
        return _refreshIndicator(percentage, null);
      case RefreshIndicatorMode.inactive:
        // Anything else doesn't show anything.
        _refreshMessage = '';
        return const SizedBox();
    }
  }

  Widget _refreshPercentage(double? percentage) {
    return CircularProgressIndicator(
      semanticsLabel: 'Percentage',
      semanticsValue: percentage.toString(),
      strokeWidth: 2.0,
      value: percentage,
    );
  }

  Widget _refreshIndicator(double percentage, double? value) {
    if (_refreshMessage.isNotEmpty) {
      return Text(
        _refreshMessage,
        style: TextStyle(
          color: Theme.of(context).errorColor,
          fontWeight: FontWeight.w300,
          fontSize: DefaultTextStyle.of(context).style.fontSize! * percentage,
        ),
      );
    }
    final size = (40 * percentage).clamp(10, 35).toDouble();
    return SizedBox(
      height: size,
      width: size,
      child: _refreshPercentage(value),
    );
  }
}
