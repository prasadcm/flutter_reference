import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suggestions/src/data/suggestion_view_model.dart';
import 'package:suggestions/suggestions.dart';

class MockSuggestionsBloc extends Mock implements SuggestionsBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> waitForDelay(WidgetTester tester, Duration duration) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(duration);
    });
  }

  group('ScrollingSearchSuggestion Widget Tests', () {
    late MockSuggestionsBloc mockSuggestionsBloc;
    late List<SuggestionViewModel> mockSuggestions;
    late StreamController<SuggestionsState> stateController;

    setUp(() {
      mockSuggestionsBloc = MockSuggestionsBloc();
      when(() => mockSuggestionsBloc.state).thenReturn(SuggestionsInitial());
      stateController = StreamController<SuggestionsState>();
      whenListen(
        mockSuggestionsBloc,
        stateController.stream,
        initialState: SuggestionsInitial(),
      );
      mockSuggestions = [
        const SuggestionViewModel(name: 'Apple'),
        const SuggestionViewModel(name: 'Banana'),
        const SuggestionViewModel(name: 'Cherry'),
      ];
    });

    tearDown(() {
      stateController.close();
    });

    Widget createWidgetUnderTest() {
      return BlocProvider<SuggestionsBloc>.value(
        value: mockSuggestionsBloc,
        child: const MaterialApp(
          home: Scaffold(
            body: ScrollingSearchSuggestion(),
          ),
        ),
      );
    }

    testWidgets(
        'should show suggestions and animate them when state is SuggestionsLoaded',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Search for "items"'), findsOneWidget);

      await waitForDelay(tester, Duration.zero);

      stateController.add(SuggestionsLoaded(suggestions: mockSuggestions));
      await tester.pump();

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
