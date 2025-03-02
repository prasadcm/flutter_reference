import 'package:cmp_animated_search/src/bloc/category_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category_bloc.dart';
import '../bloc/category_state.dart';
import '../data/categories_repository.dart';

class AnimatedSearch extends StatelessWidget {
  const AnimatedSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryBloc(categoriesRepository: CategoriesRepository())
            ..add(FetchCategory()),
      child: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          return ListView.builder(
            itemCount:
                (state is CategoryLoaded) ? state.getCategories.length : 0,
            itemBuilder: (context, index) {
              if (state is CategoryLoaded) {
                return ListTile(
                  title: Text(state.getCategories[index].name),
                  subtitle: Text(state.getCategories[index].icon),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      ),
    );
  }
}
