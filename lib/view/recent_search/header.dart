part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    return ViewHeaderLayoutStack(
      data: data,
      left: [
        BackButtonWidget(
          navigator: state.navigator,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          data.snapShrink,
        ),
        label: App.preference.text.recentSearch(boxOfRecentSearch.plural as String),
        data: data,
      ),
      right: [
        // ValueListenableBuilder(
        //   key: const ValueKey('fe'),
        //   valueListenable: App.core.data.boxOfRecentSearch.listen(),
        //   // valueListenable: App.core.data.boxOfBooks.listen(),
        //   builder: (BuildContext context, Box<RecentSearchType> box, Widget? child) {
        //     return ViewButton(
        //       enable: box.isNotEmpty,
        //       onPressed: onDeleteAllConfirmWithDialog,
        //       child: const ViewMark(
        //         icon: Icons.clear_all_rounded,
        //       ),
        //     );
        //   },
        // ),
        ViewButton(
          enable: boxOfRecentSearch.isNotEmpty,
          onPressed: onDeleteAllConfirmWithDialog,
          child: const ViewMark(
            icon: Icons.clear_all_rounded,
          ),
        )
      ],
    );
  }
}
