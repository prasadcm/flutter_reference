import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/categories_repository.dart';
import '../data/category_model.dart';

part 'category_item_event.dart';
part 'category_item_state.dart';

class CategoryItemBloc extends Bloc<CategoryItemEvent, CategoryItemState> {
  final CategoriesRepository categoriesRepository;
  final Random _random = Random();
  List<CategoryModel> _categories = [];

  CategoryItemBloc({required this.categoriesRepository})
      : super(CategoryItemState("")) {
    on<EmitRandomCategoryItem>(_emitRandomCategoryItem);
    _fetchCategories();
  }

  void _emitRandomCategoryItem(
    EmitRandomCategoryItem event,
    Emitter<CategoryItemState> emit,
  ) {
    if (_categories.isNotEmpty) {
      emit(CategoryItemState(
          _categories[_random.nextInt(_categories.length)].name));
    }
  }

  Future<void> _fetchCategories() async {
    try {
      _categories = await categoriesRepository.loadCategories();
    } catch (_) {}
  }
}
