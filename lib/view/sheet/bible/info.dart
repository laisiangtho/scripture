import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:lidea/launcher.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/hive.dart';

import '../../../app.dart';

class Main extends SheetsDraggable {
  const Main({super.key});

  static String route = 'sheet-bible-info';
  static String label = 'Bible';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends SheetsDraggableState<Main> {
  @override
  ViewData get viewData => App.viewData;

  late final boxOfBooks = App.data.boxOfBooks;

  late final MapEntry<dynamic, BooksType> item = state.as<MapEntry<dynamic, BooksType>>();

  bool isDownloading = false;
  String message = '';

  BooksType get book => item.value;
  // BooksType get book => boxOfBooks.box.values
  //     .firstWhere((e) => e.identify == item.value.identify, orElse: () => boxOfBooks.values.first);

  int get bookIndex => boxOfBooks.indexOfvalues((e) => e.identify == item.value.identify);

  /// if book.available > 0 or params.identify is empty
  bool get isAvailable => book.identify.isEmpty || book.available > 0;

  String get bookName => book.name;

  // @override
  // ScrollNotifier get notifier => App.scroll;

  // @override
  // bool get persistent => false;
  @override
  double get actualInitialSize => 0.5;
  @override
  double get actualMinSize => 0.4;

  void _launchBibleSource() {
    Launcher.universalLink('https://github.com/laisiangtho/bible');
  }

  void _launchAppCode() {
    Launcher.universalLink('https://github.com/laisiangtho/scripture');
  }

  void _launchAppIssues() {
    Launcher.universalLink('https://github.com/laisiangtho/scripture/issues/new');
  }

  void Function()? download() {
    if (isDownloading) {
      return null;
    }
    return _startDownloadOrDelete;
  }

  void _startDownloadOrDelete() async {
    if (book.identify.isEmpty) {
      boxOfBooks.box.deleteAt(bookIndex);
      Navigator.of(context).maybePop();
      return;
    }
    App.core.analytics.content(isAvailable ? 'Delete' : 'Download', book.identify);
    setState(() {
      isDownloading = !isDownloading;
    });
    App.core.switchAvailabilityUpdate(book.identify).then((_) {
      setState(() {
        isDownloading = !isDownloading;
        message = 'finish';
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        // Navigator.pop(context, 'done');
        Navigator.of(context).maybePop();
      });

      // App.core.store.googleAnalytics.then((e)=>e.sendEvent(store.identify, store.appVersion));
    }).catchError((error) {
      setState(() {
        isDownloading = !isDownloading;
        if (error is String) {
          message = error;
        } else {
          message = message.toString();
        }
      });
    });
  }

  @override
  List<Widget> slivers() {
    return <Widget>[
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        // padding: MediaQuery.of(context).viewPadding,
        heights: const [kTextTabBarHeight, kToolbarHeight],
        // heights: const [kToolbarHeight, kToolbarHeight],
        backgroundColor: state.theme.primaryColor,
        // backgroundColor: Colors.transparent,
        // padding: state.fromContext.viewPadding,
        // overlapsBackgroundColor: state.theme.scaffoldBackgroundColor,
        // overlapsBorderColor: Theme.of(context).shadowColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: (_, vhd) {
          return ViewHeaderLayouts(
            data: vhd,
            left: [
              OptionButtons.cancel(
                navigator: state.navigator,
                label: App.preference.text.cancel,
              ),
            ],
            primary: ViewHeaderTitle(
              alignment: Alignment.lerp(
                const Alignment(0, 0),
                const Alignment(0, 0.5),
                vhd.snapShrink,
              ),
              // label: book.name,
              label: book.shortname,
              data: vhd,
            ),
            right: [
              // ViewMarks(
              //   padding: const EdgeInsets.only(right: 15),
              //   icon: Icons.verified_user_rounded,
              //   iconColor: state.theme.primaryColorDark,
              //   show: isAvailable,
              // ),
              ValueListenableBuilder(
                valueListenable: boxOfBooks.listen(),
                builder: (BuildContext _, Box<BooksType> __, Widget? ___) {
                  return ViewButtons(
                    child: ViewMarks(
                      icon: isAvailable ? Icons.favorite : Icons.favorite_border_outlined,
                      iconColor:
                          book.selected ? state.theme.highlightColor : state.theme.primaryColorDark,
                    ),
                    onPressed: () {
                      book.selected = !book.selected;
                      boxOfBooks.box.putAt(bookIndex, book);
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
      ViewFlats(
        child: ListBody(
          children: [
            ListTile(
              // leading: const Icon(Icons.lightbulb_outlined),
              // iconColor: Theme.of(context).primaryColorDark,
              // tileColor: Colors.red,
              // textColor: Colors.blueGrey,
              titleTextStyle: state.textTheme.titleLarge,
              // visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Row(
                children: [
                  Expanded(
                    // child: Text(book.langName.toUpperCase()),
                    child: Text(
                      book.langName,
                      style: state.textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    book.year.toString(),
                    style: state.textTheme.labelMedium?.copyWith(
                      color: state.theme.hintColor,
                    ),
                  ),
                ],
              ),

              subtitle: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  textDirection: TextDirection.ltr,
                  spacing: 15,
                  runSpacing: 5,
                  children: [
                    ViewMarks(
                      icon: LideaIcon.bible,
                      iconSize: 18,
                      iconColor: state.theme.focusColor,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          book.name,
                          style: state.textTheme.labelLarge,
                        ),
                      ),
                    ),
                    ViewMarks(
                      icon: LideaIcon.global,
                      iconColor: state.theme.focusColor,
                      iconSize: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          book.langCode.toUpperCase(),
                          style: state.textTheme.labelLarge,
                        ),
                      ),
                    ),
                    ViewMarks(
                      icon: Icons.compare_arrows,
                      iconColor: state.theme.focusColor,
                      iconSize: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          book.langDirection.toUpperCase(),
                          style: state.textTheme.labelLarge,
                        ),
                      ),
                    ),
                    ViewMarks(
                      icon: LideaIcon.dotTwo,
                      iconColor: state.theme.focusColor,
                      iconSize: 18,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          book.identify,
                          style: state.textTheme.labelLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // trailing: Text(book.),
            ),
            ViewMarks(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              label: message,
              show: message.isNotEmpty,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ViewButtons.filled(
                  margin: const EdgeInsets.only(bottom: 30),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  // borderRadius: const BorderRadius.all(Radius.circular(10)),
                  // color: isAvailable ? state.theme.primaryColorDark : state.theme.highlightColor,
                  color: isAvailable ? state.theme.colorScheme.error : state.theme.highlightColor,
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
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
                            color: state.theme.primaryColor,
                          ),
                        )
                      else
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Icon(
                            // isAvailable ? Icons.remove_circle : Icons.add_circle,
                            isAvailable ? LideaIcon.circleRemove : LideaIcon.circleAdd,
                            size: 29,
                            color: state.theme.primaryColor,
                          ),
                        ),
                      const Divider(
                        indent: 10,
                      ),
                      ViewLabels(
                        // constraints: const BoxConstraints(maxHeight: 30),
                        label:
                            isAvailable ? App.preference.text.delete : App.preference.text.download,
                        labelStyle: state.theme.textTheme.bodyLarge!.copyWith(
                          color: state.theme.primaryColor,
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
      const ViewDividers(),
      ViewFlats(
        child: ListBody(
          children: [
            ListTile(
              selected: true,
              iconColor: state.theme.iconTheme.color,
              selectedColor: state.theme.primaryColorDark,
              leading: const Icon(
                LideaIcon.circleAdd,
                // size: 25,
              ),
              titleAlignment: ListTileTitleAlignment.top,
              title: Paragraphs(
                text: App.preference.language('whenBibleDownload'),
                style: state.textTheme.titleLarge,
                decoration: [
                  TextSpan(
                    text: bookName,
                    semanticsLabel: 'bookName',
                    style: TextStyle(
                      color: state.theme.primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              selected: true,
              iconColor: state.theme.iconTheme.color,
              selectedColor: state.theme.primaryColorDark,
              leading: const Icon(
                LideaIcon.circleRemove,
                // size: 25,
              ),
              titleAlignment: ListTileTitleAlignment.top,
              title: Paragraphs(
                text: App.preference.language('whenBibleDelete'),
                style: state.textTheme.titleLarge,
                decoration: [
                  TextSpan(
                    text: bookName,
                    semanticsLabel: 'bookName',
                    style: TextStyle(
                      color: state.theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const ViewDividers(),
      ViewFlats(
        child: ListTile(
          leading: const Icon(
            LideaIcon.github,
            size: 23,
          ),
          titleAlignment: ListTileTitleAlignment.titleHeight,
          title: Paragraphs(
            text: App.preference.language('availableSource'),
            style: state.textTheme.titleLarge,
            decoration: [
              TextSpan(
                text: App.preference.text.holyBible,
                semanticsLabel: 'sourceBible',
                style: TextStyle(color: state.theme.highlightColor),
                recognizer: TapGestureRecognizer()..onTap = _launchBibleSource,
              ),
              TextSpan(
                text: 'app',
                semanticsLabel: 'sourceCode',
                style: TextStyle(color: state.theme.highlightColor),
                recognizer: TapGestureRecognizer()..onTap = _launchAppCode,
              ),
              TextSpan(
                text: App.preference.text.issue('true'),
                semanticsLabel: 'Issues',
                style: TextStyle(color: state.theme.highlightColor),
                recognizer: TapGestureRecognizer()..onTap = _launchAppIssues,
              ),
            ],
          ),
        ),
      ),
      ViewFlats(
        // padding: const EdgeInsets.symmetric(vertical: 30),
        child: ListBody(
          children: [
            note(icon: Icons.description_outlined, label: book.description),
            note(icon: Icons.copyright_outlined, label: book.copyright),
            note(icon: Icons.group_work_outlined, label: book.contributors),
            note(icon: LideaIcon.copyright, label: book.publisher),
          ],
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
      ),
    ];
  }

  Widget note({required String label, required IconData icon}) {
    if (label.isEmpty) {
      return const SizedBox();
    }
    return ListTile(
      leading: Icon(
        icon,
      ),

      title: Text(label),
      // textColor: state.textTheme.bodySmall?.color,
      textColor: state.textTheme.bodySmall?.color,
      titleTextStyle: state.textTheme.bodySmall,
      titleAlignment: ListTileTitleAlignment.titleHeight,
    );
  }
}
