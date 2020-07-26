part of 'main.dart';

// class ChapterInheritedNotifier extends InheritedNotifier<ValueNotifier<BIBLE>> {
//   ChapterInheritedNotifier({
//     Key key,
//     ValueNotifier<BIBLE> notifier,
//     ValueChanged<BIBLE> update,
//     Widget child,
//   }) : super(key: key, notifier: notifier, child: child);

//   // static BIBLE of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ChapterInheritedNotifier>().notifier.value;

//   @override
//   bool updateShouldNotify(ChapterInheritedNotifier old) => notifier.value != old.notifier.value;
// }