import 'package:flutter/material.dart';
import 'package:lidea/icon.dart';

/// NOTE: Core, Components
import '/app.dart';

class MenuSidebar extends StatelessWidget {
  final StatefulNavigationShell shell;
  const MenuSidebar({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          // right: 2,
          // top: viewPadding.top,
          // bottom: viewPadding.bottom,
          // left: viewPadding.left,
          ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5) ),
            // color: context.theme.scaffoldBackgroundColor,
            // color: context.theme.disabledColor,
            // color: context.theme.primaryColor,
            // color: context.theme.dividerColor.withOpacity(0.1),
            // boxShadow: [
            //   BoxShadow(
            //     color: context.theme.dividerColor,
            //     offset: const Offset(0, 0),
            //     blurRadius: 2,
            //     spreadRadius: 1,
            //   )
            // ],
            ),
        child: navigationColumn(context),
      ),
    );
  }

  Widget navigationRail(BuildContext context) {
    return NavigationRail(
      leading: const Text('lead'),
      trailing: const Text('trail'),
      // groupAlignment: 1.0,
      // extended: true,
      destinations: [
        NavigationRailDestination(
          icon: const Icon(LideaIcon.flag),
          label: Text(context.lang.home),
        ),
        NavigationRailDestination(
          icon: const Icon(LideaIcon.bookOpen),
          label: Text(context.lang.read),
        ),
        NavigationRailDestination(
          icon: const Icon(LideaIcon.listNested),
          label: Text(context.lang.recentSearch('')),
        ),
        NavigationRailDestination(
          icon: const Icon(LideaIcon.search),
          label: Text(context.lang.search('')),
        ),
      ],
      selectedIndex: shell.currentIndex,
      onDestinationSelected: (int index) {
        shell.goBranch(index, initialLocation: index == shell.currentIndex);
      },
    );
  }

  Widget navigationColumn(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(top: context.viewPaddingOf.top),
          // child: SizedBox(
          //   child: ViewButtons(
          //     // padding: EdgeInsets.zero,
          //     // padding : const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
          //     // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          //     constraints: const BoxConstraints(minWidth: 50, maxHeight: kToolbarHeight),
          //     onPressed: App.core.menuToggle,
          //     child: const ViewMarks(
          //       // icon: Icons.segment_rounded,
          //       icon: Icons.chevron_left_rounded,
          //       // icon: LideaIcon.bible,
          //     ),
          //   ),
          // ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: ViewMenuSidebar(
              items: const [
                ViewMarks(
                  icon: LideaIcon.flag,
                ),
                ViewMarks(
                  icon: LideaIcon.bookOpen,
                ),
                ViewMarks(
                  icon: LideaIcon.listNested,
                ),
                ViewMarks(
                  icon: LideaIcon.search,
                ),
              ],
              currentIndex: shell.currentIndex,
              onTap: (int index) {
                shell.goBranch(index, initialLocation: index == shell.currentIndex);
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: context.viewPaddingOf.bottom),
          // child: const SizedBox(
          //   height: kBottomNavigationBarHeight,
          //   child: ViewMarks(
          //     child: Text('f'),
          //   ),
          // ),
        ),
      ],
    );
  }
}
