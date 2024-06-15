import 'package:flutter/material.dart';

import '../app.dart';

class VerseWidgetInherited extends InheritedWidget {
  final int verseId;
  // final Color? color;
  final double? size;
  final String? lang;
  // final bool selected;
  final Marks? marks;
  // final bool note;

  // bool get isUTF8 => lang == 'mya';
  // double get fontHeight => this.isUTF8?1.3:1.2;
  // double get fontHeight => isUTF8 ? 1.3 : 1.2;
  // double? get fontSize => isUTF8 ? size! - 1.5 : size;
  double? get fontSize => size;
  double? get titleSize => (fontSize! - 5).toDouble();

  bool get selected {
    if (marks != null) {
      return marks!.hasSelected(verseId);
    }
    return false;
  }

  // List<Color> get colorList => const [Colors.red, Colors.blue, Colors.green, Colors.orange];

  // void background() {
  //   if (marks != null) {
  //     if (marks!.isNotEmpty) {
  //       final ves = marks!.first.verse;
  //     }
  //   }
  //   Paint()..color = Colors.orange.withOpacity(0.1);
  // }

  const VerseWidgetInherited({
    super.key,
    this.size,
    this.lang,
    this.marks,
    // this.selected = false,
    // this.note = false,
    required this.verseId,
    required super.child,
  });

  static VerseWidgetInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VerseWidgetInherited>();
  }

  @override
  bool updateShouldNotify(VerseWidgetInherited oldWidget) {
    return size != oldWidget.size ||
        // color != oldWidget.color ||
        selected != oldWidget.selected ||
        marks != oldWidget.marks;
  }
}

// VerseItem VerseItemHolder VerseItemSnap VerseItemWidget
class VerseItemWidget extends StatelessWidget {
  final OfVerse verse;
  final String? keyword;
  final String? alsoInVerse;

  final void Function(int)? onPressed;

  const VerseItemWidget({
    super.key,
    required this.verse,
    this.keyword,
    this.onPressed,
    this.alsoInVerse,
  });

  Scripture get primaryScripture => App.core.scripturePrimary;
  Preference get preference => App.preference;

  String get bookName => primaryScripture.bookName;
  String get chapterName => primaryScripture.chapterName;

