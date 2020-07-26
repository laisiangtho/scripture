part of 'core.dart';

mixin _Mock {
  // Future<String> getCollection = Future<String>.delayed(
  //   Duration(seconds: 2),
  //   () => 'Data Loaded',
  // );

  // Future.delayed(const Duration(milliseconds: 500), () {
  //   setState(() {
  //     store.isReady = true;
  //   });
  // });
  // Future<List<String>> getCollection() async {
  //   // return ['abc','xyx'];
  //   return List<String>.generate(50,
  //       (int index) => 'This is sliver child'
  //   );
  // }
  Future<List<String>> getCollectionMock() async {
    // return ['abc','xyx'];
    return List<String>.generate(50,
        (int index) => 'This is sliver child'
    );
  }

  // Future<bool> initCollectionMock() async {
  //   return Future<bool>.delayed(
  //     Duration(milliseconds: 500),
  //     () => true,
  //   );
  // }

}