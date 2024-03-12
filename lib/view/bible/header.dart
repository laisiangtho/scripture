part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    return ViewHeaderLayoutStack(
      data: data,
      left: [
        BackButtonWidget(
          navigator: state.navigator,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          data.snapShrink,
        ),
        label: App.preference.text.bible('false'),
        data: data,
      ),
      right: [
        ViewButton(
          onPressed: onSort,
          child: AnimatedBuilder(
            animation: _dragController,
            builder: (_, __) {
              return ViewMark(
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
