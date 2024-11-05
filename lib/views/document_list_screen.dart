import 'package:controlle_vencimentos/controllers/document_controller.dart';
import 'package:controlle_vencimentos/views/create_document_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DocumentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documentos e Vencimentos'),
      ),
      body: Column(
        children: [
          // Exibir o total das contas no topo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              final totalAmount = Get.find<DocumentController>().totalPrice;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Valor Total das Contas:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'R\$ ${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              );
            }),
          ),
          Expanded(
            child: GetX<DocumentController>(
              builder: (controller) => ListView.builder(
                itemCount: controller.documents.length,
                itemBuilder: (context, index) {
                  final document = controller.documents[index];
                  final isExpired = document.dueDate.isBefore(DateTime.now());

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    color: isExpired ? Colors.red[100] : Colors.green[100],
                    child: ListTile(
                      leading: isExpired
                          ? Icon(FontAwesomeIcons.skull, color: Colors.red[800])
                          : null,
                      title: Text(
                        document.name,
                        style: TextStyle(
                          color: isExpired ? Colors.red[800] : Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Categoria: ${document.category}\nPreço: R\$${document.price.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: Text(
                        'Vencimento: ${DateFormat('dd/MM/yyyy').format(document.dueDate)}',
                        style: TextStyle(
                          color: isExpired ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreateDocumentScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
