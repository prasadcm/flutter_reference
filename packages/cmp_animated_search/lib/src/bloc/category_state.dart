import 'package:equatable/equatable.dart';

import '../data/category_model.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> _categories;

  const CategoryLoaded(this._categories);

  List<CategoryModel> get getCategories => _categories;

  @override
  List<Object> get props => [_categories];
}

class CategoryInit extends CategoryState {}

class CategoryFailure extends CategoryState {}
