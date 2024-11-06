import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/category_model.dart';

class CategoryController extends GetxController {
  final GetStorage storage = GetStorage();
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  @override
  void onInit() async {
    super.onInit();
    await _initializeCategories();
  }

  Future<void> _initializeCategories() async {
    List<dynamic> storedCategories = storage.read<List>('categories') ?? [];

    if (storedCategories.isEmpty) {
      categories.assignAll([
        CategoryModel(
          name: 'Educação',
          description: 'Gastos com educação',
          icon: Icons.school,
        ),
        CategoryModel(
          name: 'Saúde',
          description: 'Gastos com saúde',
          icon: Icons.local_hospital,
        ),
        CategoryModel(
          name: 'Lazer',
          description: 'Gastos com lazer',
          icon: Icons.sports,
        ),
        CategoryModel(
          name: 'Moradia',
          description: 'Gastos com moradia',
          icon: Icons.house,
        ),
      ]);
      await _saveCategories();
    } else {
      categories.assignAll(
        storedCategories
            .map((categoryJson) => CategoryModel.fromJson(categoryJson))
            .toList(),
      );
    }
  }

  Future<void> _saveCategories() async {
    storage.write(
        'categories', categories.map((category) => category.toJson()).toList());
  }
}
