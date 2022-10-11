part of 'main.dart';

mixin _Header<T> on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    return ViewHeaderLayoutStack(
      data: data,
      left: [
        BackButtonWidget(
          navigator: state.navigator,
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
          enable: App.authenticate.hasUser,
          onPressed: App.authenticate.signOut,
          child: const Icon(Icons.logout_rounded),
        ),
      ],
    );
  }
}
