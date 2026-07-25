import 'package:flutter/material.dart';

import '../../domain/entities/news_feed.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  final NewsCategory selectedCategory;
  final ValueChanged<NewsCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: NewsCategory.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = NewsCategory.values[index];

          return ChoiceChip(
            label: Text(category.displayName),
            selected: category == selectedCategory,
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}
