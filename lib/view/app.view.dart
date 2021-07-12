part of 'app.dart';

class AppView extends _State {
  @override
  Widget build(BuildContext context) {
    debugPrint('app build');
    return FutureBuilder(
        future: initiator,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return launched();
            // return ScreenLauncher();
            default:
              return ScreenLauncher();
          }
        });
  }

  Widget launched() {
    return Scaffold(
        key: scaffoldKey,
        primary: true,
        resizeToAvoidBottomInset: true,
        // body: Navigator(key: navigator, onGenerateRoute: _routeGenerate, onUnknownRoute: _routeUnknown),
        body: SafeArea(
            top: true,
            bottom: true,
            maintainBottomViewPadding: true,
            // onUnknownRoute: routeUnknown,
            child: new PageView.builder(
                controller: pageController,
                // onPageChanged: _pageChanged,
                allowImplicitScrolling: false,
                physics: new NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) =>
                    _pageView[index],
                itemCount: _pageView.length)),
        // extendBody: true,
        bottomNavigationBar: bottom());
  }

  Widget bottom() {
    // LayoutBuilder(builder: ,)
    return Consumer<NotifyNavigationScroll>(
      builder: (context, scrollNavigation, child) {
        double abc = (MediaQuery.of(context).padding.bottom/3 * scrollNavigation.heightFactor);
        // debugPrint('abc $abc');
        return AnimatedContainer(
            duration: Duration(milliseconds: scrollNavigation.milliseconds),
            height: scrollNavigation.height+abc,
            child: AnimatedOpacity(
              opacity: scrollNavigation.heightFactor,
              duration: Duration.zero,
              child: child
            )
        );
      },
      child: ViewNavigation(
          items: _pageButton,
          itemDecoration: bottomDecoration,
          itemBuilder: buttonItem),
    );
  }

  Widget bottomDecoration({required BuildContext context, Widget? child}) {
    return DecoratedBox(
        decoration: BoxDecoration(
            // color: Theme.of(context).scaffoldBackgroundColor,
            color: Theme.of(context).primaryColor,
            // color: Theme.of(context).backgroundColor,
            // border: Border(
            //   top: BorderSide(
            //     color: Theme.of(context).backgroundColor.withOpacity(0.2),
            //     width: 0.5,
            //   ),
            // ),
            borderRadius: BorderRadius.vertical(
              top: Radius.elliptical(3, 2),
              // bottom: Radius.elliptical(3, 2)
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 0.0,
                color: Theme.of(context).backgroundColor.withOpacity(0.3),
                // color: Colors.black38,
                spreadRadius: 0.1,
                offset: Offset(0, -.1),
              )
            ]),
        child: Padding(
            padding:EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom/3),
            // padding: EdgeInsets.only(bottom:0),
            child: child));
  }

  Widget buttonItem(
      {required BuildContext context,
      required int index,
      required ViewNavigationModel item,
      required bool disabled,
      required bool route}) {
    return Semantics(
      label: route ? "Page navigation" : "History navigation",
      namesRoute: route,
      enabled: route && !disabled,
      child: Tooltip(
        message: item.description,
        excludeFromSemantics: true,
        child: CupertinoButton(
            minSize: 30,
            padding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
            color: Colors.blue,
            child: AnimatedContainer(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 300),
                // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                child: Icon(
                  item.icon,
                  size: route ? 23 : 18,
                  semanticLabel: item.name,
                )),
            disabledColor: route
                ? CupertinoColors.quaternarySystemFill
                : Theme.of(context).hintColor,
            // onPressed: current?null:()=>route?_navView(index):item.action(context)
            onPressed: buttonPressed(context, item, disabled)),
      ),
    );
  }

  void Function()? buttonPressed(
      BuildContext context, ViewNavigationModel item, bool disable) {
    if (disable) {
      return null;
    } else if (item.action == null && item.key != null) {
      return () => _navView(item.key!);
    } else {
      // debugPrint('abc');
      // final items = core.collection.boxOfHistory.toMap().values.toList();
      // items.sort((a, b) => b.date!.compareTo(a.date!));
      // debugPrint(items.map((e) => e.word));
      // return ()=>item.action!(context);
      // return () {
      //   history
      // };
      // _controller.master.bottom.pageChange(0);
      // return ()=>item.action(context);
      // core.collection.history.length;
      // debugPrint(core.collection.history.length);
      // debugPrint(asdfasdfasd.toString());
      // debugPrint(core.counter.toString());
      // int total = asdfasdfasd;
      // // int currentPosition=0;
      // // int nextButton = 1;
      // // int previousButton = -1;
      // if (total > 0){
      //   return () {
      //     if (_controller.master.bottom.pageNotify.value != 0){
      //       _navView(0);
      //     }
      //     item.action(context);
      //   };

      // }
      return item.action;
      // return null;
    }
    // int abc = context.watch<HistoryNotifier>().current;
    // int abc = context.watch<HistoryNotifier>().next;
  }
}
