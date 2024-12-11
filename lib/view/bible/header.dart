part of 'main.dart';

mixin _Header on _State {
  Widget _headerMobile(BuildContext context, ViewBarData vbd) {
    return ViewBarLayouts(
      data: vbd,
      primaryVerticalPadding: 60,
      left: [
        OptionButtons.back(
          label: lang.back,
        ),
      ],
      primary: ViewBarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          vbd.snapShrink,
        ),
        label: lang.bible('false'),
        data: vbd,
      ),
      right: [
        ViewDelays.milliseconds(
          milliseconds: 1000,
          builder: (_, __) {
            return ViewButtons(
              onPressed: showLangFilter,
              badge: iso.selection.length.toString(),
              child: const Icon(LideaIcon.language, size: 21),
            );
          },
        ),
        ViewButtons(
          message: lang.sort,
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
