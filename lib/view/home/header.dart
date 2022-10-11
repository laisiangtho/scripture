part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData vhd) {
    return ViewHeaderLayoutStack(
      data: vhd,
      left: [
        BackButtonWidget(
          navigator: state.navigator,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          vhd.snapShrink,
        ),
        label: preference.text.holyBible,
        data: vhd,
      ),
      right: const [
        UserProfileIcon(),
      ],
    );
  }
}
