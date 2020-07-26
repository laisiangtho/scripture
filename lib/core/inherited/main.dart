import 'package:flutter/material.dart';
// import 'package:bible/model.dart';

part 'chapter.dart';
part 'verse.dart';

// class BibleIdInheritedNotifier extends InheritedNotifier<ValueNotifier<String>> {
//   BibleIdInheritedNotifier({
//     Key key,
//     ValueNotifier<String> identify,
//     Widget child,
//   }) : super(key: key, notifier: identify,child: child);

//   static String of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BibleIdInheritedNotifier>().notifier.value;
// }

// class BibleIdInherited extends InheritedWidget {
//   final String identify;
//   final int bookId;
//   final int chapterId;
//   final ValueChanged<Map<String,dynamic>> onChange;

//   BibleIdInherited({
//     Key key,
//     this.identify,
//     this.bookId,
//     this.chapterId,
//     this.onChange,
//     Widget child,
//   }) : super(key: key,child: child);

//   static BibleIdInherited of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BibleIdInherited>();

//   @override
//   bool updateShouldNotify(BibleIdInherited old) => identify != old.identify || bookId != old.bookId || chapterId != old.chapterId;
// }

// BibleIdInheritedNotifier

// class BibleIdentify extends InheritedWidget {
//   final String id;
//   // final int chapterId;
//   // final ValueChanged<NAME> name;
//   // final ValueNotifier<NAME> name;

//   BibleIdentify({
//     Key key,
//     this.id,
//     Widget child,
//   }) : super(key: key, child: child);

//   @override
//   bool updateShouldNotify(BibleIdentify e) => e.id != id;

//   static BibleIdentify of(BuildContext context) {
//     return InheritedModel.inheritFrom(context);
//   }
// }
// ChapterInheritedNotifier

// class NameInheritedNotifier extends InheritedNotifier<ValueNotifier<NAME>> {

//   NameInheritedNotifier({
//     Key key,
//     ValueNotifier<NAME> notifier,
//     ValueChanged<NAME> update,
//     Widget child,
//   }) : super(key: key, notifier: notifier, child: child);

//   static NAME of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<NameInheritedNotifier>().notifier.value;
// }

// class TestInheritedNotifier extends InheritedNotifier<ValueNotifier<NAME>> {
//   // final ValueNotifier<NAME> update;

//   TestInheritedNotifier({
//     Key key,
//     ValueNotifier<NAME> notifier,
//     // ValueChanged<NAME> update,
//     Widget child,
//   }) : super(key: key, notifier: notifier,child: child);

//   // void update(NAME name) {
//   //   this.notifier.value = name;
//   // }

//   // static NAME of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<NameNotifier>().notifier.value;
//   static NAME of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<TestInheritedNotifier>().notifier.value;
//   // static update of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<NameInheritedNotifier>().notifier.value;
//   // NameInheritedNotifier.of(context).NAME
// }