part of 'main.dart';

class PopOptionList extends StatefulWidget {
  final RenderBox render;
  final void Function(bool) setFontSize;

  const PopOptionList({
    Key? key,
    required this.render,
    required this.setFontSize,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopOptionListState();
}

class _PopOptionListState extends State<PopOptionList> with TickerProviderStateMixin {
  late Core core;

  Size get targetSize => widget.render.size;
  Offset get targetPosition => widget.render.localToGlobal(Offset.zero);

  // getOptionList
  // List<DefinitionOption> get getOptionList => Core.instance.getOptionList;
  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
  }

  void setFontSize(bool increase) {
    setState(() {
      widget.setFontSize(increase);
    });
  }

  @override
  Widget build(BuildContext context) {
    double halfWidth = (MediaQuery.of(context).size.width / 2) - 45;

    return WidgetPopup(
      left: halfWidth,
      right: 5,
      height: 60,
      top: targetPosition.dy + targetSize.height + 1,
      arrow: targetPosition.dx - halfWidth + (targetSize.width / 2) - 12,
      // arrow: targetPosition.dx - halfWidth + (targetSize.width / 2) - 7,
      // arrow: targetPosition.dx - halfWidth + (targetSize.width / 4),
      // backgroundColor: const Color(0xFFdbdbdb),
      backgroundColor: Theme.of(context).backgroundColor,
      child: view(),
    );
  }

  Widget view() {
    // return Column(
    //   mainAxisSize: MainAxisSize.max,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     Row(
    //       mainAxisSize: MainAxisSize.max,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: fontSizeOptions(),
    //     ),
    //   ],
    // );
    // return Row(
    //   mainAxisSize: MainAxisSize.max,
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: fontSizeOptions(),
    // );
    return GridTile(
      header: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).backgroundColor,
              blurRadius: 9,
              spreadRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
      footer: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).backgroundColor,
              blurRadius: 9,
              spreadRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          // mainAxisSpacing: 0.2,
          // crossAxisSpacing: 25.0,
          crossAxisCount: 3,
          childAspectRatio: 1.3,
          // mainAxisExtent: 1,
        ),
        children: <Widget>[
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(
              'A',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onPressed: () => setFontSize(false),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  width: 1,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
            child: Center(
              child: Text(
                '${core.collection.fontSize}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(
              'A',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 27,
                  ),
            ),
            onPressed: () => setFontSize(true),
          ),
        ],
      ),
    );
  }
}
