part of 'main.dart';

// class TmpOptionButtons extends OptionButtons {
//   const TmpOptionButtons({super.key, String label = 'tmp'});
// }

// class TmpViewButtons extends ViewButtons {
//   const TmpViewButtons({super.key, String label = 'tmp', required super.child});
// }

/// Action buttons
class Buttons extends StatefulWidget {
  const Buttons({
    super.key,
    this.type = '',
  });

  /// ...is extended from  `OptionButtons`.`back` which is stateless
  const Buttons.back({super.key}) : type = 'back';

  /// ...is extended from  `OptionButtons`.`backOrMenu` which is stateless
  const Buttons.backOrMenu({super.key}) : type = 'backOrMenu';

  /// ...is extended from  `OptionButtons`.`backOrCancel` which is stateless
  const Buttons.backOrCancel({super.key}) : type = 'backOrCancel';

  const Buttons.search({super.key}) : type = 'search';
  final String type;

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends CommonStates<Buttons> {
  late final String type = widget.type;

  @override
  Widget build(BuildContext context) {
    if (type == 'backOrMenu') {
      // if (context.adaptive.isMobile) {
      //   return const Buttons.back();
      // }
      return OptionButtons.backOrMenu(
        menu: app.menu,
        back: lang.back,
        onPressed: app.menuToggle,
      );
    }
    if (type == 'backOrCancel') {
      return OptionButtons.backOrCancel(
        back: lang.back,
      );
    }
    if (type == 'back') {
      return OptionButtons.back(
        label: lang.back,
      );
    }
    if (type == 'search') {
      return OptionButtons.icon(
        // icon: Icons.search_rounded,
        icon: LideaIcon.search,
        iconSize: 20,
        onPressed: () {
          context.push('/search', extra: {'focus': true, 'keyword': data.searchQuery});
        },
      );
    }
    return const SizedBox();
  }
}
