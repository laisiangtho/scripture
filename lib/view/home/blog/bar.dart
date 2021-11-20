part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: true,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: const [kBottomNavigationBarHeight, 40],
      // overlapsBackgroundColor:Theme.of(context).primaryColor.withOpacity(0.8),
      overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: kBottomNavigationBarHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 50, end: 0),
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

                  // TweenAnimationBuilder<double>(
                  //   tween: Tween<double>(begin: 100, end: 0),
                  //   duration: const Duration(milliseconds: 150),
                  //   builder: (BuildContext context, double align, Widget? child) {
                  //     return Positioned(
                  //       left: align,
                  //       top: 7,
                  //       child: child!
                  //     );
                  //   },
                  //   child: CupertinoButton(
                  //     padding: const EdgeInsets.only(left:7),
                  //     child: const Hero(
                  //       tag: 'appbar-left',
                  //       child: LabelAttribute(
                  //         // icon: Icons.arrow_back_ios_new,
                  //         icon: CupertinoIcons.left_chevron,
                  //         label: 'Back',
                  //       ),
                  //     ),
                  //     onPressed: () => Navigator.of(context).pop()
                  //   )
                  // ),

                  Align(
                    // alignment: const Alignment(0,0.2),
                    child: Hero(
                      tag: 'appbar-center',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          'Blog',
                          style: Theme.of(context).textTheme.headline6,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 0,
                    top: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 13),
                      child: Hero(
                        tag: 'appbar-right',
                        child: Material(
                          type: MaterialType.transparency,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            minSize: 30,
                            onPressed: showFilter,
                            child: WidgetLabel(
                              // icon: Icons.tune,
                              icon: CupertinoIcons.slider_horizontal_3,
                              // icon: LideaIcon.sliders,
                              label: translate.filter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: snap.shrink,
              child: SizedBox(
                height: snap.offset,
                width: double.infinity,
                child: _barOptional(snap.shrink),
              ),
            )
          ],
        );
      },
    );
  }

  // Start with "M, C" in "Myanmar, Mizo" at "*" has (79)
  // Start with (*) in (*) at (*) matched (2074)
  // Artists (2074) begin with (*) in (*)
  // Artists (2074) begin with (*)
  Widget _barOptional(double stretch) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7 * stretch, horizontal: 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        children: [
          RichText(
            strutStyle: StrutStyle(height: 1 * stretch),
            text: TextSpan(
              text: 'Selected ',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                    fontSize: 18 * stretch,
                  ),
              children: const [
                TextSpan(text: '(...)'),
                TextSpan(text: '...'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showFilter() {}
}
