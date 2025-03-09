import 'package:flutter/material.dart';

class FilterChipList extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  
  const FilterChipList({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == 'All' 
              ? selectedCategory.isEmpty 
              : category == selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              selected: isSelected,
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              checkmarkColor: Theme.of(context).colorScheme.primary,
              label: Text(category),
              onSelected: (selected) {
                if (selected) {
                  onCategorySelected(category);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
