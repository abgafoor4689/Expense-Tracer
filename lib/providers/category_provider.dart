import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../model/category.dart';

class CategoryProvider extends ChangeNotifier {
  final _box = GetStorage();

  final String storageKey = 'categories';

  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  List<CategoryModel> get defaultCategories =>
      _categories.where((e) => e.isDefault).toList();

  List<CategoryModel> get customCategories =>
      _categories.where((e) => !e.isDefault).toList();

  CategoryProvider() {
    loadCategories();
  }

  void loadCategories() {
    final data = _box.read(storageKey);

    if (data != null) {
      _categories = (data as List)
          .map((e) => CategoryModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      _categories = [
        CategoryModel(
          id: '1',
          name: 'Food',
          icon: '🍔',
          color: Colors.orange,
          isDefault: true,
        ),
        CategoryModel(
          id: '2',
          name: 'Travel',
          icon: '✈️',
          color: Colors.blue,
          isDefault: true,
        ),
        CategoryModel(
          id: '3',
          name: 'Bills',
          icon: '📄',
          color: Colors.red,
          isDefault: true,
        ),
        CategoryModel(
          id: '4',
          name: 'Shopping',
          icon: '🛍️',
          color: Colors.purple,
          isDefault: true,
        ),
      ];

      saveCategories();
    }

    notifyListeners();
  }

  void addCategory(CategoryModel category) {
    _categories.add(category);
    saveCategories();
  }

  void updateCategory(CategoryModel category) {
    final index = _categories.indexWhere((e) => e.id == category.id);

    if (index != -1) {
      _categories[index] = category;
      saveCategories();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((e) => e.id == id);
    saveCategories();
  }

  void saveCategories() {
    _box.write(storageKey, _categories.map((e) => e.toMap()).toList());

    notifyListeners();
  }
}
