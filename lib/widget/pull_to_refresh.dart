part of ui.widget;

class PullToRefresh extends PullToActivate {
  const PullToRefresh({Key? key}) : super(key: key);

  @override
  State<PullToActivate> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends PullOfState {
  late final Core core = context.read<Core>();
  @override
  Future<void> refreshUpdate() async {
    await core.updateBookMeta();
    // await core.collection.updateToken();
  }
}
