part of data.core;

class Poll extends ClusterPoll {
  final void Function() notify;
  final Authentication authentication;

  Poll(Collection docket, this.notify, this.authentication) : super(docket);

  /// Update token, local (-member.csv, -result.csv -info.json)
  Future<void> updateAll() async {
    await Future.delayed(const Duration(milliseconds: 50));

    await updateToken();
    await Future.delayed(const Duration(milliseconds: 100));

    if (authentication.hasUser) {
      await readLiveAll();
      await Future.delayed(const Duration(milliseconds: 500));
    }
    notify();
  }

  String get userEmail => authentication.userEmail;
  // String get userEmail => 'test@gmail.com';

  Future<void> updateIndividual() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (authentication.hasUser) {
      await pollBoard.readLive();
    }
    await Future.delayed(const Duration(milliseconds: 500));
    notify();
  }

  /// all Avaliable Polls to current user
  List<PollBoard> get userPollBoard => listOfUserPollBoard(userEmail);

  Future<void> vote() async {
    Stopwatch taskWatch = Stopwatch()..start();
    if (authentication.hasUser && pollBoard.hasReady2Submit) {
      await pollBoard.postVote(userMemberId);
    }
    if (taskWatch.elapsedMilliseconds < 1000) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    notify();
  }

  void toggleSelection(int id) {
    pollBoard.toggleSelection(id);
    notify();
  }

  int get userMemberId => pollBoard.memberId(userEmail);

  bool get hasSubmitted {
    return pollBoard.result.where((e) => e.memberId.contains(userMemberId)).isNotEmpty;
  }

  // userVotedCandidate
  bool userVotedCandidate(int id) {
    return pollBoard.result.where((e) {
      return e.memberId.contains(userMemberId) && e.candidateId == id;
    }).isNotEmpty;
  }
}
