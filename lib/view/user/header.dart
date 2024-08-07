part of 'main.dart';

mixin _Header<T> on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    return ViewHeaderLayouts(
      data: data,
      left: [
        OptionButtons.back(
          navigator: state.navigator,
          label: App.preference.text.back,
        ),
      ],
      primary: Align(
        alignment: const Alignment(0, 0),
        child: UserPictureWidget(
          authenticate: App.authenticate,
          snapShrink: data.snapShrink,
        ),
      ),
      right: [
        ViewButtons(
          message: App.preference.text.signOut,
          show: App.authenticate.hasUser,
          onPressed: App.authenticate.signOut,
          child: Icon(
            Icons.logout_rounded,
            color: state.theme.focusColor,
          ),
        ),
      ],
    );
  }
}
