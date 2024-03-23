import 'package:flutter/material.dart';

import '../app.dart';

class BackButtonWidget extends StatelessWidget {
  final NavigatorState navigator;
  const BackButtonWidget({super.key, required this.navigator});
  // NavigatorState get navigator => Navigator.of(context);
  // NavigatorState get navigator => App.route.navigator(context);
  @override
  Widget build(BuildContext context) {
    return ViewButton(
      show: navigator.canPop(),
      onPressed: navigator.maybePop,
      // style: Theme.of(context).textTheme.labelMedium,
      style: Theme.of(context).textTheme.titleSmall,
      child: ViewMark(
        icon: Icons.arrow_back_ios_rounded,
        label: App.preference.text.back,
      ),
    );
  }
}

class HomeButtonWidget extends StatelessWidget {
  final NavigatorState navigator;
  const HomeButtonWidget({super.key, required this.navigator});
  // NavigatorState get navigator => Navigator.of(context);
  // NavigatorState get navigator => App.route.navigator(context);
  @override
  Widget build(BuildContext context) {
    return ViewButton(
      show: navigator.canPop(),
      onPressed: navigator.maybePop,
      // style: Theme.of(context).textTheme.labelMedium,
      style: Theme.of(context).textTheme.titleSmall,
      child: ViewMark(
        icon: Icons.arrow_back_ios_rounded,
        label: App.preference.text.back,
        // label: 'Back',
      ),
    );
  }
}
