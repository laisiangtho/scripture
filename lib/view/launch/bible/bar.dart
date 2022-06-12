part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    return ViewHeaderLayoutStack(
      leftAction: [
        WidgetButton(
          show: canPop(),
          onPressed: maybePop(),
          child: WidgetMark(
            icon: Icons.arrow_back_ios_new_rounded,
            label: preference.text.back,
          ),
        ),
      ],
      primary: WidgetAppbarTitle(
        label: preference.text.bible(false),
      ),
      rightAction: [
        WidgetButton(
          onPressed: onSort,
          child: AnimatedBuilder(
            animation: dragController,
            builder: (context, _) {
              return WidgetMark(
                icon: Icons.sort,
                iconColor: colorAnimation.value,
              );
            },
          ),
        ),
      ],
    );
  }
}
