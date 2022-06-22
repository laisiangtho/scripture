part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    return ViewHeaderLayoutStack(
      leftAction: [
        WidgetButton(
          show: hasArguments,
          onPressed: args?.currentState!.maybePop,
          child: WidgetMark(
            icon: Icons.arrow_back_ios_new_rounded,
            label: preference.text.back,
          ),
        ),
      ],
      primary: WidgetAppbarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          org.snapShrink,
        ),
        label: preference.text.holyBible,
        shrink: org.shrink,
      ),
      rightAction: [
        WidgetButton(
          message: preference.text.option(true),
          onPressed: () => core.navigate(to: '/user'),
          child: WidgetMark(
            child: Selector<Authentication, bool>(
              selector: (_, e) => e.hasUser,
              builder: (BuildContext _, bool hasUser, Widget? child) {
                return UserIcon(authenticate: authenticate);
              },
            ),
          ),
        )
      ],
    );
  }
}
