part of 'screen_launcher.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  Core get app => App.core;

  RouteNotifier get route => app.routeDelegate.notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      // valueListenable: App.scroll.bottomFactor,
      valueListenable: app.bottom.factor,
      builder: (_, factor, child) {
        // scrollNavigation.bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        return Align(
          alignment: const Alignment(0, -1),
          heightFactor: factor,
          child: Padding(
            // padding: EdgeInsets.only(bottom: App.viewData.fromContext.viewPadding.bottom),
            padding: const EdgeInsets.only(bottom: 0),
            child: bottomNavigationToggle(),
          ),
        );
      },
    );
  }

  Widget bottomNavigationToggle() {
    return ValueListenableBuilder<double>(
      valueListenable: app.bottom.toggle,
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

  Widget bottomNavigationBar() {
    return AnimatedBuilder(
      animation: app.routeDelegate.notifier,
      builder: (context, child) {
        return BottomNavigationBar(
          // backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          // useLegacyColorScheme: false,
          selectedIconTheme: Theme.of(context).iconTheme.copyWith(
                size: 25,
              ),
          items: route.routesPrimary.map((e) {
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
          currentIndex: route.viewIndex,
          // elevation: 3,
          onTap: (index) {
            if (route.viewIndex == index) {
              // final abc = App.routeDelegate.navigatorKey.currentState;
              // debugPrint('bottomNavigationBar $index');
              // if (abc != null) {
              //   debugPrint('bottomNavigationBar abc $index');
              //   abc.
              // }
              // Navigator.of(context).maybePop();
              // App.routeDelegate.notifier.pop();
              // App.route.pop();
              // App.route.viewIndex
            } else {
              route.viewIndex = index;
            }
          },
        );
      },
    );
  }
}
