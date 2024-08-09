part of 'main.dart';

class UserProfileIcon extends UserIconWidget {
  const UserProfileIcon({super.key});

  @override
  bool get userSignedIn => App.authenticate.hasUser;
  @override
  String? get userPhotoURL => App.authenticate.userPhotoURL;

  @override
  Widget build(BuildContext context) {
    return ViewButtons(
      message: App.preference.text.account,
      style: Theme.of(context).textTheme.labelMedium,
      onPressed: () => App.route.pushNamed('home/user'),
      child: ViewMarks(
        child: Selector<Authenticate, bool>(
          selector: (_, e) => e.hasUser,
          builder: (BuildContext _, bool hasUser, Widget? child) {
            return super.build(context);
          },
        ),
      ),
    );
  }
}
