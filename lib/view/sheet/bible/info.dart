import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:lidea/launcher.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/hive.dart';

import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _State();
}

class _State extends SheetStates<Main> {
  late final boxOfBooks = app.data.boxOfBooks;

  // late final MapEntry<dynamic, BooksType> item = state.param.as<MapEntry<dynamic, BooksType>>();
  late final BooksType book = state.param.as<BooksType>();

  bool isDownloading = false;
  String message = '';

  // BooksType get book => item;
  // BooksType get book => boxOfBooks.box.values
  //     .firstWhere((e) => e.identify == item.value.identify, orElse: () => boxOfBooks.values.first);

  int get bookIndex => boxOfBooks.indexOfvalues((e) => e.identify == book.identify);

  /// if book.available > 0 or params.identify is empty
  bool get isAvailable => book.identify.isEmpty || book.available > 0;

  String get bookName => book.name;

  @override
  late final actualInitialSize = 0.5;

  @override
  late final actualMinSize = 0.3;

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
    analytics.content(isAvailable ? 'Delete' : 'Download', book.identify);
    setState(() {
      isDownloading = !isDownloading;
    });
    app.switchAvailabilityUpdate(book.identify).then((_) {
      setState(() {
        isDownloading = !isDownloading;
        message = 'finish';
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        // Navigator.pop(context, 'done');
        if (mounted) Navigator.of(context).maybePop();
      });
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
        heights: const [kTextTabBarHeight],
        // heights: const [kTextTabBarHeight, kToolbarHeight],
        backgroundColor: theme.primaryColor,
        // backgroundColor: Colors.transparent,
        // padding: state.media.viewPadding,
        // overlapsBackgroundColor: theme.scaffoldBackgroundColor,
        // overlapsBorderColor: Theme.of(context).shadowColor,
        overlapsBorderColor: theme.dividerColor,
        builder: (_, vhd) {
          return ViewHeaderLayouts(
            data: vhd,
            left: [
              OptionButtons.cancel(
                label: app.preference.of(context).cancel,
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
              //   iconColor: theme.primaryColorDark,
              //   show: isAvailable,
              // ),
              ValueListenableBuilder(
                valueListenable: boxOfBooks.listen(),
                builder: (BuildContext _, Box<BooksType> __, Widget? ___) {
                  return ViewButtons(
                    message: app.preference.of(context).favorite('false'),
                    child: ViewMarks(
                      icon: isAvailable ? Icons.favorite : Icons.favorite_border_outlined,
                      iconColor: book.selected ? theme.highlightColor : theme.primaryColorDark,
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
              titleTextStyle: style.labelSmall,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  textDirection: TextDirection.ltr,
                  spacing: 15,
                  runSpacing: 0,
                  children: [
                    Chip(
                      side: const BorderSide(style: BorderStyle.none),
                      avatar: Icon(
                        LideaIcon.bible,
                        color: theme.focusColor,
                      ),
                      label: Text(book.name),
                    ),
                    Chip(
                      side: const BorderSide(style: BorderStyle.none),
                      avatar: Icon(
                        LideaIcon.global,
                        color: theme.focusColor,
                      ),
                      label: Paragraphs(
                        text: '{{langCode}} {{langName}}',
                        style: style.labelMedium,
                        decoration: [
                          TextSpan(
                            text: book.langCode.toUpperCase(),
                            semanticsLabel: 'langCode',
                          ),
                          TextSpan(
                            text: '(${book.langName})',
                            semanticsLabel: 'langName',
                            style: TextStyle(color: theme.primaryColorDark),
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      side: const BorderSide(style: BorderStyle.none),
                      avatar: Icon(
                        Icons.compare_arrows,
                        color: theme.focusColor,
                      ),
                      label: Text(
                        book.langDirection.toUpperCase(),
                      ),
                    ),
                    Chip(
                      side: const BorderSide(style: BorderStyle.none),
                      avatar: Icon(
                        Icons.timeline_outlined,
                        color: theme.focusColor,
                      ),
                      label: Text(book.year.toString()),
                    ),
                  ],
                ),
              ),
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
                  // color: isAvailable ? theme.primaryColorDark : theme.highlightColor,
                  color: isAvailable ? colorScheme.error : theme.highlightColor,
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
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
                            // isAvailable ? Icons.remove_circle : Icons.add_circle,
                            isAvailable ? LideaIcon.circleRemove : LideaIcon.circleAdd,
                            size: 29,
                            color: theme.primaryColor,
                          ),
                        ),
                      const Divider(
                        indent: 10,
                      ),
                      ViewLabels(
                        // constraints: const BoxConstraints(maxHeight: 30),
                        label: isAvailable
                            ? app.preference.of(context).delete
                            : app.preference.of(context).download,
                        labelStyle: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.primaryColor,
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
              iconColor: theme.iconTheme.color,
              selectedColor: theme.primaryColorDark,
              leading: const Icon(
                LideaIcon.circleAdd,
                // size: 25,
              ),
              titleAlignment: ListTileTitleAlignment.top,
              title: Paragraphs(
                text: preference.language('whenBibleDownload'),
                style: style.bodyLarge,
                decoration: [
                  TextSpan(
                    text: bookName,
                    semanticsLabel: 'bookName',
                    style: TextStyle(
                      color: theme.primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              selected: true,
              iconColor: theme.iconTheme.color,
              selectedColor: theme.primaryColorDark,
              leading: const Icon(
                LideaIcon.circleRemove,
                // size: 25,
              ),
              titleAlignment: ListTileTitleAlignment.top,
              title: Paragraphs(
                text: preference.language('whenBibleDelete'),
                style: style.bodyLarge,
                decoration: [
                  TextSpan(
                    text: bookName,
                    semanticsLabel: 'bookName',
                    style: TextStyle(
                      color: theme.hintColor,
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
            text: preference.language('availableSource'),
            style: style.bodyLarge,
            decoration: [
              TextSpan(
                text: app.preference.of(context).holyBible,
                semanticsLabel: 'sourceBible',
                style: TextStyle(color: theme.highlightColor),
                recognizer: TapGestureRecognizer()..onTap = _launchBibleSource,
              ),
              TextSpan(
                text: 'app',
                semanticsLabel: 'sourceCode',
                style: TextStyle(color: theme.highlightColor),
                recognizer: TapGestureRecognizer()..onTap = _launchAppCode,
              ),
              TextSpan(
                text: app.preference.of(context).issue('true'),
                semanticsLabel: 'Issues',
                style: TextStyle(color: theme.highlightColor),
                recognizer: TapGestureRecognizer()..onTap = _launchAppIssues,
              ),
            ],
          ),
        ),
      ),
      ViewFlats(
        child: ListBody(
          children: [
            note(icon: Icons.description_outlined, label: book.description),
            note(icon: Icons.copyright_outlined, label: book.copyright),
            note(icon: Icons.group_work_outlined, label: book.contributors),
            note(icon: LideaIcon.copyright, label: book.publisher),
            note(icon: Icons.info_outline_rounded, label: book.identify),
          ],
        ),
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
      // textColor: style.bodySmall?.color,
      // textColor: style.bodySmall?.color,
      titleTextStyle: style.bodyMedium,
      titleAlignment: ListTileTitleAlignment.titleHeight,
    );
  }
}
