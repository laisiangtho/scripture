import 'package:flutter/material.dart';
import 'package:laisiangtho/Store.dart';
import 'package:laisiangtho/NoteView.dart';

class Note extends StatefulWidget {
  // Note({Key key, @required this.title}) : super(key: key);
  // final String title;

  @override
  NoteView createState() => new NoteView();
}

abstract class NoteState extends State<Note> {

  @protected
  Store store;

  @override
  void initState() {
    super.initState();
    store = new Store();
  }

  @protected
  List<String> todos = new List<String>();

  @protected
  TextEditingController textcontroller = new TextEditingController();

  @protected
  void addTodo(text) {
    setState(() => todos.add(text));
    textcontroller.clear();
  }

  @protected
  void removeTodo(index) {
    setState(() => todos.removeAt(index));
  }
}