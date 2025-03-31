import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/categories_repository.dart';
import '../data/category_item.dart';
import '../data/category_model.dart';
import '../data/category_section.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository categoriesRepository;

  CategoriesBloc({required this.categoriesRepository})
    : super(CategoriesInitial()) {
    on<FetchCategories>(_fetchCategories);
  }

  Future<void> _fetchCategories(
    FetchCategories event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoading());
    try {
      List<CategoryModel> categoriesList =
          await categoriesRepository.loadCategories();
      if (categoriesList.isNotEmpty) {
        emit(CategoriesLoaded(convertToSections(categoriesList)));
      } else {
        emit(CategoriesLoaded([]));
      }
    } catch (e) {
      emit(CategoriesFailedLoading());
    }
  }

  List<CategorySection> convertToSections(List<CategoryModel> categories) {
    Map<String, List<CategoryModel>> groupedCategories = {};

    for (var category in categories) {
      groupedCategories.putIfAbsent(category.name, () => []).add(category);
    }

    // Convert to CategorySection list
    return groupedCategories.entries.map((entry) {
      return CategorySection(
        title: entry.key,
        items:
            entry.value
                .map(
                  (category) => CategoryItem(
                    id: category.category_id,
                    name: category.item,
                    imageUrl: category.image,
                  ),
                )
                .toList(),
      );
    }).toList();
  }
}
