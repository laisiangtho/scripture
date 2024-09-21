part of 'main.dart';

class UserProfileIcon extends UserIconWidget {
  const UserProfileIcon({super.key});

  @override
  Core get app => App.core;

  @override
  Widget build(BuildContext context) {
    return ViewButtons(
      message: app.preference.lang(context).account,
      style: Theme.of(context).textTheme.labelMedium,
      onPressed: () => context.push('/user'),
      child: ViewMarks(
        // child: Selector<Core, Authenticate>(
        //   selector: (_, e) => e.authenticate,
        //   builder: (BuildContext _, Authenticate o, Widget? child) {
        //     return super.build(context);
        //   },
        // ),
        child: StreamBuilder<dynamic>(
          stream: authenticate.stream,
          builder: (context, snapshot) {
            return super.build(context);
          },
        ),
      ),
    );
  }
}
