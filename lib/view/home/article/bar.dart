part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: const [kBottomNavigationBarHeight, 50],
      overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        return Stack(
          alignment: const Alignment(0, 0),
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: arguments.canPop ? 0 : 50, end: 0),
              duration: const Duration(milliseconds: 300),
              builder: (BuildContext context, double align, Widget? child) {
                return Positioned(
                  left: align,
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
                    child: (align == 0)
                        ? CupertinoButton(
                            padding: EdgeInsets.zero,
                            minSize: 30,
                            child: Hero(
                              tag: 'appbar-left',
                              child: WidgetLabel(
                                icon: CupertinoIcons.left_chevron,
                                label: translate.back,
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        : WidgetLabel(
                            icon: CupertinoIcons.left_chevron,
                            label: translate.back,
                          ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.lerp(
                const Alignment(0, 0),
                const Alignment(0, .5),
                snap.shrink,
              )!,
              child: Hero(
                tag: 'appbar-center',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    'Article',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: (30 * org.shrink).clamp(20, 30).toDouble()),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
