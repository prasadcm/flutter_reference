import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suggestions/suggestions.dart';

class MockSuggestionsRepository extends Mock implements SuggestionsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CategoriesBloc Tests', () {
    late MockSuggestionsRepository mockRepository;
    late SuggestionsBloc suggestionsBloc;
    late List<String> mockSuggestions;

    setUp(() {
      mockRepository = MockSuggestionsRepository();
      suggestionsBloc = SuggestionsBloc(suggestionsRepository: mockRepository);
      mockSuggestions = ['Apple', 'Banana'];
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
        when(() => mockRepository.isCacheValid).thenReturn(false);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [
        SuggestionsLoading(),
        SuggestionsLoaded(suggestions: mockSuggestions),
      ],
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoading, SuggestionsFailedLoading] when repository fails to load',
      build: () {
        when(
          mockRepository.loadSuggestions,
        ).thenThrow(Exception('Failed to load categories'));
        when(() => mockRepository.cachedSuggestions).thenReturn(null);
        when(() => mockRepository.isCacheValid).thenReturn(false);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [SuggestionsLoading(), const SuggestionsFailedLoading()],
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoading, SuggestionsFailedLoading] when repository fails to load but expired cache exists',
      build: () {
        when(
          mockRepository.loadSuggestions,
        ).thenThrow(Exception('Failed to load categories'));
        when(() => mockRepository.cachedSuggestions)
            .thenReturn(mockSuggestions);
        when(() => mockRepository.isCacheValid).thenReturn(false);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [
        SuggestionsLoading(),
        SuggestionsFailedLoading(cachedSuggestions: mockSuggestions),
      ],
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoading, SuggestionsLoaded] when suggestions are empty',
      build: () {
        when(mockRepository.loadSuggestions).thenAnswer((_) async => []);
        when(() => mockRepository.cachedSuggestions).thenReturn(null);
        when(() => mockRepository.isCacheValid).thenReturn(false);
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
        when(() => mockRepository.cachedSuggestions)
            .thenReturn(mockSuggestions);
        when(() => mockRepository.isCacheValid).thenReturn(true);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [SuggestionsLoaded(suggestions: mockSuggestions)],
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoading, SuggestionsOffline] when offline and no cache',
      build: () {
        when(
          mockRepository.loadSuggestions,
        ).thenThrow(const SocketException('No Internet'));
        when(() => mockRepository.cachedSuggestions).thenReturn(null);
        when(() => mockRepository.isCacheValid).thenReturn(false);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [SuggestionsLoading(), const SuggestionsOffline()],
    );

    blocTest<SuggestionsBloc, SuggestionsState>(
      'emits [SuggestionsLoading, SuggestionsOffline] when offline with expired cache',
      build: () {
        when(
          mockRepository.loadSuggestions,
        ).thenThrow(const SocketException('No Internet'));
        when(() => mockRepository.cachedSuggestions)
            .thenReturn(mockSuggestions);
        when(() => mockRepository.isCacheValid).thenReturn(false);
        return suggestionsBloc;
      },
      act: (bloc) => bloc.add(FetchSuggestions()),
      expect: () => [
        SuggestionsLoading(),
        SuggestionsOffline(cachedSuggestions: mockSuggestions),
      ],
    );
  });
}
