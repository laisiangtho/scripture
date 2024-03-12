import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:lidea/launcher.dart';
import 'package:lidea/icon.dart';

import '../../../app.dart';

// class _View extends _State with _Header {
// abstract class _State extends StateAbstract<Main> with SingleTickerProviderStateMixin {
class Main extends SheetsDraggable {
  const Main({super.key});

  static String route = 'sheet-bible';
  static String label = 'Bible';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends SheetsDraggableState<Main> {
  @override
  ViewData get viewData => App.viewData;

  late final BooksType book = state.as<BooksType>();

  bool isDownloading = false;
  String message = '';

  bool get isAvailable => book.available > 0;

  String get bookName => book.name;

  // @override
  // ScrollNotifier get notifier => App.scroll;

  // @override
  // bool get persistent => false;
  @override
  double get actualInitialSize => 0.6;
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
  List<Widget> slivers() {
    return <Widget>[
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        // padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 20],
        backgroundColor: Colors.transparent,
        overlapsBackgroundColor: state.theme.scaffoldBackgroundColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: (_, data) {
          return ViewHeaderLayoutStack(
            data: data,
            primary: ViewHeaderTitle(
              alignment: Alignment.lerp(
                const Alignment(0, 0),
                const Alignment(0, .5),
                data.snapShrink,
              ),
              // label: book.name,
              label: book.shortname,
            ),
            right: [
              ViewMark(
                padding: const EdgeInsets.only(right: 15),
                icon: Icons.verified_user_rounded,
                iconColor: state.theme.primaryColorDark,
                show: isAvailable,
              ),
            ],
          );
        },
      ),
      ViewFlatBuilder(
        child: ListBody(
          children: [
            ListTile(
              // leading: const Icon(Icons.lightbulb_outlined),
              // iconColor: Theme.of(context).primaryColorDark,
              // tileColor: Colors.red,
              // textColor: Colors.blueGrey,
              titleTextStyle: state.textTheme.bodyMedium,
              // visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Row(
                children: [
                  Expanded(
                    // child: Text(book.langName.toUpperCase()),
                    child: Text(
                      book.langName,
                    ),
                  ),
                  Text(
                    book.year.toString(),
                    style: state.textTheme.labelMedium,
                  ),
                ],
              ),
              // subtitle: Text(book.identify),
              // subtitle: Text(book.name),
              // subtitle: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(' - ${book.name}'),
              //     Text(' - ${book.langDirection}'),
              //     Text(' - ${book.langCode}'),
              //     Text(' - ${book.identify}'),
              //   ],
              // ),

              subtitle: ListView(
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 7),
                children: [
                  ListTile(
                    title: Text(book.name),
                    visualDensity: VisualDensity.comfortable,
                    dense: true,
                    leading: const Icon(
                      LideaIcon.info,
                      size: 16,
                    ),
                    titleTextStyle: state.textTheme.labelMedium,
                  ),
                  ListTile(
                    title: Text(book.langDirection),
                    visualDensity: VisualDensity.comfortable,
                    dense: true,
                    leading: const Icon(
                      LideaIcon.info,
                      size: 16,
                    ),
                    titleTextStyle: state.textTheme.labelMedium,
                  ),
                  ListTile(
                    title: Text(book.langCode),
                    visualDensity: VisualDensity.comfortable,
                    dense: true,
                    leading: const Icon(
                      LideaIcon.info,
                      size: 16,
                    ),
                    titleTextStyle: state.textTheme.labelMedium,
                  ),
                  ListTile(
                    title: Text(book.identify),
                    visualDensity: VisualDensity.comfortable,
                    dense: true,
                    leading: const Icon(
                      LideaIcon.info,
                      size: 16,
                    ),
                    titleTextStyle: state.textTheme.labelMedium,
                  )
                ],
              ),
              // trailing: Text(book.),
            ),
            ViewMark(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              label: message,
              show: message.isNotEmpty,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ViewButton.filled(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
                  // borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: isAvailable ? state.theme.primaryColorDark : state.theme.highlightColor,
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
                            isAvailable ? Icons.remove_circle : Icons.add_circle,
                            size: 29,
                            color: state.theme.primaryColor,
                          ),
                        ),
                      const Divider(
                        indent: 10,
                      ),
                      ViewLabel(
                        // constraints: const BoxConstraints(maxHeight: 30),
                        label:
                            isAvailable ? App.preference.text.delete : App.preference.text.download,
                        labelStyle: state.theme.textTheme.bodyLarge!.copyWith(
                          color: state.theme.primaryColor,
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
      const ViewSectionDivider(),
      ViewFlatBuilder(
        child: ListBody(
          children: [
            ListTile(
              selected: isAvailable,
              iconColor: state.theme.iconTheme.color,
              selectedColor: state.theme.primaryColorDark,
              leading: const Icon(Icons.add_circle),
              // title: Text(preference.language('byBibleDownload')),
              title: _actionHelpLabel('byBibleDownload'),
            ),
            ListTile(
              selected: !isAvailable,
              iconColor: state.theme.iconTheme.color,
              selectedColor: state.theme.primaryColorDark,
              leading: const Icon(Icons.remove_circle),
              title: _actionHelpLabel('byBibleDelete'),
            ),
          ],
        ),
      ),
      const ViewSectionDivider(),
      ViewFlatBuilder(
        child: ListTile(
          leading: const Icon(LideaIcon.github),
          title: Text.rich(
            TextSpan(
              text: App.preference.language('RepositoryGithub'),
              style: state.textTheme.bodySmall,
              children: [
                const TextSpan(text: ' '),
                TextSpan(
                  text: App.preference.language('ofBibleSource'),
                  style: TextStyle(color: state.theme.highlightColor),
                  recognizer: TapGestureRecognizer()..onTap = _launchBibleSource,
                ),
                const TextSpan(text: ', '),
                TextSpan(
                  text: App.preference.language('ofAppSourcecode'),
                  style: TextStyle(color: state.theme.highlightColor),
                  recognizer: TapGestureRecognizer()..onTap = _launchAppCode,
                ),
                const TextSpan(text: ' / '),
                TextSpan(
                  text: App.preference.language('issues that need to be fixed'),
                  style: TextStyle(color: state.theme.highlightColor),
                  recognizer: TapGestureRecognizer()..onTap = _launchAppIssues,
                ),
                const TextSpan(text: '..'),
              ],
            ),
          ),
        ),
      ),
      ViewFlatBuilder(
        child: ListBody(
          children: [
            note(icon: Icons.description_outlined, label: book.description),
            note(icon: Icons.copyright_outlined, label: book.copyright),
            note(icon: Icons.group_work_outlined, label: book.contributors),
            note(icon: Icons.check_circle_outlined, label: book.publisher),
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
      leading: Icon(icon),
      iconColor: Theme.of(context).primaryColorDark,
      title: Text(label),
      // textColor: state.textTheme.bodySmall?.color,
      textColor: state.textTheme.bodySmall?.color,
      titleTextStyle: state.textTheme.bodySmall,
    );
  }

  Widget _actionHelpLabel(String text) {
    // preference.text.delete : preference.text.download,
    final label = App.preference
        .language(text)
        .replaceAll('label.download', App.preference.text.download)
        .replaceAll('label.delete', App.preference.text.delete)
        .replaceAll('book.name', bookName);

    return Text(label, style: state.textTheme.bodyMedium);
  }
}
