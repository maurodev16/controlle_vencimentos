import 'package:controlle_vencimentos/models/documents_model.dart';
import 'package:get_storage/get_storage.dart';

class DocumentStorageService {
  final GetStorage storage = GetStorage();

  // Salva um documento no GetStorage
  Future<void> saveDocument(DocumentModel document) async {
    // Lê os documentos já salvos, se existirem
    List<Map<String, dynamic>> documentList =
        (storage.read<List>('documents') ?? []).cast<Map<String, dynamic>>();

    // Adiciona o novo documento na lista
    documentList.add(document.toJson());

    // Salva a lista de documentos novamente
    storage.write('documents', documentList);
  }

  // Carrega todos os documentos salvos
  List<DocumentModel> loadDocuments() {
    // Lê os documentos salvos do GetStorage
    List<dynamic> jsonList = storage.read<List>('documents') ?? [];

    // Mapeia os dados do JSON para a lista de DocumentModel, incluindo a categoria
    return jsonList.map((json) {
      return DocumentModel.fromJson(json);
    }).toList();
  }
}
