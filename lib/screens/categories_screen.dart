import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../model/category.dart';
import 'add_edit_category_sheet.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF534AB7),
        centerTitle: true,
        title: const Text("Categories", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showCategorySheet(context),
          ),
        ],
      ),

      /// BODY
      body: Consumer<CategoryProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _section("DEFAULT CATEGORIES"),

                /// DEFAULT CATEGORIES GRID
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.defaultCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (_, i) {
                    final cat = provider.defaultCategories[i];
                    return _defaultCard(cat);
                  },
                ),

                const SizedBox(height: 10),

                _section("CUSTOM CATEGORIES"),

                /// CUSTOM LIST
                ...provider.customCategories.map(
                      (cat) => _customCard(context, cat),
                ),

                const SizedBox(height: 10),

                /// ADD BUTTON
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD3D1C7)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _showCategorySheet(context),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "+ Add custom category",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// SECTION TITLE
  Widget _section(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF888780),
        ),
      ),
    );
  }

  /// DEFAULT CATEGORY CARD
  Widget _defaultCard(CategoryModel cat) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD3D1C7), width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          /// ICON FIX (NONE SUPPORT)
          cat.icon == 'none'
              ? Icon(Icons.category, size: 20, color: cat.color)
              : Text(cat.icon, style: const TextStyle(fontSize: 20)),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              cat.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const Icon(Icons.lock, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  /// CUSTOM CATEGORY CARD
  Widget _customCard(BuildContext context, CategoryModel cat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD3D1C7), width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        /// ICON FIX (NONE SUPPORT)
        leading: CircleAvatar(
          backgroundColor: cat.color.withOpacity(0.2),
          child: cat.icon == 'none'
              ? Icon(Icons.category, color: cat.color)
              : Text(cat.icon),
        ),

        title: Text(cat.name),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              child: const Text("Edit"),
              onPressed: () => _showCategorySheet(context, category: cat),
            ),

            TextButton(
              child: const Text("Del", style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<CategoryProvider>().deleteCategory(cat.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// BOTTOM SHEET
  void _showCategorySheet(BuildContext context, {CategoryModel? category}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<CategoryProvider>(),
        child: AddEditCategorySheet(category: category),
      ),
    );
  }
}
