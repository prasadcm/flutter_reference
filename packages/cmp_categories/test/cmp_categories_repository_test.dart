import 'dart:typed_data';

import 'package:cmp_categories/cmp_categories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CategoriesRepository Tests with data: ', () {
    late CategoriesRepository repository;

    setUp(() {
      // Register mock asset bundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) {
            const String mockJsonData = '''
        [
        {
            "category_id": "1",
            "item_id": "1",
            "name": "Grocery & Kitchen",
            "item": "Fruits & Vegetables",
            "image": "assets/images/categories/fruits.jpg",
            "category_sequence": 1,
            "item_sequence": 1
          },
          {
            "category_id": "1",
            "item_id": "2",
            "name": "Grocery & Kitchen",
            "item": "Dairy, Bread & Eggs",
            "image": "assets/images/categories/dairy.jpg",
            "category_sequence": 1,
            "item_sequence": 2
          }
        ]
        ''';
            final bytes = Uint8List.fromList(mockJsonData.codeUnits);
            return Future.value(ByteData.view(bytes.buffer));
          });
      repository = const CategoriesRepository();
    });

    tearDown(() {
      // Un register mock asset bundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });

    test('loadCategories should return list of CategoryModel', () async {
      final categories = await repository.loadCategories();

      // Verify the result is a list of CategoryModel
      expect(categories, isA<List<CategoryModel>>());
      expect(categories.length, 2);

      // Verify the first suggestion
      expect(categories[0].category_id, '1');
      expect(categories[0].name, 'Grocery & Kitchen');
      expect(categories[0].item_id, '1');
      expect(categories[0].item, 'Fruits & Vegetables');
      expect(categories[0].image, 'assets/images/categories/fruits.jpg');
      expect(categories[0].category_sequence, 1);
      expect(categories[0].item_sequence, 1);

      // Verify the second suggestion
      expect(categories[1].category_id, '1');
      expect(categories[1].name, 'Grocery & Kitchen');
      expect(categories[1].item_id, '2');
      expect(categories[1].item, 'Dairy, Bread & Eggs');
      expect(categories[1].image, 'assets/images/categories/dairy.jpg');
      expect(categories[1].category_sequence, 1);
      expect(categories[1].item_sequence, 2);
    });
  });
}
