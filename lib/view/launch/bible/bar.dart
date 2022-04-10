part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    return ViewHeaderLayoutStack(
      leftAction: [
        WidgetButton(
          child: WidgetMark(
            icon: Icons.arrow_back_ios_new_rounded,
            label: preference.text.back,
          ),
          show: canPop(),
          onPressed: maybePop(),
        ),
      ],
      primary: WidgetAppbarTitle(
        label: preference.text.bible(false),
      ),
      rightAction: [
        WidgetButton(
          child: AnimatedBuilder(
            animation: dragController,
            builder: (context, _) {
              return WidgetMark(
                icon: Icons.sort,
                iconColor: colorAnimation.value,
              );
            },
          ),
          onPressed: onSort,
        ),
      ],
    );
  }
}
