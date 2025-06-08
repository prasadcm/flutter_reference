import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:categories/src/data/categories_repository.dart';
import 'package:categories/src/data/category_item_view_model.dart';
import 'package:categories/src/data/category_section.dart';
import 'package:categories/src/data/category_section_view_model.dart';
import 'package:equatable/equatable.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({required this.categoriesRepository})
    : super(CategoriesInitial()) {
    on<FetchCategories>(_fetchCategories);
  }
  final CategoriesRepository categoriesRepository;

  Future<void> _fetchCategories(
    FetchCategories event,
    Emitter<CategoriesState> emit,
  ) async {
    final cache = categoriesRepository.cachedCategories;
    if (cache != null && cache.isExpired == false) {
      emit(CategoriesLoaded(categories: _transform(cache.value)));
      return;
    }
    emit(CategoriesLoading());
    try {
      final categoriesList = await categoriesRepository.loadCategories();
      emit(CategoriesLoaded(categories: _transform(categoriesList)));
    } on SocketException {
      if (cache != null) {
        emit(CategoriesOffline(cachedCategories: _transform(cache.value)));
      } else {
        emit(const CategoriesOffline());
      }
    } on Exception {
      emit(
        CategoriesFailedLoading(
          cachedCategories: _transform(cache?.value ?? []),
        ),
      );
    }
  }

  List<CategorySectionViewModel> _transform(List<CategorySection> categories) {
    return categories
        .map(
          (section) => CategorySectionViewModel(
            title: section.title,
            items:
                section.items
                    .map(
                      (item) => CategoryItemViewModel(
                        id: item.id,
                        name: item.name,
                        imageUrl: item.imageUrl,
                        sequence: item.sequence,
                      ),
                    )
                    .toList(),
            sequence: section.sequence,
          ),
        )
        .toList();
  }
}
