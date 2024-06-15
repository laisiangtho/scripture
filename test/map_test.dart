import 'package:flutter_test/flutter_test.dart';
// import 'package:scripture/core/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Map', () async {
    // final j = UtilDocument.decodeJSON<Map<String, dynamic>>(
    //   await UtilDocument.loadBundleAsString('category.json'),
    // );
    test('should add two numbers together', () {
      // Map<String, dynamic> o = {
      //   '1': {
      //     'info': {
      //       'name': 'a',
      //     }
      //   },
      //   '2': {
      //     'info': {
      //       'name': 'b',
      //     }
      //   }
      // };
      // for (var element in o) {
      //   element.map<CategoryTestament>((e) => CategoryTestament.fromJSON(e.keys.first, e['info']))
      // }

      expect(1 + 1, 2);
    });
  });
}
