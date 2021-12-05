part of 'app.dart';

class AppView extends _State with _Other {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initiator,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return launched();
          default:
            return const ScreenLauncher();
        }
      },
    );
  }

  Widget launched() {
    return Scaffold(
      key: _scaffoldKey,
      primary: true,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        bottom: true,
        maintainBottomViewPadding: true,
        // onUnknownRoute: routeUnknown,
        child: PageView.builder(
          controller: _pageController,
          // onPageChanged: _pageChanged,
          pageSnapping: false,
          // allowImplicitScrolling: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => _pageView[index],
          itemCount: _pageView.length,
        ),
      ),
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      // bottomNavigationBar: showPlayer(),
      bottomNavigationBar: bottom(),
      // bottomSheet: showPlayer(),
      // bottomNavigationBar: ClipRRect(
      //   // child: Text('abc'),
      //   // height: kBottomNavigationBarHeight,
      //   // clipBehavior: Clip.hardEdge,
      //   // decoration: BoxDecoration(
      //   //   // color: Theme.of(context).primaryColor,
      //   //   // color: Colors.transparent,
      //   //   color: Colors.blue,
      //   //   borderRadius: new BorderRadius.vertical(
      //   //     top: Radius.circular(100)
      //   //     // top: Radius.elliptical(15, 15),
      //   //   ),
      //   //   // boxShadow: [
      //   //   //   BoxShadow(
      //   //   //     // blurRadius: 0.0,
      //   //   //     color: Theme.of(context).shadowColor.withOpacity(0.5),
      //   //   //     // color: Theme.of(context).backgroundColor.withOpacity(0.6),
      //   //   //     blurRadius: 0.1,
      //   //   //     spreadRadius: 0.0,
      //   //   //     offset: Offset(0, -1)
      //   //   //   )
      //   //   // ]
      //   // ),
      //   borderRadius: new BorderRadius.vertical(
      //     top: Radius.circular(100)
      //   ),
      //   child: Material(
      //       shape: new RoundedRectangleBorder(
      //         // borderRadius: new BorderRadius.horizontal(left: Radius.elliptical(10, 20))
      //         borderRadius: new BorderRadius.vertical(
      //           top: Radius.circular(100)
      //         )
      //       ),
      //       color: Colors.red,
      //       clipBehavior: Clip.hardEdge,
      //       // elevation:10,
      //       // shadowColor: Theme.of(context).backgroundColor,
      //       // shadowColor: Colors.black,
      //       // color: Theme.of(context).scaffoldBackgroundColor,
      //       child: Text('abc'),
      //     )
      // ),
      //
      // bottomSheet: BottomSheet(
      //   onClosing: (){
      //     print('close');
      //   }, builder: (b){
      //     return Container(
      //       height: 30,
      //       decoration: BoxDecoration(
      //         // color: Theme.of(context).primaryColor,
      //         // color: Colors.transparent,
      //         // color: Colors.blue,
      //         borderRadius: new BorderRadius.vertical(
      //           top: Radius.circular(15)
      //           // top: Radius.elliptical(15, 15),
      //         ),
      //         // boxShadow: [
      //         //   BoxShadow(
      //         //     // blurRadius: 0.0,
      //         //     color: Theme.of(context).shadowColor.withOpacity(0.5),
      //         //     // color: Theme.of(context).backgroundColor.withOpacity(0.6),
      //         //     blurRadius: 0.1,
      //         //     spreadRadius: 0.0,
      //         //     offset: Offset(0, -1)
      //         //   )
      //         // ]
      //       ),
      //       child: Text('abc'),
      //     );
      //   }
      // ),
    );
  }

  Widget bottom() {
    return Consumer<ViewScrollNotify>(
      builder: (context, scrollNavigation, child) {
        scrollNavigation.bottomPadding = MediaQuery.of(context).padding.bottom;
        return AnimatedContainer(
          duration: Duration(milliseconds: scrollNavigation.milliseconds),
          height: scrollNavigation.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              // color: Theme.of(context).scaffoldBackgroundColor,
              color: Theme.of(context).primaryColor,
              // color: Theme.of(context).backgroundColor,
              // border: Border(
              //   top: BorderSide(
              //     color: Theme.of(context).shadowColor,
              //     width: 0.3,
              //   ),
              // ),
              // borderRadius: const BorderRadius.vertical(
              //   top: Radius.elliptical(3, 2),
              //   // bottom: Radius.elliptical(3, 2)
              // ),
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).shadowColor,
                  width: 0.3,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  // blurRadius: scrollNavigation.height == 0 ? 2 : 0.2,
                  blurRadius: 0.2,
                  // spreadRadius: 0.2,
                  // color: Theme.of(context).backgroundColor.withOpacity(0.3),
                  color: Theme.of(context).shadowColor,
                  // color: Colors.black,
                  // spreadRadius: scrollNavigation.heightFactor==0?0.2:0,
                  // spreadRadius: scrollNavigation.height == 0 ? 0.2 : 0.5,
                  offset: const Offset(0, 0),
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: scrollNavigation.bottomPadding,
              ),
              // padding: EdgeInsets.only(bottom:0),
              child: AnimatedOpacity(
                opacity: scrollNavigation.heightFactor,
                duration: Duration.zero,
                child: child,
              ),
            ),
          ),
        );
      },
      child: bottomNavigator(),
    );
  }

  Widget bottomNavigator() {
    return Consumer<NavigatorNotify>(
      builder: (context, route, child) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _pageButton
              .asMap()
              .map(
                (index, item) {
                  return MapEntry(
                    index,
                    buttonItem(
                      context: context,
                      index: index,
                      item: item,
                      route: item.action == null,
                      disabled: item.action == null && item.key == route.index,
                    ),
                  );
                },
              )
              .values
              .toList(),
        );
      },
    );
  }

  Widget buttonItem({
    required BuildContext context,
    required int index,
    required ViewNavigationModel item,
    required bool disabled,
    required bool route,
  }) {
    return Semantics(
      label: route ? "Page navigation" : "History navigation",
      namesRoute: route,
      enabled: route && !disabled,
      child: Tooltip(
        message: item.description!,
        child: CupertinoButton(
          minSize: 25,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          child: AnimatedContainer(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Icon(
              item.icon,
              size: route ? 26 : 18,
              semanticLabel: item.name,
            ),
          ),
          // disabledColor: route ? CupertinoColors.quaternarySystemFill : Theme.of(context).hintColor,
          // onPressed: current?null:()=>route?_navView(index):item.action(context)
          onPressed: _navButtonAction(item, disabled),
        ),
      ),
    );
  }
}
