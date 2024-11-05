import 'package:controlle_vencimentos/controllers/document_controller.dart';
import 'package:controlle_vencimentos/models/documents_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class DocumentListScreen extends StatelessWidget {
  final DocumentController controller = Get.find<DocumentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documentos e Vencimentos'),
      ),
      body: Obx(() {
        // Exibe a lista de documentos
        return ListView.builder(
          itemCount: controller.documents.length,
          itemBuilder: (context, index) {
            final document = controller.documents[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(document.name),
                subtitle: Text('Categoria: ${document.category}\nPreço: R\$${document.price.toStringAsFixed(2)}'),
                trailing: Text(
                  'Vencimento: ${DateFormat('dd/MM/yyyy').format(document.dueDate)}',
                  style: TextStyle(color: document.dueDate.isBefore(DateTime.now()) ? Colors.red : Colors.green),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Simular a adição de um novo documento (pode ser uma tela de input)
          final newDocument = DocumentModel(
            id: DateTime.now().toString(),
            name: 'Novo Documento',
            dueDate: DateTime.now().add(Duration(days: 5)),
            category: 'Categoria Exemplo',
            price: 50.0,
          );
          controller.addDocument(newDocument);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
