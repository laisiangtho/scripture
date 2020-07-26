import 'package:flutter/material.dart';
import 'dart:math';

class FrogColor extends InheritedWidget {
  const FrogColor({
    Key key,
    this.color,
    this.onChange,
    this.value,
    Widget child,
  }) :
    // assert(color != null),
    // assert(child != null),
    super(key: key, child: child);

  final Color color;
  final String value;
  final ValueChanged<String> onChange;

  // static FrogColor of(BuildContext context) {
  //   return context.inheritFromWidgetOfExactType(FrogColor);
  // }
  static FrogColor of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<FrogColor>();

  @override
  bool updateShouldNotify(FrogColor old) => color != old.color;
}
// final ValueNotifier spinNotify = ValueNotifier<double>(1.0);

class ValueNotifierInheritedModel extends InheritedNotifier<ValueNotifier<int>> {
  ValueNotifierInheritedModel({
    Key key,
    ValueNotifier<int> one,
    Widget child,
  }) : super(key: key, notifier: one,child: child);

  static int of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ValueNotifierInheritedModel>().notifier.value;
}

class MainView extends StatefulWidget {
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView>{

  String idField;
  final spinNotify = ValueNotifier<int>(0);

  void onMyFieldChange(String newValue) {
      idField = newValue;
      // FrogColor.of(context).updateShouldNotify(old);

    // setState(() {
    // });
  }

  @override
  Widget build(BuildContext context) {
    var random = Random(DateTime.now().millisecondsSinceEpoch);
    return Scaffold(
      body: Center(
        child: Column (
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FrogColor(
              color : Color.fromARGB(255,random.nextInt(255),random.nextInt(255),random.nextInt(255)),
              value:idField,
              onChange: onMyFieldChange,
              child: Column (
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  A(),
                  C(),
                  FlatButton(
                      child:Text("withIn FrogColor ",style:TextStyle(color:Colors.red)),
                      onPressed:() => setState((){})
                  )
                ]
              ),
            ),
            // A(),
            // C(),

            // SpinModel(
            //   notifier:spinNotify,
            //   child: FlatButton(
            //     child:Text("Outside",style:TextStyle(color:Colors.red)),
            //     onPressed:() {
            //       // context.dependOnInheritedElement(ancestor)
            //     }
            //   ),
            // )
            ValueNotifierInheritedModel(
              one:spinNotify,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ValueNotifierInheritedWidget(),
                  FlatButton(
                      child:Text("Change ValueNotifierInheritedModel",style:TextStyle(color:Colors.red)),
                      onPressed:(){
                        spinNotify.value++;
                      }
                  )
                ]
              )
            )
          ]
        ),
      ),
    );
  }
}

class ValueNotifierInheritedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("${this.runtimeType.toString()}");
    // return  Text(ValueNotifierInheritedModel.of(context).notifier.value);
    // print(ValueNotifierInheritedModel.of(context).toString());
    // return Text(ValueNotifierInheritedModel.of(context).toString());
    int data = ValueNotifierInheritedModel.of(context);

    return Text(data.toString());
    // return Row (
    //   mainAxisSize: MainAxisSize.min,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: <Widget>[
    //      Text("a",style:TextStyle(color:FrogColor.of(context).color)),
    //      Text(FrogColor.of(context).value??'None'),
    //   ]
    // );
  }
}

class A extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("${this.runtimeType.toString()}");
    // final abc = context.getElementForInheritedWidgetOfExactType<FrogColor>();
    // abc.markNeedsBuild();

    // print(context.visitAncestorElements((element) => false));
    // return  B();
    return Row (
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
         Text("a",style:TextStyle(color:FrogColor.of(context).color)),
         Text(FrogColor.of(context).value??'None'),
      ]
    );
  }
}
class B extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("${this.runtimeType.toString()}");
    return  Text("B",style:TextStyle(color:FrogColor.of(context).color));
  }
}
class C extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("${this.runtimeType.toString()}");
    return  D();
  }
}
class D extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("${this.runtimeType.toString()}");
    return  Text("D",style:TextStyle(color:FrogColor.of(context).color));
  }
}