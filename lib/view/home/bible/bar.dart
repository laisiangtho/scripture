part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: const [kBottomNavigationBarHeight],
      // overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        return Stack(
          alignment: const Alignment(0, 0),
          children: [
            // This make the return "appbar-left" Hero animation smooth
            // Positioned(
            //   left: 0,
            //   top: 0,
            //   child: Padding(
            //     // padding: const EdgeInsets.symmetric(horizontal: 0),
            //     padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            //     child: Hero(
            //       tag: 'appbar-left',
            //       child: CupertinoButton(
            //         padding: EdgeInsets.zero,
            //         minSize: 30,
            //         onPressed: () => Navigator.of(context).pop(),
            //         child: Material(
            //           type: MaterialType.transparency,
            //           child: WidgetLabel(
            //             icon: CupertinoIcons.left_chevron,
            //             label: translate.back,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 30, end: 0),
              duration: const Duration(milliseconds: 300),
              builder: (BuildContext context, double align, Widget? child) {
                return Positioned(
                  left: align,
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    child: Hero(
                      tag: 'appbar-left-5',
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 30,
                        // color: Colors.red,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: WidgetLabel(
                          icon: CupertinoIcons.left_chevron,
                          label: translate.back,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: 'appbar-center',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    translate.bible(false),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
            ),

            Positioned(
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
                child: Hero(
                  tag: 'appbar-right-4',
                  child: Material(
                    type: MaterialType.transparency,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 30,
                      onPressed: onSort,
                      child: AnimatedBuilder(
                        animation: dragController,
                        builder: (context, _) {
                          return WidgetLabel(
                            icon: Icons.sort,
                            iconColor: colorAnimation.value,
                            message: translate.sort,
                          );
                        },
                      ),
                    ),
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
