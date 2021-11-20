part of 'main.dart';

mixin _Bar on _State {
  Widget bar(hasValue) {
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
                  top: 4,
                  child: (align == 0)
                      ? CupertinoButton(
                          padding: EdgeInsets.zero,
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
                    translate.recentSearch,
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
            Positioned(
              right: 0,
              top: 4,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Hero(
                  tag: 'appbar-right',
                  child: Material(
                    type: MaterialType.transparency,
                    child: WidgetLabel(
                      icon: LideaIcon.trash,
                      // icon: CupertinoIcons.search,
                      // icon: Icons.delete_sweep_rounded,
                    ),
                  ),
                ),
                onPressed: hasValue
                    ? () {
                        doConfirmWithDialog(
                          context: context,
                          message: 'Do you really want to delete all?',
                        ).then((bool? confirmation) {
                          if (confirmation != null && confirmation) onClearAll();
                        });
                      }
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
