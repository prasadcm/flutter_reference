import 'dart:convert';

import 'package:categories/categories.dart';
import 'package:categories/src/data/category_item.dart';
import 'package:categories/src/data/category_section.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CategoriesRepository Tests with data: ', () {
    late CategoriesRepository repository;
    late MockApiClient mockApi;
    late String mockApiData;

    setUp(() {
      mockApi = MockApiClient();
      mockApiData = '''
        {
          "data" : [
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
        }
        ''';
      repository = CategoriesRepository(mockApi);
    });

    tearDown(() {
      repository.clearCache();
    });

    test('loadCategories should return list of CategorySection', () async {
      when(() => mockApi.get('categories')).thenAnswer((_) async {
        return jsonDecode(mockApiData) as Map<String, dynamic>;
      });

      final categories = await repository.loadCategories();

      // Verify the result is a list of CategorySection
      expect(categories, isA<List<CategorySection>>());
      expect(categories.length, 1);

      // Verify the first section
      expect(categories[0].title, 'Grocery & Kitchen');
      expect(categories[0].items[0], isA<CategoryItem>());
      expect(categories[0].items[1], isA<CategoryItem>());
      expect(categories[0].items[0].name, 'Fruits & Vegetables');
      expect(
        categories[0].items[0].imageUrl,
        'assets/images/categories/fruits.jpg',
      );
      expect(categories[0].items[1].name, 'Dairy, Bread & Eggs');
      expect(
        categories[0].items[1].imageUrl,
        'assets/images/categories/dairy.jpg',
      );
    });
  });

  group('CategoryModel Tests: ', () {
    late dynamic json;

    setUp(() {
      json = {
        'category_id': '1',
        'item_id': '1',
        'name': 'Grocery & Kitchen',
        'item': 'Fruits & Vegetables',
        'image': 'assets/images/categories/fruits.jpg',
        'category_sequence': 1,
        'item_sequence': 1,
      };
    });

    tearDown(() {});

    test('fromJson should return list of CategoryModel', () {
      final categoryModel = CategoryModel.fromJson(
        json as Map<String, dynamic>,
      );

      expect(categoryModel.itemId, '1');
      expect(categoryModel.categoryId, '1');
      expect(categoryModel.name, 'Grocery & Kitchen');
      expect(categoryModel.item, 'Fruits & Vegetables');
      expect(categoryModel.image, 'assets/images/categories/fruits.jpg');
      expect(categoryModel.categorySequence, 1);
      expect(categoryModel.itemSequence, 1);
    });
  });
}
