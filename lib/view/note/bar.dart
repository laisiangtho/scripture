part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return SliverAppBar(
      pinned: true,
      floating: false,
      // snap: false,
      centerTitle: true,
      elevation: 0.2,
      forceElevated: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: barTitle(),
      // expandedHeight: 120,
      // backgroundColor: innerBoxIsScrolled?Theme.of(context).primaryColor:Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor: Theme.of(context).primaryColor,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(3, 2)),
      ),
      automaticallyImplyLeading: false,
      // leading: CupertinoButton(
      //   padding: EdgeInsets.zero,
      //   child: WidgetLabel(
      //     icon: CupertinoIcons.left_chevron,
      //     label: translate.back,
      //   ),
      //   onPressed: () => true,
      // ),
      actions: [
        Selector<Core, bool>(
          selector: (_, e) => e.collection.boxOfBookmark.length > 0,
          builder: (BuildContext context, bool hasBookmark, Widget? child) {
            return _barSortButton(hasBookmark);
          },
        ),
      ],
    );
  }

  Widget barTitle() {
    return Semantics(
      label: translate.page(false),
      // label: translate.page,
      child: Text(
        translate.note(false),
        semanticsLabel: translate.note(false),
      ),
    );
  }

  Widget _barSortButton(bool hasBookmark) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: WidgetLabel(
        message: translate.clear,
        icon: LideaIcon.trash,
        iconSize: 18,
      ),
      onPressed: hasBookmark ? onDeleteAll : null,
    );
    /*
    return Tooltip(
      message: 'Clear all',
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: const Icon(
          LideaIcon.trash,
          size: 18,
        ),
        onPressed: hasBookmark ? onDeleteAll : null,
      ),
    );
    */
  }
}
