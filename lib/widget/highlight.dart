import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class Highlight extends StatelessWidget {
  Highlight({
    Key? key,
    required this.str,
    required this.style,
    // required this.search
    this.search
  }): super(key: key);

  final String str;
  final TextStyle style;
  final void Function(String word)? search;

  final regExp = RegExp(r'\((.*?)\)|\[(.*?)\]',multiLine: true, dotAll: false, unicode: true);

  @override
  Widget build(BuildContext context) {
    final span = TextSpan(
      text: '\t',
      style:style,
      // style:style.copyWith(height: 1.7),
      children: []
    );
    str.splitMapJoin(regExp,
      onMatch: (Match match) {
        String none = match.group(0).toString();
        if (match.group(1) != null) {
          // (.*)
          span.children!.add(this.inParentheses(context, none));
        } else {
          // [.*]
          String matchString = match.group(2).toString();
          List<String> o = matchString.split(':');
          String name = o.first;
          String e = o.last;
          if (o.length == 2 && e.isNotEmpty) {
            List<String> href = e.split('/');
            if (name == 'list'){
              // [list:*]
              span.children!.add(
                TextSpan(
                  text: '',
                  children: this.asGesture(context, href)
                )
              );
            } else {
              // [*:*]
              span.children!.add(
                TextSpan(
                  text: "$name ",
                  style: TextStyle(
                    color: Colors.grey
                  ),
                  children: this.asGesture(context, href)
                )
              );
            }
          } else {
            span.children!.add(this.inBrackets(context, none));
          }
        }
        return '';
      },
      onNonMatch: (String nonMatch) {
        span.children!.add(TextSpan(text:nonMatch));
        return '';
      }
    );

    return SelectableText.rich(
      span,
      strutStyle: StrutStyle(
        height: style.height,
        forceStrutHeight: true
      ),
      key:this.key
    );

  }

  TextSpan inParentheses(BuildContext context, String term) => TextSpan(
    text: term,
    style: TextStyle(
      fontSize: (style.fontSize!-3).toDouble(),
      fontWeight: FontWeight.w400,
      // color: Theme.of(context).backgroundColor
    )
  );

  TextSpan inBrackets(BuildContext context, String term) => TextSpan(
    text: term,
    style: TextStyle(
      fontSize: (style.fontSize!-2).toDouble(),
      // fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w300,
      // color: Theme.of(context).backgroundColor.
    )
  );

  List<TextSpan> asGesture(BuildContext context, List<String> href){
    final abc = mapIndexed(href,
      (int index, String item, String comma) => TextSpan(
        text: "$item$comma",
        style: TextStyle(
          inherit: false,
          color: Colors.blue
        ),
        recognizer: TapGestureRecognizer()..onTap = () => (this.search != null)?this.search!(item):null
      )
    ).toList();

    return abc;
  }

  Iterable<E> mapIndexed<E, T>(Iterable<T> items, E Function(int index, T item, String last) f) sync* {
    int index = 0;
    int last = items.length - 1;

    for (final item in items) {
      yield f(index, item, last == index?'':', ');
      index = index + 1;
    }
  }
}