import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search_recommendation/search_recommendation.dart';
import 'package:search_recommendation/src/data/search_recommendation_view_model.dart';

class MockSearchRecommendationRepository extends Mock
    implements SearchRecommendationRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SearchRecommendationBloc Tests', () {
    late MockSearchRecommendationRepository mockRepository;
    late SearchRecommendationBloc recommendationBloc;
    late List<SearchRecommendationModel> mockSearchRecommendation;
    late List<SearchRecommendationViewModel> mockSearchRecommendationViewModel;
    late CacheEntry<List<SearchRecommendationModel>> mockCacheEntry;

    setUp(() {
      mockRepository = MockSearchRecommendationRepository();
      recommendationBloc =
          SearchRecommendationBloc(recommendationRepository: mockRepository);
      mockSearchRecommendation = [
        SearchRecommendationModel(name: 'Apple'),
        SearchRecommendationModel(name: 'Banana'),
      ];
      mockSearchRecommendationViewModel = const [
        SearchRecommendationViewModel(name: 'Apple'),
        SearchRecommendationViewModel(name: 'Banana'),
      ];
      final expiry = DateTime.now().add(const Duration(hours: 1));
      mockCacheEntry =
          CacheEntry(value: mockSearchRecommendation, expiry: expiry);
    });

    tearDown(() {
      recommendationBloc.close();
    });

    blocTest<SearchRecommendationBloc, SearchRecommendationState>(
      'emits [SearchRecommendationLoading,SearchRecommendationLoaded] when FetchSearchRecommendation is triggered',
      build: () {
        when(
          mockRepository.loadSearchRecommendation,
        ).thenAnswer((_) async => mockSearchRecommendation);
        when(() => mockRepository.cachedSearchRecommendation).thenReturn(null);
        return recommendationBloc;
      },
      act: (bloc) => bloc.add(FetchSearchRecommendation()),
      expect: () => [
        isA<SearchRecommendationLoading>(),
        isA<SearchRecommendationLoaded>(),
      ],
    );

    blocTest<SearchRecommendationBloc, SearchRecommendationState>(
      'FetchSearchRecommendation transforms recommendation to view models',
      build: () {
        when(
          mockRepository.loadSearchRecommendation,
        ).thenAnswer((_) async => mockSearchRecommendation);
        when(() => mockRepository.cachedSearchRecommendation).thenReturn(null);
        return recommendationBloc;
      },
      act: (bloc) => bloc.add(FetchSearchRecommendation()),
      expect: () => [
        isA<SearchRecommendationLoading>(),
        isA<SearchRecommendationLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as SearchRecommendationLoaded;
        expect(
          state.recommendations[0].name,
          equals(mockSearchRecommendationViewModel[0].name),
        );
      },
    );

    blocTest<SearchRecommendationBloc, SearchRecommendationState>(
      'emits [SearchRecommendationLoading, SearchRecommendationFailedLoading] when repository fails to load',
      build: () {
        when(
          mockRepository.loadSearchRecommendation,
        ).thenThrow(Exception('Failed to load categories'));
        when(() => mockRepository.cachedSearchRecommendation).thenReturn(null);
        return recommendationBloc;
      },
      act: (bloc) => bloc.add(FetchSearchRecommendation()),
      expect: () => [
        SearchRecommendationLoading(),
        const SearchRecommendationFailedLoading(),
      ],
    );

    blocTest<SearchRecommendationBloc, SearchRecommendationState>(
      'emits [SearchRecommendationLoading, SearchRecommendationFailedLoading] when repository fails to load',
      build: () {
        final expiry = DateTime.now().subtract(const Duration(hours: 5));
        final expiredCache =
            CacheEntry(value: mockSearchRecommendation, expiry: expiry);
        when(
          mockRepository.loadSearchRecommendation,
        ).thenThrow(Exception('Failed to load recommendation'));
        when(() => mockRepository.cachedSearchRecommendation)
            .thenReturn(expiredCache);
        return recommendationBloc;
      },
      act: (bloc) => bloc.add(FetchSearchRecommendation()),
      expect: () => [
        isA<SearchRecommendationLoading>(),
        isA<SearchRecommendationFailedLoading>(),
      ],
    );

    blocTest<SearchRecommendationBloc, SearchRecommendationState>(
      'emits [SearchRecommendationLoading, SearchRecommendationLoaded] when recommendation are empty',
      build: () {
        when(mockRepository.loadSearchRecommendation)
            .thenAnswer((_) async => []);
        when(() => mockRepository.cachedSearchRecommendation).thenReturn(null);
        return recommendationBloc;
      },
      act: (bloc) => bloc.add(FetchSearchRecommendation()),
      expect: () => [
        SearchRecommendationLoading(),
        const SearchRecommendationLoaded(recommendations: []),
      ],
    );

    blocTest<SearchRecommendationBloc, SearchRecommendationState>(
      'emits [SearchRecommendationLoaded] when cache exists and valid',
      build: () {
        when(
          mockRepository.loadSearchRecommendation,
        ).thenAnswer((_) async => mockSearchRecommendation);
        when(() => mockRepository.cachedSearchRecommendation)
            .thenReturn(mockCacheEntry);
        return recommendationBloc;
      },
      act: (bloc) => bloc.add(FetchSearchRecommendation()),
      expect: () => [isA<SearchRecommendationLoaded>()],
    );

    blocTest<SearchRecommendationBloc, SearchRecommendationState>(
      'emits [SearchRecommendationLoading, SearchRecommendationOffline] when offline and no cache',
      build: () {
        when(
          mockRepository.loadSearchRecommendation,
        ).thenThrow(const SocketException('No Internet'));
        when(() => mockRepository.cachedSearchRecommendation).thenReturn(null);
        return recommendationBloc;
      },
      act: (bloc) => bloc.add(FetchSearchRecommendation()),
      expect: () =>
          [SearchRecommendationLoading(), const SearchRecommendationOffline()],
    );

    blocTest<SearchRecommendationBloc, SearchRecommendationState>(
      'emits [SearchRecommendationLoading, SearchRecommendationOffline] when offline with expired cache',
      build: () {
        final expiry = DateTime.now().subtract(const Duration(hours: 4));
        final expiredCache =
            CacheEntry(value: mockSearchRecommendation, expiry: expiry);
        when(
          mockRepository.loadSearchRecommendation,
        ).thenThrow(const SocketException('No Internet'));
        when(() => mockRepository.cachedSearchRecommendation)
            .thenReturn(expiredCache);
        return recommendationBloc;
      },
      act: (bloc) => bloc.add(FetchSearchRecommendation()),
      expect: () => [
        isA<SearchRecommendationLoading>(),
        isA<SearchRecommendationOffline>(),
      ],
    );
  });
}
