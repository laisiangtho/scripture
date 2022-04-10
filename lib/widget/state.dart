part of ui.widget;

// with SingleTickerProviderStateMixin
// with TickerProviderStateMixin
abstract class WidgetState<T extends StatefulWidget> extends State<T> {
  late final scrollController = ScrollController();
  late final textController = TextEditingController();
  late final focusNode = FocusNode();

  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;
  late final Collection collection = core.collection;
  late final Store store = core.store;
  // late final AudioBucketType cacheBucket = collection.cacheBucket;
  // late final Audio audio = core.audio;
  late final authenticate = context.read<Authentication>();
  late final navigation = context.read<NavigationNotify>();
  // late final scrollNotify = Provider.of<ViewScrollNotify>(context, listen: false);
  // late final translate = AppLocalizations.of(context)!;

  // ModalRoute.of(context)!.settings.arguments
  Object? arguments;
  // Check arguments is null
  bool get hasArguments => arguments != null;
  M? argumentsAs<M>() => arguments as M?;

  String get searchQuery => core.searchQuery;
  set searchQuery(String ord) {
    core.searchQuery = ord;
  }

  String get suggestQuery => core.suggestQuery;
  set suggestQuery(String ord) {
    core.suggestQuery = ord.replaceAll(RegExp(' +'), ' ').trim();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    arguments ??= ModalRoute.of(context)!.settings.arguments;
  }

  @override
  void dispose() {
    // store.dispose();
    super.dispose();
    scrollController.dispose();
    textController.dispose();
    focusNode.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
}

// abstract class _StateNoneOne<Main> extends _CommonNone {}
// abstract class _StateNoneTwo extends _CommonNone<Main> {}

// abstract class _CommonNone<T extends StatefulWidget> extends State<T> {}

// abstract class _StateMain extends _CommonMain {}
// abstract class _CommonMain<T extends StatefulWidget> extends State<Main> {}