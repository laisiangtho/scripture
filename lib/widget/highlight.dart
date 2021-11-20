import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class Highlight extends StatelessWidget {
  Highlight({
    Key? key,
    required this.str,
    required this.style,
    required this.search,
  }) : super(key: key);

  final String str;
  final TextStyle style;
  final void Function(String word) search;

  final regExp = RegExp(r'\((.*?)\)|\[(.*?)\]', multiLine: true, dotAll: false, unicode: true);

  @override
  Widget build(BuildContext context) {
    final span = TextSpan(
      style: style,
      // style:style.copyWith(height: 1.7),
      children: const [],
    );
    str.splitMapJoin(
      regExp,
      onMatch: (Match match) {
        String none = match.group(0).toString();
        if (match.group(1) != null) {
          // (.*)
          span.children!.add(inParentheses(context, none));
        } else {
          // [.*]
          String matchString = match.group(2).toString();
          List<String> o = matchString.split(':');
          String name = o.first;
          String e = o.last;
          if (o.length == 2 && e.isNotEmpty) {
            List<String> href = e.split('/');
            if (name == 'list') {
              // [list:*]
              span.children!.add(TextSpan(
                text: '',
                children: asGesture(context, href),
              ));
            } else {
              // [*:*]
              span.children!.add(TextSpan(
                  text: "$name ",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                  children: asGesture(context, href)));
            }
          } else {
            span.children!.add(inBrackets(context, none));
          }
        }
        return '';
      },
      onNonMatch: (String nonMatch) {
        span.children!.add(TextSpan(
          text: nonMatch,
        ));
        return '';
      },
    );

    return SelectableText.rich(
      span,
      key: key,
      strutStyle: const StrutStyle(
        forceStrutHeight: true,
      ),
    );
  }

  TextSpan inParentheses(BuildContext context, String term) => TextSpan(
        text: term,
        style: TextStyle(
          fontSize: (style.fontSize! - 3).toDouble(),
          fontWeight: FontWeight.w400,
          // color: Theme.of(context).backgroundColor,
        ),
      );

  TextSpan inBrackets(BuildContext context, String term) {
    return TextSpan(
      text: term,
      style: TextStyle(
        fontSize: (style.fontSize! - 2).toDouble(),
        // fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w300,
        // color: Theme.of(context).backgroundColor,
      ),
    );
  }

  List<TextSpan> asGesture(BuildContext context, List<String> href) {
    return mapIndexed(
      href,
      (int index, String item, String comma) => TextSpan(
        text: "$item$comma",
        style: const TextStyle(
          inherit: false,
          color: Colors.blue,
        ),
        recognizer: TapGestureRecognizer()..onTap = () => search(item),
      ),
    ).toList();
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item, String last) f) sync* {
    int index = 0;
    int last = items.length - 1;

    for (final item in items) {
      yield f(index, item, last == index ? '' : ', ');
      index = index + 1;
    }
  }
}
