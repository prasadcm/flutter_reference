import 'package:bloc/bloc.dart';

import '../data/categories_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoriesRepository categoriesRepository;

  CategoryBloc({required this.categoriesRepository}) : super(CategoryInit()) {
    on<FetchCategory>(_onFetchCategory);
  }

  Future<void> _onFetchCategory(
    FetchCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final categories = categoriesRepository.getCategories();
      emit(CategoryLoaded(categories));
    } catch (_) {
      emit(CategoryFailure());
    }
  }
}
