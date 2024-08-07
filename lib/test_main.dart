import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const NameSpace());
}

/// The app widget
class NameSpace extends StatelessWidget {
  const NameSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Service Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _State();
}

class _State extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('abc'),
    );
  }
}
