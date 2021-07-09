part of 'main.dart';

class PopOptionList extends StatefulWidget {
  final RenderBox render;
  final void Function(bool) setFontSize;

  PopOptionList({
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

  // void setFontSize(bool increase) {
  //   double tmp = core.collection.fontSize;
  //   if (increase){
  //     tmp++;
  //   } else {
  //     tmp--;
  //   }
  //   setState(() {
  //     core.collection.fontSize = tmp.clamp(10.0, 40.0);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double halfWidth = (MediaQuery.of(context).size.width/2) - 50;

    return WidgetPopup(
      left:halfWidth,
      right: 10,
      height: 80,
      top: targetPosition.dy + targetSize.height + 7,
      arrow: targetPosition.dx - halfWidth + (targetSize.width/2)-7,
      // backgroundColor: Colors.grey[300],
      child: view()
    );
  }
  Widget view () {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: fontSizeOptions(),
        ),
      ],
    );
  }

  List<Widget> fontSizeOptions () {
    return <Widget>[
      CupertinoButton(
        color: Colors.grey[400],
        borderRadius: BorderRadius.all(Radius.circular(3)),
        // padding: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 30),
        minSize: 40,
        child: Text('A',
          style: new TextStyle(fontSize: 14),
        ),
        onPressed: ()=>widget.setFontSize(false)
        // onPressed: ()=> setFontSize(false)
      ),
      // new RichText(
      //   textAlign: TextAlign.center,
      //   text: new TextSpan(
      //     text: 'Fontsize\n',
      //     style: new TextStyle(
      //       fontSize: 13,
      //     ),
      //     children: <TextSpan>[
      //       new TextSpan(
      //         text: '100%',
      //         style: new TextStyle(fontWeight: FontWeight.bold)),
      //     ],
      //   ),
      // ),
      CupertinoButton(
        color: Colors.grey[400],
        borderRadius: BorderRadius.all(Radius.circular(3)),
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 30),
        minSize: 40,
        child: Text('A',
          style: new TextStyle(fontSize: 25),
        ),
        // onPressed: ()=> setFontSize(true)
        onPressed: ()=> widget.setFontSize(true)
      ),
    ];
  }
}