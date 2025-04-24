import 'package:categories/src/data/category_section.dart';
import 'package:categories/src/presentation/category_item_widget.dart';
import 'package:flutter/material.dart';

class CategorySectionWidget extends StatelessWidget {
  const CategorySectionWidget({required this.section, super.key});
  final CategorySection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            section.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 120, // Fixed height for the horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: section.items.length,
            itemBuilder: (context, index) {
              return CategoryItemWidget(item: section.items[index]);
            },
          ),
        ),
        //const Divider(), // Separator between sections
      ],
    );
  }
}
