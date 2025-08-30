import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final bool isExpense;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.isExpense = true,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final bool isSelected = widget.selectedCategory == category;
          final Color primaryColor = widget.isExpense 
              ? const Color(0xFFFD3C4A) 
              : const Color(0xFF00A86B);

          return GestureDetector(
            onTap: () => widget.onCategoryChanged(category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.shade300,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryColor.withAlpha(51),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getCategoryIcon(category),
                    color: isSelected ? Colors.white : primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF0D0E0F),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
        return Icons.receipt;
      case 'healthcare':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      case 'other':
        return Icons.category;
      default:
        return Icons.help_outline;
    }
  }
}

// Chip-style Category Selector (Alternative Design)
class CategoryChipSelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final bool isExpense;

  const CategoryChipSelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.isExpense = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = isExpense 
        ? const Color(0xFFFD3C4A) 
        : const Color(0xFF00A86B);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final bool isSelected = selectedCategory == category;
        return FilterChip(
          selected: isSelected,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getCategoryIcon(category),
                size: 16,
                color: isSelected ? Colors.white : primaryColor,
              ),
              const SizedBox(width: 6),
              Text(category),
            ],
          ),
          onSelected: (selected) {
            if (selected) {
              onCategoryChanged(category);
            }
          },
          backgroundColor: Colors.white,
          selectedColor: primaryColor,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF0D0E0F),
            fontWeight: FontWeight.w500,
          ),
          side: BorderSide(
            color: isSelected ? primaryColor : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }).toList(),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
        return Icons.receipt;
      case 'healthcare':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      case 'other':
        return Icons.category;
      default:
        return Icons.help_outline;
    }
  }
}

// Grid Category Selector (Alternative Design)
class CategoryGridSelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final bool isExpense;

  const CategoryGridSelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.isExpense = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = isExpense 
        ? const Color(0xFFFD3C4A) 
        : const Color(0xFF00A86B);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final bool isSelected = selectedCategory == category;

        return GestureDetector(
          onTap: () => onCategoryChanged(category),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey.shade300,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected 
                      ? primaryColor.withAlpha(51) 
                      : Colors.black.withAlpha(13),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getCategoryIcon(category),
                  color: isSelected ? Colors.white : primaryColor,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF0D0E0F),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
        return Icons.receipt;
      case 'healthcare':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      case 'other':
        return Icons.category;
      default:
        return Icons.help_outline;
    }
  }
}
