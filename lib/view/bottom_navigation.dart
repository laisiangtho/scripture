part of 'screen_launcher.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // App.scroll
    // App.scroll.bottomNavigation
    return ValueListenableBuilder<double>(
      // valueListenable: App.scroll.bottomFactor,
      valueListenable: App.viewData.bottom.factor,
      builder: (_, factor, child) {
        // scrollNavigation.bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        return Align(
          alignment: const Alignment(0, -1),
          heightFactor: factor,
          child: Padding(
            padding: EdgeInsets.only(bottom: App.viewData.fromContext.viewPadding.bottom),
            child: bottomNavigationToggle(),
          ),
        );
      },
    );
  }

  Widget bottomNavigationToggle() {
    return ValueListenableBuilder<double>(
      valueListenable: App.viewData.bottom.toggle,
      builder: (context, toggle, child) {
        return Align(
          alignment: const Alignment(0, -1),
          heightFactor: toggle,
          child: child,
        );
      },
      child: bottomNavigationDecoration(),
    );
  }

  Widget bottomNavigationDecoration() {
    // return Container(
    //   decoration: const BoxDecoration(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.red,
    //         blurRadius: 0.1,
    //         spreadRadius: 0.0,
    //       )
    //     ],
    //   ),
    //   child: bottomNavigationBar(),
    // );
    return bottomNavigationBar();
  }

  // AppRouteNotifier get state => widget.delegate.state;
  // List<RouteType> get route => state.routesPrimary;
  // AppRouteNotifier get state => App.routeDelegate.state;
  // List<RouteType> get route => state.routesPrimary;

  // late final bottomNavigation = route.map((e) {
  //   return BottomNavigationBarItem(
  //     icon: Icon(e.icon),
  //     label: e.label,
  //   );
  // });

  // Widget bottomNavigationBar() {
  //   return AnimatedBuilder(
  //     animation: state,
  //     builder: (_, child) {
  //       return Row(
  //         mainAxisSize: MainAxisSize.max,
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: route
  //             .asMap()
  //             .map(
  //               (index, item) {
  //                 return MapEntry(
  //                   index,
  //                   button(index, item),
  //                 );
  //               },
  //             )
  //             .values
  //             .toList(),
  //       );
  //     },
  //   );
  // }

  // Widget button(int index, RouteType item) {
  //   return Expanded(
  //     flex: 2,
  //     child: InkWell(
  //       // minSize: 25,
  //       // height: double.maxFinite,
  //       // decoration: const BoxDecoration(color: Colors.amber),
  //       // w: double.maxFinite,
  //       // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
  //       // disabledColor: route ? CupertinoColors.quaternarySystemFill : Theme.of(context).hintColor,
  //       // onPressed: current?null:()=>route?_navView(index):item.action(context)
  //       onTap: () {
  //         state.viewIndex = index;
  //       },
  //       child: ExcludeSemantics(
  //         excluding: true,
  //         child: AnimatedContainer(
  //           curve: Curves.easeIn,
  //           duration: const Duration(milliseconds: 300),
  //           padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
  //           child: Icon(
  //             item.icon,
  //             size: state.viewIndex == index ? 26 : 18,
  //             // semanticLabel: item.name,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget bottomNavigationBar() {
  //   return AnimatedBuilder(
  //     animation: App.routeDelegate.state,
  //     builder: (_, child) {
  //       return BottomNavigationBar(
  //         backgroundColor: Colors.transparent,
  //         items: App.routeDelegate.state.routesPrimary.map((e) {
  //           return BottomNavigationBarItem(
  //             icon: Icon(e.icon),
  //             label: e.label,
  //           );
  //         }).toList(),
  //         currentIndex: App.routeDelegate.state.viewIndex,
  //         elevation: 0,
  //         onTap: (index) {
  //           App.routeDelegate.state.viewIndex = index;
  //         },
  //       );
  //     },
  //   );
  // }
  Widget bottomNavigationBar() {
    return AnimatedBuilder(
      animation: App.routeDelegate.notifier,
      builder: (context, child) {
        return BottomNavigationBar(
          // backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: Theme.of(context).iconTheme.copyWith(
                size: 25,
              ),
          items: App.routeDelegate.notifier.routesPrimary.map((e) {
            return BottomNavigationBarItem(
              // icon: AnimatedOpacity(
              //   opacity: App.scroll.bottomFactor.value,
              //   duration: Duration.zero,
              //   child: Icon(e.icon),
              // ),
              icon: Icon(e.icon),
              label: e.label,
            );
          }).toList(),
          currentIndex: App.routeDelegate.notifier.viewIndex,
          elevation: 1,
          onTap: (index) {
            App.routeDelegate.notifier.viewIndex = index;
          },
        );
      },
    );
  }
}
