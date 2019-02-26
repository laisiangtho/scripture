
import 'package:flutter/material.dart';


class BibleSearch extends SearchDelegate<String> {
  final cities =[
    "Apple",
    "Orange",
    "asdf",
    "Apple",
    "Orange",
    "asdf",
    "Apple",
    "Orange",
    "asdf",
    "Apple",
    "Orange",
    "asdf",
    "Apple",
    "Orange",
    "asdf",
    "Apple",
    "Orange",
    "asdf",
    "Apple",
    "Orange",
    "asdf",
    "Apple",
    "Orange",
    "asdf",
    "Apple",
    "Orange",
    "asdf",
    "Apple",
    "Orange",
    "asdf",
    "Apple",
    "Orange",
    "asdf",
  ];
  final recentCities =[
    "Apple",
    "Orange",
    "asdf",
    "Apple",
    "Orange"
  ];
  @override
  ThemeData appBarTheme(BuildContext context) {
    // assert(context != null);
    // final ThemeData theme = Theme.of(context);
    // assert(theme != null);
    return Theme.of(context).copyWith(
      // primaryColor: Colors.red,
      // backgroundColor: Colors.blue,
      // accentColor: Colors.blue,
      // primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      // primaryColorBrightness: Brightness.light,
      // primaryTextTheme: theme.textTheme,
      // canvasColor: Colors.white,
    );
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, size: 15),
        onPressed: (){
          query='';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // return IconButton(
    //   icon: AnimatedIcon(
    //     icon: AnimatedIcons.menu_arrow,
    //     progress: transitionAnimation
    //   ),
    //   onPressed: (){
    //     close(context, null);
    //   }
    // );
    return new IconButton(
      icon: new Icon(Icons.keyboard_arrow_left),
      color: Colors.grey,
      onPressed: () {
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // return Card(
    //   color: Colors.red,
    //   shape: StadiumBorder(),
    //   child: Center(
    //     child: Text(query),
    //   ),
    // );
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Text('query : $query',style: TextStyle(color: Colors.red),)
      )
    );
    // return Container(
    //   child: Text('query : $query',style: TextStyle(color: Colors.red),)
    // );
    // return Text(
    //   'query : $query',
    //   style: TextStyle(color: Colors.red),
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // final suggestCities = query.isEmpty?recentCities:cities;
    final suggestCities = query.isEmpty?recentCities:cities.where((x)=>x.startsWith(query)).toList();

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: suggestCities.length,
        itemBuilder: (context, index)=>ListTile(
          onTap:(){
            query = suggestCities[index];
            showResults(context);
          },
          leading: Icon(Icons.location_city),
          // title: Text(suggestCities[index])
          title: RichText(
            text: TextSpan(
              text: suggestCities[index].substring(0,query.length),
              style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400
              ),
              children: [
                TextSpan(
                  text: suggestCities[index].substring(query.length),
                  style: TextStyle(
                    color: Colors.grey
                  )
                )
              ]
            ),
          )
        )
      )
    );
  }
}
