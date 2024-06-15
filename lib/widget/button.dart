// import 'package:flutter/material.dart';

// import '../app.dart';

// class BackButtonWidget extends StatelessWidget {
//   const BackButtonWidget({
//     super.key,
//     this.navigator,
//     this.root = false,
//     this.icon,
//     this.label,
//   });

//   final NavigatorState? navigator;
//   final bool root;
//   final IconData? icon;
//   final String? label;

//   @override
//   Widget build(BuildContext context) {
//     final nav = navigator ?? Navigator.of(context, rootNavigator: root);
//     // final isiOS = Theme.of(context).platform == TargetPlatform.iOS;
//     return ViewButton(
//       show: nav.canPop(),
//       onPressed: nav.maybePop,
//       style: Theme.of(context).textTheme.titleSmall,
//       child: ViewMark(
//         icon: icon ?? Icons.arrow_back_ios_rounded,
//         // icon: Icons.arrow_forward_ios,
//         // icon: isiOS ? Icons.arrow_back_ios_rounded : Icons.arrow_back,
//         label: label ?? App.preference.text.back,
//         // iconLeft: false,
//       ),
//     );
//   }
// }

// class HomeButtonWidget extends StatelessWidget {
//   const HomeButtonWidget({
//     super.key,
//     this.navigator,
//     this.root = false,
//     this.icon,
//     this.label,
//   });

//   final NavigatorState? navigator;
//   final bool root;
//   final IconData? icon;
//   final String? label;

//   @override
//   Widget build(BuildContext context) {
//     final nav = navigator ?? Navigator.of(context, rootNavigator: root);
//     return ViewButton(
//       show: nav.canPop(),
//       onPressed: nav.maybePop,
//       // style: Theme.of(context).textTheme.labelMedium,
//       // style: Theme.of(context).textTheme.titleSmall,
//       child: ViewMark(
//         icon: icon ?? Icons.home,
//         label: label ?? App.preference.text.home,
//       ),
//     );
//   }
// }

// class CancelButtonWidget extends StatelessWidget {
//   const CancelButtonWidget({
//     super.key,
//     this.navigator,
//     this.root = false,
//     this.label,
//   });

//   final NavigatorState? navigator;
//   final bool root;

//   final String? label;

//   @override
//   Widget build(BuildContext context) {
//     final nav = navigator ?? Navigator.of(context, rootNavigator: root);
//     return ViewButton(
//       show: nav.canPop(),
//       onPressed: nav.maybePop,
//       // style: Theme.of(context).textTheme.labelMedium,
//       // style: Theme.of(context).textTheme.titleSmall,
//       child: ViewMark(
//         label: label ?? App.preference.text.cancel,
//       ),
//     );
//   }
// }

// ViewButtonTitle TitleViewButton ButtonTitle.back ButtonTitle.cancel ViewButtonHeader

// class ViewButtonHeader extends StatelessWidget {
//   const ViewButtonHeader({
//     super.key,
//     this.navigator,
//     this.root = false,
//     this.icon,
//     this.label,
//     this.type = 'home',
//   });

//   const ViewButtonHeader.back({
//     super.key,
//     this.navigator,
//     this.root = false,
//     this.icon,
//     this.label,
//   }) : type = 'back';

//   const ViewButtonHeader.cancel({
//     super.key,
//     this.navigator,
//     this.root = false,
//     this.label,
//   })  : type = 'cancel',
//         icon = null;

//   final String type;
//   final NavigatorState? navigator;
//   final bool root;
//   final IconData? icon;
//   final String? label;

//   @override
//   Widget build(BuildContext context) {
//     // final parent = Navigator.of(context, rootNavigator: true);
//     // final self = Navigator.of(context);

//     // final selfCanPop = self.canPop();

//     final nav = navigator ?? Navigator.of(context, rootNavigator: root);

//     if (type == 'back') {
//       return ViewButton(
//         show: nav.canPop(),
//         onPressed: nav.maybePop,
//         style: Theme.of(context).textTheme.titleSmall,
//         child: ViewMark(
//           icon: icon ?? Icons.arrow_back_ios_rounded,
//           // icon: Icons.arrow_forward_ios,
//           // icon: isiOS ? Icons.arrow_back_ios_rounded : Icons.arrow_back,
//           label: label ?? App.preference.text.back,
//           // iconLeft: false,
//         ),
//       );
//     }
//     if (type == 'cancel') {
//       return ViewButton(
//         show: nav.canPop(),
//         onPressed: nav.maybePop,
//         style: Theme.of(context).textTheme.titleSmall,
//         child: ViewMark(
//           label: label ?? App.preference.text.cancel,
//         ),
//       );
//     }
//     return ViewButton(
//       show: nav.canPop(),
//       onPressed: nav.maybePop,
//       // style: Theme.of(context).textTheme.labelMedium,
//       style: Theme.of(context).textTheme.titleSmall,
//       child: ViewMark(
//         icon: icon ?? Icons.home,
//         label: label ?? App.preference.text.home,
//       ),
//     );
//   }
// }
