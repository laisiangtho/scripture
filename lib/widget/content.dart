// import 'package:flutter/material.dart';

// class WidgetContent extends StatelessWidget {

//   WidgetContent({
//     Key? key,
//     this.startWith:'...',
//     this.atLeast:'enable at least\na ',
//     this.enable:'Bible',
//     this.task:'\nto ',
//     this.message:'read',
//     this.endWith:'...'
//   }): super(key: key);

//   final String startWith;
//   final String endWith;
//   final String atLeast;
//   final String enable;
//   final String task;
//   final String message;

//   String get label => '$startWith $atLeast $enable $task $message $endWith'.replaceAll("\n", " ").replaceAll("  ", " ");

//   @override
//   // enable at least\na Bible to read
//   // enable at least\na Bible to search
//   // enable at least\na Bible to view bookmarks
//   // search\na Word or two in verses
//   Widget build(BuildContext context) {
//     return SliverFillRemaining(
//       key: key,
//       fillOverscroll: false,
//       hasScrollBody: false,
//       child: Center(
//         child: Semantics(
//           label: "Message",
//           child: Text(
//             label,
//             semanticsLabel: label,
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.headline4
//           )
//         )
//       )
//     );
//   }
// }