import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/category.dart';
import '../providers/category_provider.dart';

class AddEditCategorySheet extends StatefulWidget {
  final CategoryModel? category;

  const AddEditCategorySheet({super.key, this.category});

  @override
  State<AddEditCategorySheet> createState() => _AddEditCategorySheetState();
}

class _AddEditCategorySheetState extends State<AddEditCategorySheet> {
  late TextEditingController _nameCtrl;

  late String _icon;

  late Color _color;

  /// ICONS
  final List<String> icons = [
    'none',

    '🍔',
    '🛒',
    '✈️',
    '🏠',
    '💼',
    '💰',
    '🚗',
    '🎬',
    '🎵',
    '📚',
    '🏋️',
    '💡',
    '📸',
    '🎮',
  ];

  /// COLORS
  final List<Color> colors = [
    const Color(0xFF5B4DCC),

    Colors.green,

    Colors.orange,

    Colors.red,

    Colors.blue,

    Colors.teal,

    Colors.pink,

    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();

    _nameCtrl = TextEditingController(text: widget.category?.name ?? '');

    _icon = widget.category?.icon ?? 'none';

    _color = widget.category?.color ?? colors.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,

        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// TOP BAR
            Center(
              child: Container(
                width: 50,
                height: 5,

                decoration: BoxDecoration(
                  color: Colors.grey.shade300,

                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            Text(
              widget.category == null ? "Add Category" : "Edit Category",

              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// CATEGORY NAME
            TextField(
              controller: _nameCtrl,

              decoration: InputDecoration(
                labelText: "Category Name",

                hintText: "e.g Salary, Freelance",

                filled: true,

                fillColor: Colors.grey.shade100,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// ICON TITLE
            const Text(
              "Select Icon",

              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            /// ICONS
            Wrap(
              spacing: 10,

              runSpacing: 10,

              children: icons.map((i) {
                final isSelected = _icon == i;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _icon = i;
                    });
                  },

                  child: Container(
                    width: 56,
                    height: 56,

                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF5B4DCC)
                          : Colors.grey.shade100,

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF5B4DCC)
                            : Colors.grey.shade300,

                        width: 1.5,
                      ),
                    ),

                    child: Center(
                      child: i == 'none'
                          ? Text(
                        "None",

                        style: TextStyle(
                          fontSize: 11,

                          fontWeight: FontWeight.bold,

                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      )
                          : Text(i, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            /// COLOR TITLE
            const Text(
              "Select Color",

              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            /// COLORS
            Row(
              children: colors.map((c) {
                final isSelected = _color == c;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _color = c;
                    });
                  },

                  child: Container(
                    margin: const EdgeInsets.only(right: 12),

                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      color: c,

                      shape: BoxShape.circle,

                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,

                        width: 3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B4DCC),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                onPressed: _save,

                child: Text(
                  widget.category == null ? "Add Category" : "Update Category",

                  style: const TextStyle(
                    fontSize: 16,

                    color: Colors.white,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SAVE CATEGORY
  void _save() {
    final name = _nameCtrl.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter category name")));

      return;
    }

    final provider = context.read<CategoryProvider>();

    final category = CategoryModel(
      id:
      widget.category?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),

      name: name,

      icon: _icon,

      color: _color,

      isDefault: false,
    );

    if (widget.category == null) {
      provider.addCategory(category);
    } else {
      provider.updateCategory(category);
    }

    Navigator.pop(context);
  }
}
