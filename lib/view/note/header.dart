part of 'main.dart';

mixin _Header on _State {
  Widget _header() {
    return ViewHeaderLayouts.fixed(
      height: kToolbarHeight,
      left: [
        OptionButtons.back(
          label: app.preference.of(context).back,
        ),
      ],
      primary: ViewHeaderTitle.fixed(
        label: app.preference.of(context).note('false'),
      ),
      right: [
        ValueListenableBuilder(
          key: const ValueKey('fe'),
          valueListenable: App.core.data.boxOfBookmarks.listen(),
          // valueListenable: App.core.data.boxOfBooks.listen(),
          builder: (BuildContext context, Box<BookmarksType> box, Widget? child) {
            return ViewButtons(
              enable: box.isNotEmpty,
              onPressed: onDeleteAllConfirmWithDialog,
              child: const ViewMarks(
                icon: Icons.clear_all_rounded,
              ),
            );
          },
        ),
      ],
    );
  }
}
