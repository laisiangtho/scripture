part of ui.widget;

class WidgetDraggableInfoModal extends ViewDraggableSheetWidget {
  final BooksType book;
  const WidgetDraggableInfoModal({Key? key, required this.book}) : super(key: key);

  @override
  State<WidgetDraggableInfoModal> createState() => _WidgetDraggableInfoState();
}

class _WidgetDraggableInfoState extends ViewDraggableSheetState<WidgetDraggableInfoModal> {
  @override
  bool get persistent => false;
  @override
  double get initialSize => 0.5;
  @override
  double get minSize => 0.4;

  bool isDownloading = false;
  String message = '';

  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;
  late final BooksType book = widget.book;

  bool get isAvailable => book.available > 0;

  void Function()? download() {
    if (isDownloading) {
      return null;
    }
    return _startDownloadOrDelete;
  }

  void _startDownloadOrDelete() async {
    core.analytics.content(isAvailable ? 'Delete' : 'Download', book.identify);
    setState(() {
      isDownloading = !isDownloading;
    });
    core.switchAvailabilityUpdate(book.identify).then((_) {
      setState(() {
        isDownloading = !isDownloading;
        message = 'finish';
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        // Navigator.pop(context, 'done');
        Navigator.of(context).maybePop();
      });

      // store.googleAnalytics.then((e)=>e.sendEvent(store.identify, store.appVersion));
    }).catchError((error) {
      setState(() {
        isDownloading = !isDownloading;
        debugPrint('33: $error');
        if (error is String) {
          message = error;
        } else {
          message = message.toString();
        }
      });
    });
  }

  @override
  List<Widget> sliverWidgets() {
    return <Widget>[
      SliverAppBar(
        pinned: true,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: WidgetAppbarTitle(
          label: book.name,
        ),
        actions: [
          WidgetMark(
            icon: Icons.verified_user_rounded,
            iconColor: theme.primaryColorDark,
            show: isAvailable,
          ),
        ],
      ),
      SliverList(
        delegate: SliverChildListDelegate(
          [
            WidgetLabel(
              padding: const EdgeInsets.all(20),
              label: book.year.toString(),
            ),
            WidgetLabel(
              label: book.langName.toUpperCase(),
            ),
            WidgetLabel(
              padding: const EdgeInsets.all(20),
              label: book.identify,
            ),
            WidgetMark(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              label: message,
              show: message.isNotEmpty,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WidgetButton(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
                  // color: theme.highlightColor,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  color: isAvailable ? theme.primaryColorDark : theme.highlightColor,
                  elevation: 1,
                  onPressed: download(),

                  // decoration: BoxDecoration(
                  //   color: isAvailable ? theme.primaryColorDark : theme.highlightColor,
                  //   borderRadius: BorderRadius.circular(100),
                  //   // border: Border.all(
                  //   //   color: Theme.of(context).shadowColor,
                  //   //   width: 1,
                  //   // ),
                  // ),
                  // clipBehavior: Clip.hardEdge,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isDownloading)
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.primaryColor,
                          ),
                        )
                      else
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Icon(
                            isAvailable ? Icons.remove_circle : Icons.add_circle,
                            size: 29,
                            color: theme.primaryColor,
                          ),
                        ),
                      const Divider(
                        indent: 10,
                      ),
                      WidgetLabel(
                        constraints: const BoxConstraints(maxHeight: 30),
                        label: isAvailable ? preference.text.delete : preference.text.download,
                        labelStyle: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.primaryColor,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
