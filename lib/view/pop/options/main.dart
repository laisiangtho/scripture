import 'package:flutter/material.dart';
import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);
  static String route = 'pop-options';
  static String label = 'Options';
  static IconData icon = Icons.opacity_outlined;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends StateAbstract<Main> {
  void setFontSize(bool increase) {
    setState(() {
      fontSize.call(increase);
    });
  }

  void Function(bool) get fontSize => args!['setFontSize'];

  late final RenderBox render = args!['render'];
  late final Size sizeOfRender = render.size;
  late final Offset positionOfRender = render.localToGlobal(Offset.zero);
  late final Size sizeOfContext = MediaQuery.of(context).size;

  double get hzSpace => 5;
  double get maxWidth => 300;
  double get right => hzSpace;
  double get left => sizeOfContext.width > maxWidth ? sizeOfContext.width - maxWidth : hzSpace;
  double get top => positionOfRender.dy + sizeOfRender.height + 10;

  double get arrowWidth => 10;
  double get arrowHeight => 12;

  double get defaultHeight => sizeOfRender.height + 75;
  double get maxHeight => defaultHeight * 0.75;
  double get height => defaultHeight > maxHeight ? maxHeight : defaultHeight;

  @override
  Widget build(BuildContext context) {
    return ViewPopupShapedArrow(
      left: left,
      right: right,
      top: top,
      height: height,
      arrow: positionOfRender.dx - left + (sizeOfRender.width * 0.3),
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
      backgroundColor: Theme.of(context).backgroundColor,
      child: SizedBox(
        height: height,
        child: view(),
      ),
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
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.36,
          crossAxisCount: 3,
        ),
        shrinkWrap: true,
        children: <Widget>[
          ViewButton(
            // style: Theme.of(context).textTheme.labelSmall,
            style: state.textTheme.labelLarge,
            onPressed: () => setFontSize(false),
            child: const Align(alignment: Alignment.center, child: Text('-')),
          ),
          ViewMark(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  width: 0.5,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            label: App.core.data.boxOfSettings.fontSize().asDouble.toStringAsFixed(0),
          ),
          ViewButton(
            onPressed: () => setFontSize(true),
            // style: Theme.of(context).textTheme.labelLarge,
            style: state.textTheme.labelLarge,
            child: const Align(alignment: Alignment.center, child: Text('+')),
          ),
        ],
      ),
    );
  }
}
