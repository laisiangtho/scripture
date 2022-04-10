part of ui.widget;

class VerseWidgetInherited extends InheritedWidget {
  final Color? fontColor;
  final double? size;
  final String? lang;
  final bool selected;

  bool get isUTF8 => lang == 'my';
  // double get fontHeight => this.isUTF8?1.3:1.2;
  // double get fontHeight => isUTF8 ? 1.3 : 1.2;
  // double? get fontSize => isUTF8 ? size! - 1.5 : size;
  double? get fontSize => size;
  double? get titleSize => (fontSize! - 3).toDouble();

  const VerseWidgetInherited({
    Key? key,
    this.fontColor,
    this.size,
    this.lang,
    this.selected = false,
    required Widget child,
  }) : super(key: key, child: child);

  static VerseWidgetInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VerseWidgetInherited>();
  }

  @override
  bool updateShouldNotify(VerseWidgetInherited oldWidget) {
    return size != oldWidget.size ||
        fontColor != oldWidget.fontColor ||
        selected != oldWidget.selected;
  }
}

class WidgetVerse extends StatelessWidget {
  final VERSE verse;
  final String? keyword;
  final String? alsoInVerse;

  final void Function(int)? onPressed;
  // final ValueChanged<Map<String,dynamic>> onChange;

  const WidgetVerse({
    Key? key,
    required this.verse,
    this.keyword,
    this.onPressed,
    this.alsoInVerse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userVerse = VerseWidgetInherited.of(context)!;

    return Column(
      key: key,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        if (verse.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Text(
              verse.title.toUpperCase(),
              textAlign: TextAlign.center,
              semanticsLabel: verse.title,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.black54,
                fontSize: userVerse.titleSize,
                fontWeight: FontWeight.w300,
                // height: 1.6,
              ),
            ),
          ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          // elevation: 0,
          // shape: const RoundedRectangleBorder(
          //   side: BorderSide(width: 0, color: Colors.transparent),
          //   borderRadius: BorderRadius.zero,
          // ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SelectableText.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: verse.name,
                        semanticsLabel: 'verse: ' + verse.name,
                      ),
                      if (verse.merge.isNotEmpty)
                        TextSpan(
                          text: '-' + verse.merge,
                        ),
                    ],
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: userVerse.titleSize,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text: '\t',
                    children: hightLight(
                      verse.text,
                      keyword,
                      const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    semanticsLabel: verse.text,
                    style: TextStyle(
                      color: userVerse.selected ? Colors.red : null,
                    ),
                  ),
                  if (alsoInVerse != null && alsoInVerse!.isNotEmpty)
                    TextSpan(
                      text: '\t ...$alsoInVerse',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: userVerse.titleSize,
                        fontWeight: FontWeight.w300,
                      ),
                      // textAlign: TextAlign.right,
                    ),
                ],
              ),
              scrollPhysics: const NeverScrollableScrollPhysics(),
              textDirection: TextDirection.ltr,
              style: TextStyle(
                // color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: userVerse.fontSize,
                // height: userVerse.fontHeight,
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
}

class VerseWidgetHolder extends StatelessWidget {
  const VerseWidgetHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 15,
              // width: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ),
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            Container(
              height: 15,
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
