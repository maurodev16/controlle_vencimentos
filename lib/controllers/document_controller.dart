import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/documents_model.dart';
import '../services/document_storage_service.dart';
import 'category_controller.dart';

class DocumentController extends GetxController {
  final nameController = TextEditingController();
  final dueDateController = TextEditingController();
  final priceController = TextEditingController();
  RxBool loading = false.obs;
  var documents = <DocumentModel>[].obs;
  final DocumentStorageService storageService = DocumentStorageService();
  final CategoryController categoryContr = Get.find();
  final categoryController = CategoryController();
  RxList<DocumentModel> filteredDocuments = <DocumentModel>[].obs;

  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void onInit() async {
    super.onInit();
    await loadDocuments();
  }

  // Método para carregar documentos (simulando uma carga de dados)
  Future<void> loadDocuments() async {
    // Carregar os documentos aqui (exemplo)
    documents.assignAll(await DocumentStorageService().loadDocuments());
    filterDocuments(); // Filtra após o carregamento
  }

// Filtro de documentos
  void filterDocuments() {
    filteredDocuments.assignAll(documents.where((document) {
      bool matchesCategory = categoryController.selectedCategory.value ==
              null ||
          document.category?.name == categoryController.selectedCategory.value;

      bool matchesDueDate = true;
      if (dueDateController.text.isNotEmpty) {
        final dueDateFilter = dueDateController.text;
        if (dueDateFilter == 'Vencidos') {
          matchesDueDate = document.dueDate!.isBefore(DateTime.now());
        } else if (dueDateFilter == 'A Vencer') {
          matchesDueDate = document.dueDate!.isAfter(DateTime.now());
        } else if (dueDateFilter == 'Vencendo Hoje') {
          // Filtro para documentos que vencem hoje
          final today = DateTime.now();
          matchesDueDate = document.dueDate!.year == today.year &&
              document.dueDate!.month == today.month &&
              document.dueDate!.day == today.day;
        }
      }

      return matchesCategory && matchesDueDate;
    }).toList());
  }

  // Cálculo do preço total de todos os documentos
  double get totalPrice =>
      documents.fold(0, (sum, item) => sum + (item.price ?? 0));

  // Função para adicionar um documento
  Future<void> addDocument() async {
    loading.value = true;
    try {
      if (nameController.text.isEmpty ||
          dueDateController.text.isEmpty ||
          priceController.text.isEmpty) {
        throw Exception('Todos os campos são obrigatórios');
      }

      final parsedPrice = double.tryParse(priceController.text);
      if (parsedPrice == null) {
        throw Exception('Preço inválido');
      }

      DateTime parsedDueDate;
      try {
        parsedDueDate = dateFormat.parseStrict(dueDateController.text);
      } catch (_) {
        throw Exception('Data de vencimento inválida');
      }

      // Obtendo a categoria selecionada como um CategoryModel
      final selectedCategory = categoryContr.selectedCategory.value;

      if (selectedCategory == null) {
        throw Exception('Categoria não selecionada');
      }

      // Criando o novo documento
      final newDocument = DocumentModel(
        name: nameController.text,
        dueDate: parsedDueDate,
        category: selectedCategory, // Agora é um CategoryModel
        price: parsedPrice,
      );

      documents.add(newDocument);
      await storageService.saveDocument(newDocument);
      clearInput();

      Get.snackbar(
        'Sucesso',
        'Documento adicionado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    } finally {
      loading.value = false;
    }
  }

  // Limpar os campos após adicionar o documento
  void clearInput() {
    nameController.clear();
    dueDateController.clear();
    priceController.clear();
    // Não precisamos limpar a categoria aqui, pois a seleção permanece
  }
}
