import 'package:controlle_vencimentos/models/documents_model.dart';
import 'package:get_storage/get_storage.dart';

class DocumentStorageService {
  final GetStorage storage = GetStorage();

  // Salva um documento no GetStorage
  void saveDocument(DocumentModel document) {
    List<Map<String, dynamic>> documentList =
        (storage.read<List>('documents') ?? []).cast<Map<String, dynamic>>();

    // Adiciona o novo documento e salva a lista novamente
    documentList.add(document.toJson());
    storage.write('documents', documentList);
  }

  // Carrega todos os documentos salvos
  List<DocumentModel> loadDocuments() {
    List<dynamic> jsonList = storage.read<List>('documents') ?? [];
    return jsonList.map((json) => DocumentModel.fromJson(json)).toList();
  }
}
