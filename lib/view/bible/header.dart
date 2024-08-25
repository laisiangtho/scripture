part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData vhd) {
    return ViewHeaderLayouts(
      data: vhd,
      left: [
        OptionButtons.back(
          navigator: state.navigator,
          label: preference.text.back,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          vhd.snapShrink,
        ),
        label: preference.text.bible('false'),
        data: vhd,
      ),
      right: [
        ViewButtons(
          message: preference.text.sort,
          onPressed: onSort,
          child: AnimatedBuilder(
            animation: _dragController,
            builder: (_, __) {
              return ViewMarks(
                icon: Icons.sort,
                iconColor: _colorAnimation.value,
              );
            },
          ),
        ),
      ],
    );
  }
}
