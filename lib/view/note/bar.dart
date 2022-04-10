part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    return ViewHeaderLayoutStack(
      leftAction: [
        WidgetButton(
          child: WidgetMark(
            icon: Icons.arrow_back_ios_new_rounded,
            label: preference.text.back,
          ),
          show: hasArguments,
          onPressed: args?.currentState!.maybePop,
        ),
      ],
      primary: WidgetAppbarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          org.snapShrink,
        ),
        label: preference.text.note(false),
        shrink: org.shrink,
      ),
      rightAction: [
        Selector<Core, bool>(
          selector: (_, e) => e.collection.boxOfBookmarks.box.isNotEmpty,
          builder: _barSortButton,
          child: const WidgetMark(
            icon: Icons.clear_all_rounded,
          ),
        ),
      ],
    );
  }

  Widget _barSortButton(BuildContext context, bool hasBookmark, Widget? child) {
    return WidgetButton(
      child: child,
      enable: hasBookmark,
      onPressed: onDeleteAllConfirmWithDialog,
    );
  }
}
