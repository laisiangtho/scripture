part of 'main.dart';

mixin _BottomNavigator on _State {
  // Widget bottomNavigator() {
  //   return const Player();
  // }

  Widget bottomNavigator() {
    return Consumer<ViewScrollNotify>(
      builder: (context, scrollNavigation, child) {
        // scrollNavigation.bottomPadding = MediaQuery.of(context).padding.bottom;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          height: scrollNavigation.heightStretch,
          child: sheetDecoration(
            child: AnimatedOpacity(
              opacity: scrollNavigation.factor,
              duration: Duration.zero,
              child: child,
            ),
          ),
        );
      },
      child: bottomBuilder(),
    );
  }

  Widget bottomBuilder() {
    return Consumer<NavigationNotify>(
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
                    bottomItem(
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

  Widget bottomItem({
    required BuildContext context,
    required int index,
    required ViewNavigationModel item,
    required bool disabled,
    required bool route,
  }) {
    return Expanded(
      flex: 2,
      child: Tooltip(
        message: item.description!,
        child: WidgetButton(
          // minSize: 25,
          // height: double.maxFinite,
          // decoration: const BoxDecoration(color: Colors.amber),
          // w: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
          child: ExcludeSemantics(
            excluding: true,
            child: AnimatedContainer(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Icon(
                item.icon,
                size: route ? 26 : 18,
                // semanticLabel: item.name,
              ),
            ),
          ),
          // disabledColor: route ? CupertinoColors.quaternarySystemFill : Theme.of(context).hintColor,
          // onPressed: current?null:()=>route?_navView(index):item.action(context)
          onPressed: _navButtonAction(item, disabled),
        ),
      ),
    );
  }

  void Function()? _navButtonAction(ViewNavigationModel item, bool disable) {
    if (disable) {
      return null;
    } else if (item.action == null) {
      return () => _navPageViewAction(item.key);
    } else {
      return item.action;
    }
  }

  Widget sheetDecoration({Widget? child}) {
    return Container(
      decoration: BoxDecoration(
        // color: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).primaryColor,
        // color: Colors.transparent,
        // borderRadius: const BorderRadius.vertical(
        //   top: Radius.circular(70),
        //   // top: Radius.elliptical(15, 15),
        // ),
        // border: Border.all(color: Colors.blueAccent),
        // border: Border(
        //   top: BorderSide(width: 0.3, color: Theme.of(context).shadowColor),
        // ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            // color: Theme.of(context).shadowColor.withOpacity(0.9),
            // color: Theme.of(context).backgroundColor.withOpacity(0.6),
            blurRadius: 0.2,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          )
        ],
      ),
      clipBehavior: Clip.hardEdge,
      // margin: EdgeInsets.only(top: 0.5),
      // height: height,
      // padding: EdgeInsets.only(top: 0.5),
      child: child,
    );
  }
}
