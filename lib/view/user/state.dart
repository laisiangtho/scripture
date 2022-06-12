part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  // late final poll = context.watch<Core>().poll;
  // late final poll = context.read<Core>().poll;
  late final poll = core.poll;

  @override
  void initState() {
    super.initState();
  }

  Future<void> whenCompleteSignIn() async {
    if (authenticate.message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authenticate.message),
        ),
      );
    }
    if (authenticate.hasUser) {
      await poll.updateAll();
    }
  }
}
