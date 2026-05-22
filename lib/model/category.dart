import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final bool isDefault;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isDefault,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      // ignore: deprecated_member_use
      'color': color.value,
      'isDefault': isDefault,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      color: Color(map['color']),
      isDefault: map['isDefault'],
    );
  }
}
