part of ui.widget;

class PullToRefresh extends PullToAny {
  const PullToRefresh({Key? key}) : super(key: key);

  @override
  State<PullToAny> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends PullOfState {
  @override
  Future<void> refreshUpdate() {
    return context.read<Core>().updateBookMeta();
  }
}
