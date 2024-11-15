part of 'main.dart';

mixin _Header on _State {
  Widget _headerMobile(BuildContext context, ViewBarData vbd) {
    return ViewBarLayouts(
      data: vbd,
      primaryVerticalPadding: 60,
      left: const [
        Buttons.backOrMenu(),
      ],
      primary: ViewBarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          vbd.snapShrink,
        ),
        label: lang.holyBible,
        data: vbd,
      ),
      right: const [
        UserProfileIcon(),
      ],
    );
  }
}
