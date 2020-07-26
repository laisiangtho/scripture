part of 'main.dart';

class PopOptionList extends StatefulWidget {
  final RenderBox mainContext;
  final void Function(bool) setFontSize;
  PopOptionList(
    {
      Key key,
      this.mainContext,
      this.setFontSize,
    }
  ) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopOptionListState();
}

class _PopOptionListState extends State<PopOptionList> {


  RenderBox get mainContext => widget.mainContext;
  Size get targetSize => mainContext.size;
  Offset get targetPosition => mainContext.localToGlobal(Offset.zero);

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
        onPressed: ()=> widget.setFontSize(true)
      ),
    ];
  }
}
