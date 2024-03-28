part of 'main.dart';

mixin _Header<T> on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    return ViewHeaderLayoutStack(
      data: data,
      left: [
        BackButtonWidget(
          navigator: state.navigator,
          rootNavigator: true,
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
        ViewButton(
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
