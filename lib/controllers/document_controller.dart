import 'package:controlle_vencimentos/models/documents_model.dart';
import 'package:controlle_vencimentos/services/document_storage_service.dart';
import 'package:get/get.dart';

class DocumentController extends GetxController {
  var documents = <DocumentModel>[].obs;
  final DocumentStorageService storageService = DocumentStorageService();
  // Método para calcular o total dos preços
  double get totalPrice => documents.fold(0, (sum, item) => sum + item.price);

  @override
  void onInit() async{
    super.onInit();
   await loadDocuments();
  }

  // Carregar documentos salvos
  Future<void> loadDocuments()async {
    documents.assignAll(storageService.loadDocuments());
  }

  // Adicionar novo documento
  Future<void> addDocument(DocumentModel doc) async {
    documents.add(doc);
    storageService.saveDocument(doc);
  }
}
