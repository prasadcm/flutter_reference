import 'package:bloc_test/bloc_test.dart';
import 'package:categories/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reference/app.dart';
import 'package:reference/features/categories/screens/category_screen.dart';
import 'package:reference/features/profile/widgets/profile_screen.dart';
import 'package:reference/features/search/screens/search_screen.dart';
import 'package:reference/routing/main_screen.dart';
import 'package:suggestions/suggestions.dart';

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

class MockSuggestionsBloc extends MockBloc<SuggestionsEvent, SuggestionsState>
    implements SuggestionsBloc {}

void main() {
  final getIt = GetIt.instance;

  group('ReferenceApp Tests', () {
    late MockSuggestionsBloc mockSuggestionsBloc;
    late MockCategoriesBloc mockCategoriesBloc;

    setUp(() {
      mockSuggestionsBloc = MockSuggestionsBloc();
      mockCategoriesBloc = MockCategoriesBloc();
      getIt.registerSingleton<SuggestionsBloc>(mockSuggestionsBloc);
      getIt.registerSingleton<CategoriesBloc>(mockCategoriesBloc);
      when(() => mockSuggestionsBloc.state).thenReturn(SuggestionsInitial());
      when(() => mockCategoriesBloc.state).thenReturn(CategoriesInitial());
    });

    tearDown(() {
      getIt.reset();
    });

    testWidgets('should render ReferenceApp with initial route',
        (WidgetTester tester) async {
      whenListen(
        mockSuggestionsBloc,
        Stream.fromIterable([SuggestionsLoaded(suggestions: [])]),
        initialState: SuggestionsLoading(),
      );
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
      when(() => mockCategoriesBloc.state).thenReturn(CategoriesInitial());

      whenListen(
        mockCategoriesBloc,
        Stream.fromIterable([CategoriesLoaded(categories: [])]),
        initialState: CategoriesLoading(),
      );

      await tester.pumpWidget(
        ReferenceApp(),
      );

      await tester.tap(find.byIcon(Icons.category));
      await tester.pumpAndSettle();

      // Verify initial route is loaded
      expect(find.byType(CategoryScreen), findsOneWidget);
    });
  });

  group('HomeScreen Navigation Tests', () {
    late MockSuggestionsBloc mockSuggestionsBloc;
    late MockCategoriesBloc mockCategoriesBloc;

    setUp(() {
      mockSuggestionsBloc = MockSuggestionsBloc();
      mockCategoriesBloc = MockCategoriesBloc();
      getIt.registerSingleton<SuggestionsBloc>(mockSuggestionsBloc);
      getIt.registerSingleton<CategoriesBloc>(mockCategoriesBloc);
      when(() => mockSuggestionsBloc.state).thenReturn(SuggestionsInitial());
      when(() => mockCategoriesBloc.state).thenReturn(CategoriesInitial());
    });

    tearDown(() {
      getIt.reset();
    });

    testWidgets(
        'should navigate to SearchScreen when ScrollingSearchSuggestion is tapped',
        (WidgetTester tester) async {
      whenListen(
        mockSuggestionsBloc,
        Stream.fromIterable([SuggestionsLoaded(suggestions: [])]),
        initialState: SuggestionsLoading(),
      );
      await tester.pumpWidget(
        ReferenceApp(),
      );

      // Verify initial route is loaded
      expect(find.byType(MainScreen), findsOneWidget);

      // Tap on the ScrollingSearchSuggestion widget
      await tester.tap(find.byType(ScrollingSearchSuggestion));
      await tester.pumpAndSettle();

      // Verify navigation to SearchScreen
      expect(find.byType(SearchScreen), findsOneWidget);
    });
  });
}
