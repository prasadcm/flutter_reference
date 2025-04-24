import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suggestions/suggestions.dart';

class MockSuggestionsRepository extends Mock implements SuggestionsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> waitForDelay(WidgetTester tester, Duration duration) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(duration);
    });
  }

  group('ScrollingSearchSuggestion Widget Tests', () {
    late MockSuggestionsRepository mockRepository;
    late SuggestionsBloc suggestionBloc;
    late List<String> mockSuggestions;

    setUp(() {
      mockRepository = MockSuggestionsRepository();
      suggestionBloc = SuggestionsBloc(suggestionsRepository: mockRepository);
      mockSuggestions = [
        'Apple',
        'Banana',
        'Cherry',
      ];
    });

    tearDown(() {
      suggestionBloc.close();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<SuggestionsBloc>.value(
          value: suggestionBloc,
          child: const Scaffold(
            body: ScrollingSearchSuggestion(),
          ),
        ),
      );
    }

    testWidgets(
        'should show suggestions and animate them when state is SuggestionsLoaded',
        (WidgetTester tester) async {
      when(() => mockRepository.loadSuggestions())
          .thenAnswer((_) async => mockSuggestions);
      when(() => mockRepository.cachedSuggestions).thenReturn(null);
      when(() => mockRepository.isCacheValid).thenReturn(false);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Search for "items"'), findsOneWidget);

      await waitForDelay(tester, Duration.zero);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('Search for "Apple"'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('Search for "Banana"'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('Search for "Cherry"'), findsOneWidget);
    });
  });
}
