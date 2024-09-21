part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData vhd) {
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
        label: lang.bible('false'),
        data: vhd,
      ),
      right: [
        // Align(
        //   alignment: Alignment.lerp(
        //     const Alignment(0, 0),
        //     const Alignment(0, 4.4),
        //     vhd.snapShrink,
        //   )!,
        //   child: ViewDelays.milliseconds(
        //     milliseconds: 1200,
        //     builder: (_, __) {
        //       return ViewButtons(
        //         onPressed: () {},
        //         badge: iso.selection.length.toString(),
        //         child: const Icon(LideaIcon.language, size: 21),
        //       );
        //     },
        //   ),
        // ),
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
