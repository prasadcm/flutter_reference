part of 'categories_bloc.dart';

class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded({required this.categories});
  final List<CategorySectionViewModel> categories;

  List<CategorySectionViewModel> get getCategories => categories;

  @override
  List<Object> get props => [categories];
}

class EmptyCategories extends CategoriesState {}

class CategoriesFailedLoading extends CategoriesState {
  const CategoriesFailedLoading({this.cachedCategories});
  final List<CategorySectionViewModel>? cachedCategories;

  List<CategorySectionViewModel> get getCachedCategories =>
      cachedCategories ?? [];

  @override
  List<Object> get props => [cachedCategories ?? []];
}

class CategoriesOffline extends CategoriesState {
  const CategoriesOffline({this.cachedCategories});
  final List<CategorySectionViewModel>? cachedCategories;

  List<CategorySectionViewModel> get getCachedCategories =>
      cachedCategories ?? [];

  @override
  List<Object> get props => [cachedCategories ?? []];
}
