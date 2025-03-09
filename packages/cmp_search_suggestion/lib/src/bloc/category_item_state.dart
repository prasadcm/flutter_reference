part of 'category_item_bloc.dart';

class CategoryItemState extends Equatable {
  final String categoryItem;

  const CategoryItemState(this.categoryItem);

  @override
  List<Object> get props => [categoryItem];
}
