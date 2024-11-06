import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final String description;
  final IconData icon;

  CategoryModel({
    required this.name,
    required this.description,
    required this.icon,
  });

  // Converte CategoryModel para Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon.codePoint, // Salvando o código do ícone, por exemplo
    };
  }

  // Converte Map (JSON) para CategoryModel
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'],
      description: json['description'],
      icon: IconData(json['icon'],
          fontFamily:
              'MaterialIcons'), // Supondo que você esteja usando Material Icons
    );
  }
}
