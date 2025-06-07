import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suggestions/src/data/suggestion_view_model.dart';
import 'package:suggestions/suggestions.dart';

class MockSuggestionsRepository extends Mock implements SuggestionsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CategoriesBloc Tests', () {
    late MockSuggestionsRepository mockRepository;
    late SuggestionsBloc suggestionsBloc;
    late List<SuggestionModel> mockSuggestions;
    late List<SuggestionViewModel> mockSuggestionsViewModel;
    late CacheEntry<List<SuggestionModel>> mockCacheEntry;

    setUp(() {
      mockRepository = MockSuggestionsRepository();
      suggestionsBloc = SuggestionsBloc(suggestionsRepository: mockRepository);
      mockSuggestions = [
        SuggestionModel(name: 'Apple', id: '1'),
        SuggestionModel(name: 'Banana', id: '2'),
      ];
      mockSuggestionsViewModel = const [
        SuggestionViewModel(name: 'Apple'),
        SuggestionViewModel(name: 'Banana'),
      ];
      final expiry = DateTime.now().add(const Duration(hours: 1));
      mockCacheEntry = CacheEntry(value: mockSuggestions, expiry: expiry);
    });

    tearDown(() {
      suggestionsBloc.close();
    });

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoading,SuggestionsLoaded] when FetchSuggestions is triggered',
      build: () {
        when(
          mockRepository.loadSuggestions,
        ).thenAnswer((_) async => mockSuggestions);
        when(() => mockRepository.cachedSuggestions).thenReturn(null);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [isA<SuggestionsLoading>(), isA<SuggestionsLoaded>()],
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'FetchSuggestions transforms suggestions to view models',
      build: () {
        when(
          mockRepository.loadSuggestions,
        ).thenAnswer((_) async => mockSuggestions);
        when(() => mockRepository.cachedSuggestions).thenReturn(null);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [isA<SuggestionsLoading>(), isA<SuggestionsLoaded>()],
      verify: (bloc) {
        final state = bloc.state as SuggestionsLoaded;
        expect(
          state.suggestions[0].name,
          equals(mockSuggestionsViewModel[0].name),
        );
      },
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoading, SuggestionsFailedLoading] when repository fails to load',
      build: () {
        when(
          mockRepository.loadSuggestions,
        ).thenThrow(Exception('Failed to load categories'));
        when(() => mockRepository.cachedSuggestions).thenReturn(null);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [SuggestionsLoading(), const SuggestionsFailedLoading()],
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoading, SuggestionsFailedLoading] when repository fails to load',
      build: () {
        final expiry = DateTime.now().subtract(const Duration(hours: 5));
        final expiredCache = CacheEntry(value: mockSuggestions, expiry: expiry);
        when(
          mockRepository.loadSuggestions,
        ).thenThrow(Exception('Failed to load suggestions'));
        when(() => mockRepository.cachedSuggestions).thenReturn(expiredCache);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () =>
          [isA<SuggestionsLoading>(), isA<SuggestionsFailedLoading>()],
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoading, SuggestionsLoaded] when suggestions are empty',
      build: () {
        when(mockRepository.loadSuggestions).thenAnswer((_) async => []);
        when(() => mockRepository.cachedSuggestions).thenReturn(null);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () =>
          [SuggestionsLoading(), const SuggestionsLoaded(suggestions: [])],
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoaded] when cache exists and valid',
      build: () {
        when(
          mockRepository.loadSuggestions,
        ).thenAnswer((_) async => mockSuggestions);
        when(() => mockRepository.cachedSuggestions).thenReturn(mockCacheEntry);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [isA<SuggestionsLoaded>()],
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoading, SuggestionsOffline] when offline and no cache',
      build: () {
        when(
          mockRepository.loadSuggestions,
        ).thenThrow(const SocketException('No Internet'));
        when(() => mockRepository.cachedSuggestions).thenReturn(null);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [SuggestionsLoading(), const SuggestionsOffline()],
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoading, SuggestionsOffline] when offline with expired cache',
      build: () {
        final expiry = DateTime.now().subtract(const Duration(hours: 4));
        final expiredCache = CacheEntry(value: mockSuggestions, expiry: expiry);
        when(
          mockRepository.loadSuggestions,
        ).thenThrow(const SocketException('No Internet'));
        when(() => mockRepository.cachedSuggestions).thenReturn(expiredCache);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [isA<SuggestionsLoading>(), isA<SuggestionsOffline>()],
    );
  });
}
