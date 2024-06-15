import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Home'),
            pinned: true,
          ),
          SliverMainAxisGroup(
            slivers: <Widget>[
              SliverAppBar(
                title: const Text('First'),
                titleTextStyle: Theme.of(context).textTheme.labelMedium,
                pinned: true,
              ),
              SliverList.builder(
                itemBuilder: (BuildContext _, int index) {
                  return ListTile(
                    title: Text('... $index'),
                  );
                },
                itemCount: 30,
              ),
              SliverAppBar(
                title: const Text('Second'),
                titleTextStyle: Theme.of(context).textTheme.labelMedium,
                pinned: true,
              ),
              SliverList.builder(
                itemBuilder: (BuildContext _, int index) {
                  return ListTile(
                    title: Text('... $index'),
                  );
                },
                itemCount: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
