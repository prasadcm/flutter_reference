import 'package:cmp_search_suggestion/cmp_search_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryItemBloc(categoriesRepository: CategoriesRepository()),
      child: ScrollingSearchSuggestion(),
    );
  }
}
