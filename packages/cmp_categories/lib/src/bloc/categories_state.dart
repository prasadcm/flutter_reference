part of 'categories_bloc.dart';

class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final dynamic _categories;

  const CategoriesLoaded(this._categories);

  List<CategorySection> get getCategories => _categories;

  @override
  List<Object> get props => [_categories];
}

class CategoriesFailedLoading extends CategoriesState {}
