import 'package:bloc_test/bloc_test.dart';
import 'package:categories/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:reference/app.dart';
import 'package:reference/features/categories/screens/category_screen.dart';
import 'package:reference/features/profile/widgets/profile_screen.dart';
import 'package:reference/routing/main_screen.dart';

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

void main() {
  group('ReferenceApp Tests', () {
    setUp(() {});

    testWidgets('should render ReferenceApp with initial route',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ReferenceApp(),
      );

      // Verify initial route is loaded
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('should show Profile page', (WidgetTester tester) async {
      await tester.pumpWidget(
        ReferenceApp(),
      );

      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Verify initial route is loaded
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('should show Categories page', (WidgetTester tester) async {
      final mockCategoriesBloc = MockCategoriesBloc();

      whenListen(
        mockCategoriesBloc,
        Stream.fromIterable([CategoriesLoaded(categories: [])]),
        initialState: CategoriesLoading(),
      );

      await tester.pumpWidget(
        ReferenceApp(),
      );

      GetIt.instance.registerFactory<CategoriesBloc>(() => mockCategoriesBloc);

      await tester.tap(find.byIcon(Icons.category));
      await tester.pumpAndSettle();

      // Verify initial route is loaded
      expect(find.byType(CategoryScreen), findsOneWidget);

      GetIt.instance.reset();
    });
  });
}
