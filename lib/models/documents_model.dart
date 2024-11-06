import 'package:controlle_vencimentos/models/category_model.dart';

class DocumentModel {
  String? id;
  String? name;
  DateTime? dueDate;
  CategoryModel? category; // A categoria agora é um CategoryModel
  double? price;

  DocumentModel({
    this.id,
    this.name,
    this.dueDate,
    this.category,
    this.price = 0.0,
  });

  // Converte DocumentModel para Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dueDate': dueDate!.toIso8601String(),
      'category':
          category?.toJson(), // Aqui estamos armazenando a categoria como Map
      'price': price,
    };
  }

  // Converte Map (JSON) para DocumentModel
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      name: json['name'],
      dueDate: DateTime.parse(json['dueDate']),
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      price: json['price'] ?? 0.0,
    );
  }
}
