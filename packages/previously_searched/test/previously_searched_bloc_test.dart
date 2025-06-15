import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:previously_searched/previously_searched.dart';
import 'package:previously_searched/src/data/previously_searched_item.dart';
import 'package:previously_searched/src/data/previously_searched_repository.dart';

class MockPreviouslySearchedRepository extends Mock
    implements PreviouslySearchedRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreviouslySearchedBloc Tests', () {
    late MockPreviouslySearchedRepository mockRepository;
    late PreviouslySearchedBloc previouslySearchedBloc;
    late List<PreviouslySearchedItemViewModel> mockPreviouslySearchedViewModels;
    late List<PreviouslySearchedItem> mockPreviouslySearched;
    late CacheEntry<List<PreviouslySearchedItem>> mockCacheEntry;

    setUp(() {
      mockRepository = MockPreviouslySearchedRepository();
      previouslySearchedBloc = PreviouslySearchedBloc(
        searchRepository: mockRepository,
      );
      mockPreviouslySearchedViewModels = [
        const PreviouslySearchedItemViewModel(
          name: 'Grocery & Kitchen',
          iconUrl: 'test',
        ),
        const PreviouslySearchedItemViewModel(
          name: 'Personal Care',
          iconUrl: 'test',
        ),
      ];
      mockPreviouslySearched = [
        const PreviouslySearchedItem(
          searchText: 'Grocery & Kitchen',
          iconUrl: 'test',
        ),
        const PreviouslySearchedItem(
          searchText: 'Personal Care',
          iconUrl: 'test',
        ),
      ];
      final expiry = DateTime.now().add(const Duration(hours: 1));
      mockCacheEntry = CacheEntry(
        value: mockPreviouslySearched,
        expiry: expiry,
      );
    });

    tearDown(() {
      previouslySearchedBloc.close();
    });

    blocTest<PreviouslySearchedBloc, PreviouslySearchedState>(
      'emits [PreviouslySearchedLoading,PreviouslySearchedLoaded] when FetchPreviouslySearched is triggered',
      build: () {
        when(
          mockRepository.loadPreviouslySearched,
        ).thenAnswer((_) async => mockPreviouslySearched);
        when(() => mockRepository.cachedPreviouslySearched).thenReturn(null);
        return previouslySearchedBloc;
      },
      act: (bloc) => bloc.add(FetchPreviouslySearched()),
      expect:
          () => [
            isA<PreviouslySearchedLoading>(),
            isA<PreviouslySearchedLoaded>(),
          ],
    );

    blocTest<PreviouslySearchedBloc, PreviouslySearchedState>(
      'FetchPreviouslySearched transforms previouslySearched to view models',
      build: () {
        when(
          mockRepository.loadPreviouslySearched,
        ).thenAnswer((_) async => mockPreviouslySearched);
        when(() => mockRepository.cachedPreviouslySearched).thenReturn(null);
        return previouslySearchedBloc;
      },
      act: (bloc) => bloc.add(FetchPreviouslySearched()),
      expect:
          () => [
            isA<PreviouslySearchedLoading>(),
            isA<PreviouslySearchedLoaded>(),
          ],
      verify: (bloc) {
        final state = bloc.state as PreviouslySearchedLoaded;
        expect(
          state.previouslySearchedItems[0].name,
          equals(mockPreviouslySearchedViewModels[0].name),
        );
        expect(
          state.previouslySearchedItems[0].iconUrl,
          equals(mockPreviouslySearchedViewModels[0].iconUrl),
        );
        expect(
          state.previouslySearchedItems[1].name,
          equals(mockPreviouslySearchedViewModels[1].name),
        );
      },
    );

    blocTest<PreviouslySearchedBloc, PreviouslySearchedState>(
      'emits [PreviouslySearchedLoading, PreviouslySearchedFailedLoading] when repository fails to load',
      build: () {
        when(
          mockRepository.loadPreviouslySearched,
        ).thenThrow(Exception('Failed to load previouslySearched'));
        when(() => mockRepository.cachedPreviouslySearched).thenReturn(null);
        return previouslySearchedBloc;
      },
      act: (bloc) => bloc.add(FetchPreviouslySearched()),
      expect:
          () => [
            PreviouslySearchedLoading(),
            const PreviouslySearchedFailedLoading(),
          ],
    );

    blocTest<PreviouslySearchedBloc, PreviouslySearchedState>(
      'emits [PreviouslySearchedLoading, PreviouslySearchedFailedLoading] when repository fails to load',
      build: () {
        final expiry = DateTime.now().subtract(const Duration(hours: 5));
        final expiredCache = CacheEntry(
          value: mockPreviouslySearched,
          expiry: expiry,
        );
        when(
          mockRepository.loadPreviouslySearched,
        ).thenThrow(Exception('Failed to load previouslySearched'));
        when(
          () => mockRepository.cachedPreviouslySearched,
        ).thenReturn(expiredCache);
        return previouslySearchedBloc;
      },
      act: (bloc) => bloc.add(FetchPreviouslySearched()),
      expect:
          () => [
            isA<PreviouslySearchedLoading>(),
            isA<PreviouslySearchedFailedLoading>(),
          ],
    );

    blocTest<PreviouslySearchedBloc, PreviouslySearchedState>(
      'emits [PreviouslySearchedLoading, PreviouslySearchedLoaded] when previouslySearched are empty',
      build: () {
        when(mockRepository.loadPreviouslySearched).thenAnswer((_) async => []);
        when(() => mockRepository.cachedPreviouslySearched).thenReturn(null);
        return previouslySearchedBloc;
      },
      act: (bloc) => bloc.add(FetchPreviouslySearched()),
      expect:
          () => [
            PreviouslySearchedLoading(),
            const PreviouslySearchedLoaded(previouslySearchedItems: []),
          ],
    );

    blocTest<PreviouslySearchedBloc, PreviouslySearchedState>(
      'emits [PreviouslySearchedLoaded] when cache exists and valid',
      build: () {
        when(
          mockRepository.loadPreviouslySearched,
        ).thenAnswer((_) async => mockPreviouslySearched);
        when(
          () => mockRepository.cachedPreviouslySearched,
        ).thenReturn(mockCacheEntry);
        return previouslySearchedBloc;
      },
      act: (bloc) => bloc.add(FetchPreviouslySearched()),
      expect: () => [isA<PreviouslySearchedLoaded>()],
    );

    blocTest<PreviouslySearchedBloc, PreviouslySearchedState>(
      'emits [PreviouslySearchedLoading, PreviouslySearchedOffline] when offline and no cache',
      build: () {
        when(
          mockRepository.loadPreviouslySearched,
        ).thenThrow(const SocketException('No Internet'));
        when(() => mockRepository.cachedPreviouslySearched).thenReturn(null);
        return previouslySearchedBloc;
      },
      act: (bloc) => bloc.add(FetchPreviouslySearched()),
      expect:
          () => [
            PreviouslySearchedLoading(),
            const PreviouslySearchedOffline(),
          ],
    );

    blocTest<PreviouslySearchedBloc, PreviouslySearchedState>(
      'emits [PreviouslySearchedLoading, PreviouslySearchedOffline] when offline with expired cache',
      build: () {
        final expiry = DateTime.now().subtract(const Duration(hours: 4));
        final expiredCache = CacheEntry(
          value: mockPreviouslySearched,
          expiry: expiry,
        );
        when(
          mockRepository.loadPreviouslySearched,
        ).thenThrow(const SocketException('No Internet'));
        when(
          () => mockRepository.cachedPreviouslySearched,
        ).thenReturn(expiredCache);
        return previouslySearchedBloc;
      },
      act: (bloc) => bloc.add(FetchPreviouslySearched()),
      expect:
          () => [
            isA<PreviouslySearchedLoading>(),
            isA<PreviouslySearchedOffline>(),
          ],
    );
  });
}
