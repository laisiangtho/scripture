part of 'main.dart';

abstract class _State extends WidgetState with SingleTickerProviderStateMixin {
  late final args = argumentsAs<ViewNavigationArguments>();
  // late final param = args?.param<ViewNavigationArguments>();
  late final param = args?.param<String>();

  // late final poll = context.watch<Core>().poll;
  late final poll = context.watch<Core>().poll;
  // late final poll = core.poll;

  late final AnimationController busyController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  late final Animation<double> busyAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(busyController);

  @override
  void initState() {
    super.initState();
    // final asdf = argumentsAs<String>();
    // final asdf = args?.args;
    // debugPrint('arguments $param');
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool canPop() {
    return hasArguments || Navigator.of(context).canPop();
  }

  void Function()? maybePop() {
    if (hasArguments) {
      return args?.currentState!.maybePop;
    } else if (Navigator.of(context).canPop()) {
      // Came from root
      return Navigator.of(context).maybePop;
    }
    return null;
  }

  Future<void> vote() async {
    busyController.forward();
    await poll.vote();
    busyController.reverse();
  }

  bool get hasReady2Vote {
    return hasReady2Submit && busyAnimation.isDismissed;
  }

  bool get hasReady2Submit {
    return pollBoard.hasReady2Submit;
  }

  PollBoard get pollBoard => poll.pollBoard;
  List<PollMemberType> get candidates => pollBoard.listOfCandidate();
  List<PollResultType> get results => pollBoard.listOfResult();
  List<int> get selection => pollBoard.selection;
  String get selectionCount => selection.isEmpty ? '' : selection.length.toString();

  // int get userMemberId => pollBoard.memberId(authenticate.userEmail);

  void showMember() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext _) {
        return const MemberModal();
      },
      isScrollControlled: true,
      useRootNavigator: true,
      // elevation: 10,
    );
  }
}
