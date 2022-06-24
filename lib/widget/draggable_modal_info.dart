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
  double get initialSize => 0.6;
  @override
  double get minSize => 0.4;

  bool isDownloading = false;
  String message = '';

  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;
  late final BooksType book = widget.book;

  bool get isAvailable => book.available > 0;

  String get bookName => book.name;

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
      // SliverAppBar(
      //   pinned: true,
      //   elevation: 0.5,
      //   automaticallyImplyLeading: false,
      //   title: WidgetAppbarTitle(
      //     label: book.name,
      //   ),
      //   actions: [
      //     WidgetMark(
      //       icon: Icons.verified_user_rounded,
      //       iconColor: theme.primaryColorDark,
      //       show: isAvailable,
      //     ),
      //   ],
      // ),
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        // padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 50],
        backgroundColor: Colors.transparent,
        overlapsBackgroundColor: theme.scaffoldBackgroundColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: (_, org) {
          return ViewHeaderLayoutStack(
            primary: WidgetAppbarTitle(
              alignment: Alignment.lerp(
                const Alignment(0, 0),
                const Alignment(0, .5),
                org.snapShrink,
              ),
              shrink: org.shrink,
              // label: book.name,
              label: book.shortname,
            ),
            rightAction: [
              WidgetMark(
                icon: Icons.verified_user_rounded,
                iconColor: theme.primaryColorDark,
                show: isAvailable,
              ),
            ],
          );
        },
      ),

      // SliverAppBar(
      //   pinned: true,
      //   snap: false,
      //   floating: false,
      //   expandedHeight: 80.0,
      //   elevation: 0.3,
      //   leading: IconButton(
      //     icon: const Icon(Icons.close),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      //   backgroundColor: theme.primaryColor,
      //   flexibleSpace: FlexibleSpaceBar(
      //     centerTitle: true,
      //     // title: const Text('Title asdfa sdfa sdfasdfasdfasf asdf'),
      //     title: Text(book.name),
      //     // title: WidgetAppbarTitle(
      //     //   label: book.name,
      //     // ),
      //     // background: Image.network(
      //     //   'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
      //     //   fit: BoxFit.cover,
      //     // ),
      //     background: Container(
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           begin: Alignment.topCenter,
      //           end: Alignment.bottomCenter,
      //           colors: <Color>[
      //             theme.scaffoldBackgroundColor,
      //             theme.primaryColor,
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      //   actions: <Widget>[],
      // ),
      SliverPadding(
        padding: const EdgeInsets.all(15.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
            [
              // WidgetLabel(
              //   // labelPadding: const EdgeInsets.only(left: 7),
              //   label: book.year.toString(),
              //   // icon: Icons.circle_outlined,
              //   // iconColor: Theme.of(context).focusColor,
              // ),
              // WidgetLabel(
              //   // labelPadding: const EdgeInsets.only(left: 7),
              //   label: book.langName.toUpperCase(),
              //   // icon: Icons.translate_outlined,
              //   // iconColor: Theme.of(context).focusColor,
              // ),
              // WidgetLabel(
              //   // labelPadding: const EdgeInsets.only(left: 7),
              //   label: book.identify,
              //   // icon: Icons.lightbulb_outlined,
              //   // iconColor: Theme.of(context).focusColor,
              // ),
              // ListTile(
              //   leading: const Icon(Icons.event_outlined),
              //   iconColor: Theme.of(context).primaryColorDark,
              //   title: Text(book.year.toString()),
              // ),
              // ListTile(
              //   leading: const Icon(Icons.translate_outlined),
              //   iconColor: Theme.of(context).primaryColorDark,
              //   title: Text(book.langName.toUpperCase()),
              // ),

              // ListTile(
              //   leading: const Icon(Icons.lightbulb_outlined),
              //   iconColor: Theme.of(context).primaryColorDark,
              //   title: Text(book.identify),
              // ),

              ListTile(
                // leading: const Icon(Icons.lightbulb_outlined),
                // iconColor: Theme.of(context).primaryColorDark,
                title: Row(
                  children: [
                    Expanded(
                      // child: Text(book.langName.toUpperCase()),
                      child: Text(book.langName),
                    ),
                    Text(book.year.toString()),
                  ],
                ),
                // subtitle: Text(book.identify),
                // subtitle: Text(book.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' - ${book.name}'),
                    Text(' - ${book.langDirection}'),
                    Text(' - ${book.identify}'),
                  ],
                ),
                // trailing: Text(book.),
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
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: isAvailable ? theme.primaryColorDark : theme.highlightColor,
                    onPressed: download(),
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
              // isAvailable ? theme.primaryColorDark : theme.highlightColor,
              ListTile(
                selected: isAvailable,
                iconColor: theme.iconTheme.color,
                selectedColor: theme.primaryColorDark,
                leading: const Icon(Icons.add_circle),
                // title: Text(preference.language('byBibleDownload')),
                title: _actionHelpLabel('byBibleDownload'),
              ),
              ListTile(
                selected: !isAvailable,
                iconColor: theme.iconTheme.color,
                selectedColor: theme.primaryColorDark,
                leading: const Icon(Icons.remove_circle),
                title: _actionHelpLabel('byBibleDelete'),
              ),
              const Divider(
                indent: 15,
                color: Colors.transparent,
              ),
              ListTile(
                leading: const Icon(LideaIcon.github),
                title: Text.rich(
                  TextSpan(
                    text: preference.language('RepositoryGithub'),
                    children: [
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: preference.language('ofBibleSource'),
                        style: TextStyle(color: theme.highlightColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Launcher.launchInBrowser(
                                    Uri.parse('https://github.com/laisiangtho/bible'))
                                .then((value) {})
                                .onError((error, stackTrace) {
                              debugPrint(error.toString());
                            });
                          },
                      ),
                      const TextSpan(text: ', '),
                      TextSpan(
                        text: preference.language('ofAppSourcecode'),
                        style: TextStyle(color: theme.highlightColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Launcher.launchInBrowser(
                                    Uri.parse('https://github.com/laisiangtho/scripture'))
                                .then((value) {})
                                .onError((error, stackTrace) {
                              debugPrint(error.toString());
                            });
                          },
                      ),
                      const TextSpan(text: '...'),
                    ],
                  ),
                ),
              ),

              const Divider(
                indent: 15,
                color: Colors.transparent,
              ),

              note(icon: Icons.description_outlined, label: book.description),
              note(icon: Icons.copyright_outlined, label: book.copyright),
              note(icon: Icons.group_work_outlined, label: book.contributors),
              note(icon: Icons.check_circle_outlined, label: book.publisher),
            ],
          ),
        ),
      ),
    ];
  }

  Widget note({required String label, required IconData icon}) {
    if (label.isEmpty) {
      return const SizedBox();
    }
    return ListTile(
      leading: Icon(icon),
      iconColor: Theme.of(context).primaryColorDark,
      title: Text(label),
    );
  }

  Widget _actionHelpLabel(String text) {
    // preference.text.delete : preference.text.download,
    final label = preference
        .language(text)
        .replaceAll('label.download', preference.text.download)
        .replaceAll('label.delete', preference.text.delete)
        .replaceAll('book.name', bookName);

    return Text(label);
  }
}
