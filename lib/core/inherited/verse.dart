part of 'main.dart';

class VerseInheritedWidget extends InheritedWidget {
  final Color fontColor;
  final double size;
  final String lang;
  final bool selected;

  bool get isUTF8 => lang == 'my';
  // double get fontHeight => this.isUTF8?1.3:1.2;
  double get fontHeight => this.isUTF8?1.3:1.2;
  double get fontSize => this.isUTF8?size-1.5:size;
  double get titleSize => (this.fontSize-3).toDouble();

  const VerseInheritedWidget({
    Key key,
    this.fontColor,
    this.size,
    this.lang,
    this.selected:false,
    Widget child,
  }) : super(key: key, child: child);

  static VerseInheritedWidget of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<VerseInheritedWidget>();

  @override
  bool updateShouldNotify(VerseInheritedWidget old) => size != old.size || fontColor != old.fontColor || selected != old.selected;
}