import 'package:categories/categories.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    categoryLocator<CategoriesBloc>().add(FetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: const CategoryView(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Center(
        child: Text(
          'All Categories',
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ),
      ],
    );
  }
}
