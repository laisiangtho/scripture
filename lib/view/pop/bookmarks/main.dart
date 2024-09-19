// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends CommonStates<Main> {
  void setFontSize(bool increase) {
    setState(() {
      fontSize.call(increase);
    });
  }

  // void Function(bool) get fontSize => args['setFontSize'];
  void Function(bool) get fontSize => state.param.map['setFontSize'];

  late final RenderBox render = state.param.map['render'];
  late final Size sizeOfRender = render.size;
  late final Offset positionOfRender = render.localToGlobal(Offset.zero);
  late final Size sizeOfContext = MediaQuery.of(context).size;

  double get hzSpace => 5;
  double get maxWidth => 300;
  double get right => sizeOfContext.width > maxWidth ? sizeOfContext.width - maxWidth : hzSpace;
  double get left => hzSpace;

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
      backgroundColor: colorScheme.surface,
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
              color: colorScheme.background,
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
              color: colorScheme.background,
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
          ViewButtons(
            style: style.labelSmall,
            onPressed: () => setFontSize(false),
            child: const Align(alignment: Alignment.center, child: Text('A')),
          ),
          ViewMarks(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  width: 0.5,
                  color: theme.primaryColor,
                ),
              ),
            ),
            label: data.boxOfSettings.fontSize().asDouble.toStringAsFixed(0),
          ),
          ViewButtons(
            onPressed: () => setFontSize(true),
            style: style.labelLarge,
            child: const Align(alignment: Alignment.center, child: Text('A')),
          ),
        ],
      ),
    );
  }
}
