import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search_recommendation/search_recommendation.dart';
import 'package:search_recommendation/src/data/search_recommendation_view_model.dart';

class MockSearchRecommendationBloc extends Mock
    implements SearchRecommendationBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> waitForDelay(WidgetTester tester, Duration duration) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(duration);
    });
  }

  group('ScrollingSearchRecommendation Widget Tests', () {
    late MockSearchRecommendationBloc mockSearchRecommendationBloc;
    late List<SearchRecommendationViewModel> mockSearchRecommendation;
    late StreamController<SearchRecommendationState> stateController;

    setUp(() {
      mockSearchRecommendationBloc = MockSearchRecommendationBloc();
      when(() => mockSearchRecommendationBloc.state)
          .thenReturn(SearchRecommendationInitial());
      stateController = StreamController<SearchRecommendationState>();
      whenListen(
        mockSearchRecommendationBloc,
        stateController.stream,
        initialState: SearchRecommendationInitial(),
      );
      mockSearchRecommendation = [
        const SearchRecommendationViewModel(name: 'Apple'),
        const SearchRecommendationViewModel(name: 'Banana'),
        const SearchRecommendationViewModel(name: 'Cherry'),
      ];
    });

    tearDown(() {
      stateController.close();
    });

    Widget createWidgetUnderTest() {
      return BlocProvider<SearchRecommendationBloc>.value(
        value: mockSearchRecommendationBloc,
        child: const MaterialApp(
          home: Scaffold(
            body: SearchRecommendationView(),
          ),
        ),
      );
    }

    testWidgets(
        'should show recommendations and animate them when state is SearchRecommendationLoaded',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Search for "items"'), findsOneWidget);

      await waitForDelay(tester, Duration.zero);

      stateController.add(
        SearchRecommendationLoaded(
          recommendations: mockSearchRecommendation,
        ),
      );
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
