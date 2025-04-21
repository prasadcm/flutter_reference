import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:categories/src/data/categories_repository.dart';
import 'package:categories/src/data/category_section.dart';
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
    final isCacheValid = categoriesRepository.isCacheValid;
    if (cache != null && isCacheValid) {
      emit(CategoriesLoaded(categories: cache));
      return;
    }
    emit(CategoriesLoading());
    try {
      final categoriesList = await categoriesRepository.loadCategories();
      emit(CategoriesLoaded(categories: categoriesList));
    } on SocketException {
      if (cache != null) {
        emit(CategoriesOffline(cachedCategories: cache));
      } else {
        emit(const CategoriesOffline());
      }
    } on Exception {
      emit(CategoriesFailedLoading(cachedCategories: cache));
    }
  }
}
