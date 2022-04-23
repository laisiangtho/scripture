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

class _PopOptionListState extends State<PopOptionList> {
  final double arrowWidth = 10;
  final double arrowHeight = 12;

  late final Core core = context.read<Core>();

  late final Size mediaSize = MediaQuery.of(context).size;

  late final double mediaWidthHaft = mediaSize.width * 0.4;

  late final Size widgetSize = widget.render.size;
  late final Offset widgetPosition = widget.render.localToGlobal(Offset.zero);

  late final double bottomOfWidget = widgetPosition.dy + widgetSize.height + 15;

  @override
  void initState() {
    super.initState();
  }

  void setFontSize(bool increase) {
    setState(() {
      widget.setFontSize(increase);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetPopupShapedArrow(
      left: mediaWidthHaft,
      right: 5,
      top: bottomOfWidget,
      height: widgetSize.height + 40,
      // arrow: widgetPosition.dx - mediaWidthHaft + (widgetSize.width * 0.3),
      arrow: widgetPosition.dx - mediaWidthHaft + (widgetSize.width * 0.3),
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
      backgroundColor: Theme.of(context).backgroundColor,
      child: view(),
    );
  }

  Widget view() {
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
          childAspectRatio: 1.15,
          // mainAxisExtent: 1,
        ),
        children: <Widget>[
          WidgetButton(
            child: WidgetMark(
              label: 'A',
              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
              labelStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
            ),
            onPressed: () => setFontSize(false),
          ),
          WidgetMark(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  width: 0.5,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            label: core.collection.boxOfSettings.fontSize().asDouble.toStringAsFixed(0),
            // label: core.collection.boxOfSettings.fontSize().asString,
            labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          ),
          WidgetButton(
            child: WidgetMark(
              label: 'A',
              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
              labelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
            ),
            onPressed: () => setFontSize(true),
          ),
        ],
      ),
    );
  }
}
