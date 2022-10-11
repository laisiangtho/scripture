part of 'main.dart';

abstract class _State extends StateAbstract<Main> with SingleTickerProviderStateMixin {
  late final ScrollController _controller = ScrollController();

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
  }

  late final poll = context.watch<Core>().poll;
  PollBoard get pollBoard => poll.pollBoard;
  List<PollMemberType> get candidates => pollBoard.listOfCandidate();
  List<PollResultType> get results => pollBoard.listOfResult();
  List<int> get selection => pollBoard.selection;
  String get selectionCount => selection.isEmpty ? '' : selection.length.toString();

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

  // int get userMemberId => pollBoard.memberId(authenticate.userEmail);

  void showMember() {
    route.showSheetModal(context: context, name: 'sheet-poll');
  }
}
