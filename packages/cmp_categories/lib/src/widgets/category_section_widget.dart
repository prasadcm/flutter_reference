import 'package:flutter/material.dart';

import '../data/category_section.dart';
import 'category_item_widget.dart';

class CategorySectionWidget extends StatelessWidget {
  final CategorySection section;

  const CategorySectionWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            section.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 160, // Fixed height for the horizontal list
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
