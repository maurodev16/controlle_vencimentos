class DocumentModel {
  String id;
  String name;
  DateTime dueDate;
  String category;
  double price;

  DocumentModel({
    required this.id,
    required this.name,
    required this.dueDate,
    required this.category,
    this.price = 0.0,
  });

  // Converte o objeto DocumentModel para um Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dueDate': dueDate.toIso8601String(), // Convertendo DateTime para String
      'category': category,
      'price': price,
    };
  }

  // Converte um Map (JSON) para um objeto DocumentModel
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      name: json['name'],
      dueDate: DateTime.parse(json['dueDate']), // Convertendo String para DateTime
      category: json['category'],
      price: json['price'] ?? 0.0,
    );
  }
}
