import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/documents_model.dart';
import '../services/document_storage_service.dart';
import '../views/enums.dart';
import 'category_controller.dart';

class DocumentController extends GetxController {
  RxString name_txt = "".obs;
  RxString dueDate_txt = "".obs;
  RxDouble price_txt = 0.0.obs;
  final dateFormat = DateFormat('dd/MM/yyyy');
  RxBool loading = false.obs;
  var documents = <DocumentModel>[].obs;
  final storageService = DocumentStorageService();
  final categoryController = Get.find<CategoryController>();
  RxList<DocumentModel> filteredDocuments = <DocumentModel>[].obs;

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
      if (dueDate_txt.value.isNotEmpty) {
        final dueDateFilter = dueDate_txt.value;
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
      if (name_txt.value.isEmpty || dueDate_txt.value.isEmpty) {
        throw Exception('Todos os campos são obrigatórios');
      }

      DateTime parsedDueDate;
      try {
        parsedDueDate = dateFormat.parseStrict(dueDate_txt.value);
      } catch (_) {
        throw Exception('Data de vencimento inválida');
      }

      // Obtendo a categoria selecionada como um CategoryModel
      final selectedCategory = categoryController.selectedCategory.value;

      if (selectedCategory == null) {
        throw Exception('Categoria não selecionada');
      }

      // Criando o novo documento
      final newDocument = DocumentModel(
        name: name_txt.value,
        dueDate: parsedDueDate,
        category: selectedCategory,
        price: price_txt.value,
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

  void inputValidation() {}

// Função para obter o status do documento com base na data de vencimento
  DocumentStatus getDocumentStatus(DateTime dueDate) {
    update();
    final now = DateTime.now();
    if (dueDate.isBefore(now)) {
      return DocumentStatus.EXPIRED;
    } else if (dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day) {
      return DocumentStatus.DUETODAY;
    } else {
      return DocumentStatus.UPCOMING;
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
