part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext _, ViewHeaderData vhd) {
    return ViewHeaderLayouts(
      data: vhd,
      left: [
        OptionButtons.back(
          label: lang.back,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          vhd.snapShrink,
        ),
        label: lang.holyBible,
        data: vhd,
      ),
      right: const [
        UserProfileIcon(),
      ],
    );
  }
}
