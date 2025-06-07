import 'dart:convert';

import 'package:core/src/storage/cache_entry.dart';
import 'package:core/src/storage/hive_cache_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockBox<T> extends Mock implements Box<T> {}

class TestEntityItem extends Equatable {
  const TestEntityItem({required this.id, required this.name});

  factory TestEntityItem.fromJson(Map<String, dynamic> json) =>
      TestEntityItem(id: json['id'] as String, name: json['name'] as String);
  final String id;
  final String name;
  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name};

  @override
  List<Object> get props => [id, name];
}

class TestEntity extends Equatable {
  const TestEntity({required this.title, required this.items});

  factory TestEntity.fromJson(Map<String, dynamic> json) => TestEntity(
    title: json['title'] as String,
    items:
        (json['items'] as List<dynamic>)
            .map((e) => TestEntityItem.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  final String title;
  final List<TestEntityItem> items;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'items': items.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object> get props => [title, items];
}

void main() {
  late HiveCacheService cacheService;
  late MockHiveInterface mockHive;
  late MockBox<dynamic> mockBox;

  setUpAll(() {
    registerFallbackValue('fallback-key');
  });

  setUp(() {
    mockHive = MockHiveInterface();
    mockBox = MockBox<dynamic>();

    when(() => mockHive.box<dynamic>('hiveBoxWithTtl')).thenReturn(mockBox);

    cacheService = HiveCacheService(mockHive);
  });

  group('write', () {
    setUp(() {});

    test('should write primitive value to box with TTL', () async {
      // Arrange
      final now = DateTime.now();

      when(
        () => mockBox.put(any<String>(), any<dynamic>()),
      ).thenAnswer((_) async {});
      // Act
      await cacheService.write(key: 'key', value: 'value', ttlHrs: 2);

      // Assert
      final captured =
          verify(() => mockBox.put('key', captureAny<String>())).captured;
      final capturedArg = captured.single as Map<String, dynamic>;
      expect(capturedArg['value'], 'value');

      final expiry = DateTime.parse(capturedArg['expiry'] as String);
      // Verify expiry is roughly 2 hours in the future (with 5 minute tolerance)
      expect(expiry.difference(now).inMinutes, closeTo(2 * 60, 5));
    });

    test('should write Map data', () async {
      // Arrange
      final map = {'key1': 'value1', 'key2': 'value2'};

      when(
        () => mockBox.put(any<String>(), any<dynamic>()),
      ).thenAnswer((_) async {});

      // Act
      await cacheService.write(
        key: 'key',
        value: map,
        encode: (map) => jsonEncode(map),
      );

      // Assert
      final captured =
          verify(() => mockBox.put('key', captureAny<dynamic>())).captured;
      final capturedArg = captured.single as Map<String, dynamic>;

      expect(capturedArg['value'], jsonEncode(map));
    });

    test('should write List of Maps', () async {
      // Arrange
      final list = [
        {'id': 1, 'name': 'Item 1'},
        {'id': 2, 'name': 'Item 2'},
      ];

      when(
        () => mockBox.put(any<String>(), any<dynamic>()),
      ).thenAnswer((_) async {});

      // Act
      await cacheService.write(
        key: 'key',
        value: list,
        encode: (list) => jsonEncode(list),
      );

      // Assert
      final captured =
          verify(() => mockBox.put('key', captureAny<dynamic>())).captured;
      final capturedArg = captured.single as Map<String, dynamic>;
      expect(capturedArg['value'], jsonEncode(list));
    });
    test('should use default TTL when ttlHrs is negative', () async {
      // Arrange
      final now = DateTime.now();

      when(
        () => mockBox.put(any<String>(), any<dynamic>()),
      ).thenAnswer((_) async {});

      // Act
      await cacheService.write(key: 'key', value: 'value', ttlHrs: -2);

      // Assert
      final captured =
          verify(() => mockBox.put('key', captureAny<dynamic>())).captured;
      final capturedArg = captured.single as Map<String, dynamic>;

      final expiry = DateTime.parse(capturedArg['expiry'] as String);
      // Verify expiry is roughly 1 year in the future (with 1 day tolerance)
      expect(expiry.difference(now).inDays, closeTo(365, 1));
    });

    test('should write List of custom objects', () async {
      // Arrange
      final list = [
        const TestEntity(
          title: 'title1',
          items: [TestEntityItem(id: 'id-1', name: 'name1')],
        ),
        const TestEntity(
          title: 'title2',
          items: [TestEntityItem(id: 'id-2', name: 'name2')],
        ),
      ];

      when(
        () => mockBox.put(any<String>(), any<dynamic>()),
      ).thenAnswer((_) async {});

      // Act
      await cacheService.write(
        key: 'key',
        value: list,
        encode: (sections) => list.map((entity) => entity.toJson()).toList(),
      );

      // Assert
      final captured =
          verify(() => mockBox.put('key', captureAny<dynamic>())).captured;
      final capturedArg = captured.single as Map<String, dynamic>;
      expect(
        capturedArg['value'],
        list.map((entity) => entity.toJson()).toList(),
      );
    });
  });
  group('read', () {
    test('should return null when key does not exist', () {
      // Arrange
      when(() => mockBox.get('nonExistentKey')).thenReturn(null);

      // Act
      final result = cacheService.read<String>(key: 'nonExistentKey');

      // Assert
      expect(result, null);
    });

    test('should return value when entry is not expired', () {
      // Arrange
      final expiry = DateTime.now().add(const Duration(hours: 1));
      final entry = CacheEntry<String>(value: 'value', expiry: expiry);

      when(() => mockBox.get('key')).thenReturn(entry.toJson());

      // Act
      final result = cacheService.read<String>(key: 'key');

      // Assert
      expect(result?.value, 'value');
    });

    test('should return custom object', () {
      final list = [
        const TestEntity(
          title: 'title1',
          items: [TestEntityItem(id: 'id-1', name: 'name1')],
        ),
        const TestEntity(
          title: 'title2',
          items: [TestEntityItem(id: 'id-2', name: 'name2')],
        ),
      ];

      // Arrange
      final expiry = DateTime.now().add(const Duration(hours: 1));
      final entry = CacheEntry<List<TestEntity>>(value: list, expiry: expiry);
      final decodedEntryValue = entry.value.map((e) => e.toJson()).toList();
      final decodedEntry = CacheEntry<List<dynamic>>(
        value: decodedEntryValue,
        expiry: expiry,
      );
      when(() => mockBox.get('key')).thenReturn(decodedEntry.toJson());

      // Act
      final result = cacheService.read<List<TestEntity>>(
        key: 'key',
        decode:
            (raw) =>
                (raw as List)
                    .map(
                      (item) => TestEntity.fromJson(
                        (item as Map).map((k, v) => MapEntry(k.toString(), v)),
                      ),
                    )
                    .toList(),
      );

      // Assert
      expect(result?.value, list);
    });
  });

  group('delete', () {
    test('should delete value from box', () async {
      // Arrange
      when(() => mockBox.delete(any<String>())).thenAnswer((_) async {});

      // Act
      await cacheService.delete('key');

      // Assert
      verify(() => mockBox.delete('key')).called(1);
    });
  });

  group('clear', () {
    test('should clear box', () async {
      // Arrange
      when(() => mockBox.clear()).thenAnswer((_) async => 0);

      // Act
      await cacheService.clear();

      // Assert
      verify(() => mockBox.clear()).called(1);
    });
  });
}
