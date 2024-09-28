part of 'main.dart';

class UserDeskData extends StatefulWidget {
  const UserDeskData({super.key});

  @override
  State<UserDeskData> createState() => _UserDeskDataState();
}

class _UserDeskDataState extends CommonStates<UserDeskData> {
  late final ExpansionTileController _expansionController = ExpansionTileController();

  /// `0`: Not in Progress, `1`: Exporting, `2`: Importing
  late final _statusProgress = ValueNotifier<int>(0);
  late final _statusMessage = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const ValueKey('backup'),
      // controller: showBookId == book.info.id ? _expansionController : null,
      controller: _expansionController,
      textColor: theme.hintColor,
      // selectedTileColor: Colors.blue,
      // selectedTileColor: theme.cardColor,
      // selectedColor: theme.dividerColor,
      // contentPadding: EdgeInsets.zero,
      // horizontalTitleGap: 0,
      // collapsedShape: const RoundedRectangleBorder(
      //   side: BorderSide.none,
      // ),
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),

      iconColor: theme.focusColor,
      collapsedIconColor: theme.primaryColorDark,
      // backgroundColor: theme.expansionTileTheme.backgroundColor,
      // collapsedBackgroundColor: theme.expansionTileTheme.collapsedBackgroundColor,

      leading: const Icon(Icons.data_object),
      // showTrailingIcon: false,

      title: Text(
        // lang.backup,
        app.preference.lang(context).data('true'),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: style.bodyLarge,
      ),
      // trailing: ViewMarks(
      //   iconLeft: false,
      //   // icon: Icons.arrow_forward_ios_rounded,
      //   icon: Icons.expand_more_rounded,
      //   iconSize: 20,
      //   // iconColor: theme.hintColor,
      //   label: preference.digit(book.chapterCount),
      // ),

      // childrenPadding: const EdgeInsets.only(bottom: 15),
      childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
      children: [
        Paragraphs(
          text:
              'Preferences and configurations such as Bookmarks, Verse marks and Verse notes would be saved on your device as a flat file with JSON format, where the platform might provide cloud services. Please do keep in mind that {{App}} does not {{Export}} or {{Import}} automatically.',
          textAlign: TextAlign.center,
          decoration: [
            TextSpan(
              text: data.env.name,
              semanticsLabel: 'App',
              style: TextStyle(color: theme.primaryColorDark),
            ),
            TextSpan(
              text: lang.export.toLowerCase(),
              semanticsLabel: 'Export',
              style: TextStyle(color: theme.primaryColorDark),
            ),
            TextSpan(
              text: lang.import.toLowerCase(),
              semanticsLabel: 'Import',
              style: TextStyle(color: theme.primaryColorDark),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     cancelButtons(),
        //     const SizedBox(
        //       width: 15,
        //     ),
        //     actionButtons(
        //       label: lang.export,
        //       semanticsLabel: 'Update',
        //       onPressed: () {},
        //     ),
        //   ],
        // ),
        actionButtons(
          label: lang.export,
          semanticsLabel: 'Update',
          type: 1,
          onPressed: () async {
            _statusProgress.value = 1;
            await Future.delayed(const Duration(milliseconds: 1200));

            app.exportData();
            await Future.delayed(const Duration(milliseconds: 300));
            _statusProgress.value = 0;
            _statusMessage.value = 'Exported';
            await Future.delayed(const Duration(milliseconds: 1700));
          },
        ),
        const SizedBox(
          height: 15,
        ),
        Paragraphs(
          text: 'If you have previously {{Export}}, you might have data to be imported and merged.',
          textAlign: TextAlign.center,
          decoration: [
            TextSpan(
              text: lang.export.toLowerCase(),
              semanticsLabel: 'Export',
              style: TextStyle(color: theme.primaryColorDark),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        actionButtons(
          label: lang.import,
          semanticsLabel: 'Import',
          type: 2,
          onPressed: () async {
            _statusProgress.value = 2;
            await Future.delayed(const Duration(milliseconds: 1700));
            app.importData();
            _statusProgress.value = 0;
            _statusMessage.value = 'Imported';
            await Future.delayed(const Duration(milliseconds: 1700));
          },
        ),
        const SizedBox(
          height: 15,
        ),
        messageContainer(),
      ],
    );
  }

  Widget actionButtons({
    required String label,
    String? semanticsLabel,
    required int type,
    void Function()? onPressed,
    bool loading = false,
  }) {
    return ValueListenableBuilder(
      valueListenable: _statusProgress,
      builder: (_, status, child) {
        final current = status == type;
        final active = status > 0;
        return TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            backgroundColor: theme.focusColor,
            elevation: 30,
            // surfaceTintColor: theme.colorScheme.error,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            disabledBackgroundColor: theme.disabledColor,
            // disabledBackgroundColor: Colors.red,
            iconColor: theme.hintColor,
          ),
          onPressed: active ? null : onPressed,
          // icon: const Icon(
          //   Icons.import_export,
          //   size: 25,
          // ),
          // icon: SizedBox(
          //   width: 25,
          //   height: 25,
          //   child: CircularProgressIndicator(
          //     strokeWidth: 2,
          //     color: theme.colorScheme.error,
          //   ),
          // ),
          icon: current
              ? SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.error,
                  ),
                )
              : const Icon(
                  Icons.import_export,
                  size: 25,
                ),
          label: child!,
        );
      },
      child: Text(
        label,
        semanticsLabel: semanticsLabel ?? label,
        style: style.labelMedium,
      ),
    );
  }

  Widget cancelButtons() {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        surfaceTintColor: theme.focusColor,
        elevation: 30,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        disabledBackgroundColor: theme.disabledColor,
      ),
      onPressed: () {
        _expansionController.collapse();
      },
      label: Text(
        lang.cancel,
        semanticsLabel: 'Cancel',
        style: style.labelMedium,
      ),
    );
  }

  Widget messageContainer() {
    return ValueListenableBuilder(
      valueListenable: _statusMessage,
      builder: (_, msg, child) {
        if (msg == '') {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Paragraphs(
            text: '{{Message}} \n{{Ok}} - {{Done}}',
            textAlign: TextAlign.center,
            decoration: [
              TextSpan(
                text: msg,
                semanticsLabel: 'Message',
              ),
              TextSpan(
                text: 'Ok',
                semanticsLabel: 'Ok',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    debugPrint('Ok');
                    _statusMessage.value = '';
                  },
              ),
              TextSpan(
                text: 'Done',
                semanticsLabel: 'Done',
                style: const TextStyle(color: Colors.red),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // debugPrint('Done');
                    _expansionController.collapse();

                    _statusMessage.value = '';
                  },
              ),
            ],
          ),
        );
      },
    );
  }
}
