import 'package:flutter/material.dart';
// import 'package:laisiangtho/StoreModel.dart';
import 'package:laisiangtho/Note.dart';

class NoteView extends NoteState {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(widget.title)),
      // appBar: AppBar(title: Text(store.appTitle)),
      appBar: AppBar(
        title: new Card(
            margin: EdgeInsets.all(0.0),
            elevation: 1.0,
            child: new Padding(
              padding: new EdgeInsets.symmetric(vertical: 0, horizontal: 6),
              child: TextField(
                controller: textcontroller,
                decoration: new InputDecoration(
                  hintText: 'What do you need to do?',
                  border: InputBorder.none
                ),
                onSubmitted: addTodo
              ),
            ),
          )
      ),
      body: Column(
        children: <Widget>[
          // new Card(
          //   margin: EdgeInsets.all(10.0),
          //   elevation: 4.0,
          //   child: new Padding(
          //     padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          //     child: TextField(
          //       controller: textcontroller,
          //       decoration: new InputDecoration(
          //         hintText: 'What do you need to do?',
          //         border: InputBorder.none
          //       ),
          //       onSubmitted: addTodo
          //     ),
          //   ),
          // ),
          new Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (_, int index) => new Card(
                elevation: 1.0,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: ListTile(
                  leading: new CircleAvatar(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    child: Text((index+1).toString()),
                    radius: 15.0
                  ),
                  title: Text(
                    todos[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                  ),
                  trailing: new InkWell(
                    child: Icon(Icons.delete),
                    onTap: () => removeTodo(index)
                  ),
                )
              ),
            ),
          ),
        ]
      )
    );
  }
}