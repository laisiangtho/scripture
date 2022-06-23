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
    await Future.delayed(const Duration(milliseconds: 50));
    await core.updateBookMeta();
    await Future.delayed(const Duration(milliseconds: 100));
    await core.collection.updateToken();
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
