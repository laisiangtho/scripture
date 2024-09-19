part of 'main.dart';

class BookListItem extends StatefulWidget {
  const BookListItem({
    super.key,
    required this.book,
    required this.index,
    this.onPress,
    this.onLongPress,
    this.dragController,
  });

  final BooksType book;
  final AnimationController? dragController;
  final int index;
  final void Function()? onPress;
  final void Function()? onLongPress;

  @override
  State<BookListItem> createState() => _BookItemsState();
}

class _BookItemsState extends CommonStates<BookListItem> {
  BooksType get book => widget.book;
  bool get isAvailable => book.available > 0;
  bool get isPrimary => book.identify == data.primaryId;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      title: Text(
        book.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium!.copyWith(
          fontWeight: isAvailable ? FontWeight.w400 : FontWeight.w300,
        ),
      ),
      subtitle: Row(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        // textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(
              minWidth: 40.0,
              // minHeight: 20,
            ),
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
            margin: const EdgeInsets.only(right: 7),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: isPrimary
                  ? theme.highlightColor.withOpacity(0.7)
                  : isAvailable
                      ? theme.focusColor
                      : theme.disabledColor,
            ),
            child: Text(
              book.langCode.toUpperCase(),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 0),
          //   child: Text(
          //     book.shortname,
          //     // book.identify,
          //     style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
          //   ),
          // ),

          Text(
            book.shortname,
            // book.identify,
            style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
          ),
          if (isAvailable)
            const Icon(
              Icons.check,
              size: 19,
            ),
        ],
      ),
      trailing: (widget.dragController != null)
          ? AnimatedBuilder(
              animation: widget.dragController!,
              builder: (context, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: widget.dragController!.isCompleted ? dragHandler() : child!,
                );
              },
              child: yearMarks,
            )
          : yearMarks,
      onTap: widget.onPress,
      onLongPress: widget.onLongPress,
    );
  }

  Widget get yearMarks {
    return ViewMarks(
      child: Text(
        book.year.toString(),
      ),
    );
  }

  Widget dragHandler() {
    return ReorderableDragStartListener(
      index: widget.index,
      child: ViewMarks(
        icon: Icons.drag_handle_rounded,
        iconColor: colorScheme.error,
      ),
    );
  }
}