  @override
  Widget build(BuildContext context) {
    final userVerse = VerseWidgetInherited.of(context)!;
    final verseNote = userVerse.marks?.verseNote(verse.id);

    return ListBody(
      key: key,
      children: <Widget>[
        if (verse.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Text(
              verse.title.toUpperCase(),
              textAlign: TextAlign.center,
              semanticsLabel: verse.title,
              textDirection: TextDirection.ltr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: userVerse.titleSize,
                    fontWeight: FontWeight.w300,
                  ),
            ),
          ),
        ViewCards(
          margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: verse.name,
                        semanticsLabel: 'verse: ${verse.name}',
                      ),
                      if (verse.merge.isNotEmpty)
                        TextSpan(
                          text: '-',
                          children: [
                            TextSpan(
                              text: primaryScripture.digit(verse.merge),
                            ),
                          ],
                        ),
                    ],
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                          fontSize: userVerse.titleSize,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  TextSpan(
                    text: ' ',
                    children: hightLight(
                      verse.text,
                      keyword,
                      TextStyle(
                        color: Theme.of(context).highlightColor,
                      ),
                      // const TextStyle(
                      //   color: Colors.red,
                      // ),
                    ),
                    semanticsLabel: verse.text,
                    style: TextStyle(
                      color: userVerse.selected
                          ? Theme.of(context).primaryColorDark.withOpacity(0.6)
                          : null,
                      decoration: userVerse.selected ? TextDecoration.underline : null,
                      background: userVerse.marks?.verseBackground(verse.id),

                      decorationStyle: TextDecorationStyle.wavy,
                      // decorationThickness: 2,
                      // decorationColor: Theme.of(context).colorScheme.error,
                      decorationColor: Theme.of(context).primaryColorDark,
                    ),
                  ),

                  if (verse.reference.isNotEmpty)
                    TextSpan(
                      text: verse.reference,
                    ),
                  if (verseNote != null)
                    WidgetSpan(
                      child: IconButton(
                        tooltip: verseNote,
                        alignment: Alignment.center,
                        style: TextButton.styleFrom(
                          // padding: const EdgeInsets.only(left: 5),
                          minimumSize: const Size(30, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center,
                        ),
                        // color: Theme.of(context).hintColor.withOpacity(0.3),
                        color: Theme.of(context).focusColor,
                        onPressed: () {
                          App.route.showSheetModal(
                            context: context,
                            name: 'sheet-bible-navigation/leaf-editor',
                            arguments: {
                              'text': verseNote,
                              // 'focus': true,
                              'pageLabel':
                                  preference.text.addTo(preference.text.note('').toLowerCase()),

                              'pageTitle': '$bookName $chapterName:${verse.id}',
                            },
                          ).then((e) {
                            debugPrint('marks: note $e');
                            if (e != null) {
                              userVerse.marks?.selectionApply(note: e['text'], verses: [verse.id]);
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.chat_bubble,
                          size: 17,
                        ),
                      ),
                    ),

                  if (alsoInVerse != null && alsoInVerse!.isNotEmpty)
                    TextSpan(
                      text: '\t ...$alsoInVerse',
                      style: TextStyle(
                        // color: Colors.grey,
                        fontSize: userVerse.titleSize,
                        fontWeight: FontWeight.w300,
                      ),
                      // textAlign: TextAlign.right,
                    ),

                  // if (userVerse.marks.)
                ],
              ),
              scrollPhysics: const NeverScrollableScrollPhysics(),
              textDirection: TextDirection.ltr,
              // style: TextStyle(
              //   // color: Colors.black,
              //   fontWeight: FontWeight.w400,
              //   fontSize: userVerse.fontSize,
              //   // height: userVerse.fontHeight,
              // ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: userVerse.fontSize,
                  ),
              onTap: onPressed == null ? null : () => onPressed!(verse.id),
            ),
          ),
        ),
      ],
    );
  }

  List<TextSpan> hightLight(String text, String? matchWord, TextStyle style) {
    // final style = TextStyle(color: Colors.red, fontSize: 22);
    // children: hightLight(verse['text'], store.searchQuery, style),
    List<TextSpan> spans = [];
    if (matchWord == null || matchWord.length < 2) {
      spans.add(TextSpan(text: text, semanticsLabel: text));
    } else {
      int spanBoundary = 0;
      do {
        // look for the next match
        final startIndex = text.toLowerCase().indexOf(matchWord.toLowerCase(), spanBoundary);
        // final startIndex = text.toLowerCase().indexOf(matchWord, spanBoundary);
        // if no more matches then add the rest of the string without style
        if (startIndex == -1) {
          spans.add(TextSpan(text: text.substring(spanBoundary)));
          return spans;
        }
        // add any unstyled text before the next match
        if (startIndex > spanBoundary) {
          spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
        }
        // style the matched text
        final endIndex = startIndex + matchWord.length;
        final spanText = text.substring(startIndex, endIndex);
        spans.add(TextSpan(text: spanText, style: style));
        // mark the boundary to start the next search from
        spanBoundary = endIndex;
        // continue until there are no more matches
      } while (spanBoundary < text.length);
    }
    return spans;
  }

  // void abcdef() {
  //   final myString = "abcdText('hello') {{abc}}abcd efghText('world') {{orange}}";

  //   RegExp exp = RegExp(r"{{.*?}}");
  //   final org = exp.allMatches(myString);

  //   for (var element in org) {
  //     element.
  //     print(element[1].toString());
  //   }
  // }
}

class VerseItemSnap extends StatelessWidget {
  const VerseItemSnap({super.key});
  @override
  Widget build(BuildContext context) {
    return ViewCards(
      // color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              // width: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              // color: Colors.grey[200],
            ),
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            Container(
              height: 15,
              width: 250,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                borderRadius: const BorderRadius.all(Radius.circular(7)),
              ),
            ),
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            Container(
              height: 10,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
