part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController _controller = ScrollController();
  // late final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));
  // late AppScrollBottomBarController _bottomBarController;

  // RouteNotifier get routes => Of.route;

  // late final args = argumentsAs<ViewNavigationArguments>();

  // late final poll = context.watch<Core>().poll;
  // late final poll = context.read<Core>().poll;
  late final poll = core.poll;

  // @override
  // void initState() {
  //   super.initState();
  // }

  Future<void> whenCompleteSignIn() async {
    // if (authenticate.message.isNotEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(authenticate.message),
    //     ),
    //   );
    // }
    // if (authenticate.hasUser) {
    //   await poll.updateAll();
    // }
  }

  void _launchAppCode() {
    Launcher.universalLink('https://github.com/laisiangtho/scripture');
  }

  void _launchPrivacy() {
    Launcher.universalLink('https://github.com/laisiangtho/scripture/blob/master/PRIVACY.md');
  }

  void _launchAppIssues() {
    Launcher.universalLink('https://github.com/laisiangtho/scripture/issues/new');
  }
}
