import 'package:cmp_categories/cmp_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/category_section.dart';
import 'category_section_widget.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesFailedLoading) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Something went wrong")));
        }
      },
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CategoriesLoaded) {
          return _buildCategories(state.getCategories);
        } else {
          return const Center(child: Text("Categories unavailable"));
        }
      },
    );
  }

  Widget _buildCategories(List<CategorySection> sections) {
    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, sectionIndex) {
        return CategorySectionWidget(section: sections[sectionIndex]);
      },
    );
  }
}
