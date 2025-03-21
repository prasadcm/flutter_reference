import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:cmp_search_suggestion/cmp_search_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cmp_search_suggestion_test.mocks.dart';

@GenerateMocks([SuggestionsRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> waitForDelay(WidgetTester tester, Duration duration) async {
    await tester.runAsync(() async {
      await Future.delayed(duration);
    });
  }

  group('SuggestionsBloc Tests', () {
    late MockSuggestionsRepository mockRepository;
    late SuggestionsBloc suggestionBloc;
    late List<SuggestionModel> mockSuggestions;

    setUp(() {
      mockRepository = MockSuggestionsRepository();
      suggestionBloc = SuggestionsBloc(suggestionsRepository: mockRepository);
      mockSuggestions = [
        SuggestionModel("1", "Apple"),
        SuggestionModel("2", "Banana"),
      ];
    });

    tearDown(() {
      suggestionBloc.close();
    });

    blocTest<SuggestionsBloc, SuggestionsState>(
        'emits [SuggestionsLoading, SuggestionsLoaded] when FetchSuggestions is triggered',
        build: () {
          when(mockRepository.loadSuggestions())
              .thenAnswer((_) async => mockSuggestions);
          return suggestionBloc;
        },
        act: (bloc) => bloc.add(FetchSuggestions()),
        expect: () => [
              SuggestionsLoading(),
              SuggestionsLoaded(["Apple", "Banana"])
            ]);

    blocTest<SuggestionsBloc, SuggestionsState>(
        'emits [SuggestionsLoading, SuggestionsFailedLoading] when repository fails to load',
        build: () {
          when(mockRepository.loadSuggestions())
              .thenThrow(Exception('Failed to load suggestions'));
          return suggestionBloc;
        },
        act: (bloc) => bloc.add(FetchSuggestions()),
        expect: () => [SuggestionsLoading(), SuggestionsFailedLoading()]);

    blocTest<SuggestionsBloc, SuggestionsState>(
        'emits [SuggestionsLoading, SuggestionsLoaded] when suggestions are empty',
        build: () {
          when(mockRepository.loadSuggestions()).thenAnswer((_) async => []);
          return suggestionBloc;
        },
        act: (bloc) => bloc.add(FetchSuggestions()),
        expect: () => [SuggestionsLoading(), SuggestionsLoaded([])]);
  });

  group('SuggestionsRepository Tests with data', () {
    late SuggestionsRepository repository;

    setUp(() {
      // Register mock asset bundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) {
        const String mockJsonData = '''
        [
          { "id": "0", "name": "Biscuits" },
          { "id": "1", "name": "Orange" },
          { "id": "2", "name": "Eggs" },
          { "id": "3", "name": "Milk" }
        ]
        ''';
        final bytes = Uint8List.fromList(mockJsonData.codeUnits);
        return Future.value(ByteData.view(bytes.buffer));
      });
      repository = const SuggestionsRepository();
    });

    tearDown(() {
      // Un register mock asset bundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });

    test('loadSuggestions should return list of SuggestionModel', () async {
      final suggestions = await repository.loadSuggestions();

      // Verify the result is a list of SuggestionModel
      expect(suggestions, isA<List<SuggestionModel>>());
      expect(suggestions.length, 4);

      // Verify the first suggestion
      expect(suggestions[0].id, '0');
      expect(suggestions[0].name, 'Biscuits');

      // Verify the second suggestion
      expect(suggestions[1].id, '1');
      expect(suggestions[1].name, 'Orange');
    });
  });

  group('ScrollingSearchSuggestion Widget Tests', () {
    late MockSuggestionsRepository mockRepository;
    late SuggestionsBloc suggestionBloc;
    late List<SuggestionModel> mockSuggestions;

    setUp(() {
      mockRepository = MockSuggestionsRepository();
      suggestionBloc = SuggestionsBloc(suggestionsRepository: mockRepository);
      mockSuggestions = [
        SuggestionModel("0", "Apple"),
        SuggestionModel("1", "Banana"),
        SuggestionModel("2", "Cherry"),
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
      when(mockRepository.loadSuggestions())
          .thenAnswer((_) async => mockSuggestions);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Search for "items"'), findsOneWidget);

      await waitForDelay(tester, const Duration(milliseconds: 0));

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
