import 'package:categories/categories.dart';
import 'package:categories/src/data/category_section.dart';
import 'package:categories/src/presentation/category_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_components/ui_components.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = categoryLocator<CategoriesBloc>();

    return BlocConsumer<CategoriesBloc, CategoriesState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is CategoriesFailedLoading) {
          ToastMessage.show(context, 'Something went wrong. Try again!');
        }
      },
      builder: (context, state) {
        switch (state) {
          case CategoriesOffline():
            final sections = state.getCachedCategories;
            return Stack(
              children: [
                sections.isNotEmpty
                    ? _buildCategories(sections)
                    : const OfflineView(), // Still show categories
                if (sections.isNotEmpty) const OfflineBar(), // Show offline bar
              ],
            );
          case CategoriesLoaded():
            return _buildCategories(state.getCategories);
          case CategoriesLoading():
            return const LoadingView();
          case CategoriesFailedLoading():
            final sections = state.getCachedCategories;
            if (sections.isNotEmpty) {
              return _buildCategories(sections);
            } else {
              return const ErrorView(
                title: 'Unable to show categories',
                subtitle: 'Please try again!',
              );
            }
          default:
            return const InitialView();
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
