part of 'main.dart';

mixin _Bar<T> on _State {
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
      primary: Align(
        alignment: const Alignment(0, 0),
        child: UserPicture(
          authenticate: authenticate,
          snapShrink: org.snapShrink,
        ),
      ),
      rightAction: [
        WidgetButton(
          message: preference.text.signOut,
          enable: authenticate.hasUser,
          onPressed: authenticate.signOut,
          child: const WidgetMark(
            icon: Icons.logout_rounded,
          ),
        ),
      ],
    );
  }
}
