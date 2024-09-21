part of 'main.dart';

class VerseWidgetInherited extends InheritedWidget {
  final int verseId;

  final double? size;

  final Scripture scripture;

  final bool marks;
  // final bool note;

  // bool get isUTF8 => lang == 'mya';
  // double get fontHeight => this.isUTF8?1.3:1.2;
  // double get fontHeight => isUTF8 ? 1.3 : 1.2;
  // double? get fontSize => isUTF8 ? size! - 1.5 : size;
  double? get fontSize => size;
  double? get titleSize => (fontSize! - 5).toDouble();

  bool get selected {
    if (marks) {
      return scripture.marks.hasSelected(verseId);
    }
    return false;
  }

  String get lang {
    return scripture.info.langCode;
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
    required this.scripture,
    this.marks = false,
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
  Preference get preference => App.core.preference;

  // String get bookName => primaryScripture.bookName;
  // String get chapterName => primaryScripture.chapterName;

  @override
  Widget build(BuildContext context) {
    final userVerse = VerseWidgetInherited.of(context)!;
    final hasMarks = userVerse.marks;
    final scripture = userVerse.scripture;
    final marks = scripture.marks;

    final tpl = Theme.of(context);

    // userVerse.scripture.marks.verseBackground(verse.id);
    // final verseNote = userVerse.marks?.verseNote(verse.id);
    final verseNote = hasMarks ? marks.verseNote(verse.id) : null;
    final verseBackground = hasMarks ? marks.verseBackground(verse.id) : null;

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
              style: tpl.textTheme.bodySmall?.copyWith(
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
                        // text: verse.name,
                        text: scripture.digit(verse.id),
                        semanticsLabel: 'verse: ${verse.name}',
                      ),
                      if (verse.merge.isNotEmpty)
                        TextSpan(
                          text: '-',
                          children: [
                            TextSpan(
                              text: scripture.digit(verse.merge),
                            ),
                          ],
                        ),
                    ],
                    // style: tpl.textTheme.labelMedium?.copyWith(
                    //       color: tpl.hintColor,
                    //       fontSize: userVerse.titleSize,
                    //       fontWeight: FontWeight.w300,
                    //     ),
                    style: TextStyle(
                      color: tpl.hintColor,
                      fontSize: userVerse.titleSize,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  TextSpan(
                    text: ' ',
                    children: highLight(
                      context: context,
                      text: verse.text,
                    ),
                    semanticsLabel: verse.text,
                    style: TextStyle(
                      color: userVerse.selected ? tpl.primaryColorDark.withOpacity(0.6) : null,
                      decoration: userVerse.selected ? TextDecoration.underline : null,

                      background: verseBackground,

                      decorationStyle: TextDecorationStyle.wavy,
                      // decorationThickness: 2,
                      // decorationColor: tpl.colorScheme.error,
                      decorationColor: tpl.primaryColorDark,
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
                        // color: tpl.hintColor.withOpacity(0.3),
                        color: tpl.focusColor,
                        onPressed: () {
                          final msh = App.core.route.showModalSheet<Map<String, dynamic>?>(
                            child: App.core.route.sheetConfig(
                              name: '/recto-editor',
                              extra: {
                                'text': verseNote,
                                // 'focus': true,
                                'pageLabel': preference.lang(context).addTo(
                                      preference.lang(context).note('').toLowerCase(),
                                    ),
                                // 'pageTitle': '$bookName $chapterName:${verse.id}',
                                'pageTitle':
                                    '${scripture.bookName} ${scripture.chapterName}:${verse.id}',
                              },
                            ),
                          );

                          msh.then((e) {
                            if (e != null) {
                              if (hasMarks) {
                                marks.selectionApply(note: e['text'], verses: [verse.id]);
                              }
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
              style: tpl.textTheme.bodyMedium?.copyWith(
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

  /// [quoted] Joined quoted in multi verses
  List<TextSpan> highLight({required BuildContext context, required String text}) {
    ThemeData tpl = Theme.of(context);
    ColorScheme scheme = tpl.colorScheme;

    Color? quoteTextColor = tpl.colorScheme.primary.lerp(scheme.error, 1);
    Color? quoteMarkColor = tpl.colorScheme.primary.lerp(tpl.dividerColor, 1.0);

    List<TextSpan> spans = [];
    int start = 0;
    bool quoted = false;
    String? word = keyword;
    if (word == null || word.length < 2) {
      // RegExp regExp = RegExp('(["\'“‘]?)([^“”‘’"\']*)(["\'”’]?)');
      // RegExp regExp = RegExp('(["“‘]?)([^“”‘’"]*)(["”’]?)');
      RegExp regExp = RegExp('(["“]?)([^“”"]*)(["”]?)');
      // RegExp regExp = RegExp('(["“]?)([^“”‘’"]*?)(["”]?)');

      for (RegExpMatch match in regExp.allMatches(text)) {
        if (match.start > start) {
          spans.add(TextSpan(
            text: text.substring(start, match.start),
          ));
        }

        String openingQuote = match.group(1) ?? '';
        String content = match.group(2) ?? '';
        String closingQuote = match.group(3) ?? '';

        if (openingQuote.isNotEmpty) {
          quoted = true;
          spans.add(TextSpan(
            text: openingQuote,
            style: TextStyle(color: quoteMarkColor),
          ));
        }

        if (openingQuote.isNotEmpty && closingQuote.isEmpty) {
          // Unmatched opening quote
          spans.add(TextSpan(
            text: content.trim(),
            style: TextStyle(color: quoteTextColor),
          ));
        } else if (openingQuote.isEmpty && closingQuote.isNotEmpty) {
          // Unmatched closing quote
          spans.add(TextSpan(
            text: content.trim(),
            style: TextStyle(color: quoteTextColor),
          ));
          quoted = false;
        } else if (openingQuote.isNotEmpty && closingQuote.isNotEmpty) {
          // Properly matched quotes
          // Matched both opening and closing quote

          spans.add(TextSpan(
            text: content.trim(),
            // text: openingQuote + content + closingQuote,
            style: TextStyle(color: quoteTextColor),
          ));
          quoted = false;
        } else {
          // Regular text

          spans.add(TextSpan(
            text: match.group(0),
            // style: const TextStyle(color: Colors.yellow),
            style: quoted ? TextStyle(color: quoteTextColor) : null,
          ));
        }

        if (closingQuote.isNotEmpty) {
          quoted = false;
          spans.add(TextSpan(
            text: closingQuote,
            style: TextStyle(color: quoteMarkColor),
          ));
        }

        start = match.end;
        // hasVerseQuoted = false;
      }

      if (start < text.length) {
        quoted = false;
        spans.add(TextSpan(
          text: text.substring(start),
          // style: hasVerseQuoted ? TextStyle(color: quoteTextColor) : null,
        ));
      }
    } else {
      do {
        // look for the next match
        final startIndex = text.toLowerCase().indexOf(word.toLowerCase(), start);
        // final startIndex = text.toLowerCase().indexOf(matchWord, start);
        // if no more matches then add the rest of the string without style
        if (startIndex == -1) {
          spans.add(TextSpan(text: text.substring(start)));
          return spans;
        }
        // add any unstyled text before the next match
        if (startIndex > start) {
          spans.add(TextSpan(text: text.substring(start, startIndex)));
        }
        // style the matched text
        final endIndex = startIndex + word.length;
        final spanText = text.substring(startIndex, endIndex);
        spans.add(TextSpan(
          text: spanText,
          style: TextStyle(
            color: tpl.highlightColor,
          ),
        ));
        // mark the boundary to start the next search from
        start = endIndex;
        // continue until there are no more matches
      } while (start < text.length);
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
    final tpl = Theme.of(context);
    return ViewCards(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: tpl.disabledColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            Container(
              height: 15,
              width: 250,
              decoration: BoxDecoration(
                color: tpl.disabledColor,
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
                color: tpl.disabledColor,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
