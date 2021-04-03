class Mock {
  Future<List<String>> ramdom() async {
    // return ['abc','xyx'];
    return List<String>.generate(50,
        (int index) => 'This is sliver child'
    );
  }

  // Future<String> getCollection = Future<String>.delayed(
  //   Duration(seconds: 2),
  //   () => 'Data Loaded',
  // );

  // Future.delayed(const Duration(milliseconds: 500), () {});

  // Future<void> delay() async {
  //   await Future.delayed(Duration(milliseconds: 300), (){});
  // }

  // Future<bool> initCollectionMock() async {
  //   return Future<bool>.delayed(
  //     Duration(milliseconds: 500),
  //     () => true,
  //   );
  // }
}