import 'package:controlle_vencimentos/controllers/document_controller.dart';
import 'package:controlle_vencimentos/views/create_document_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/buildDocumentCard.dart';

class DocumentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documentos e Vencimentos'),
      ),
      body: Column(
        children: [
          // Filtros de Categoria e Vencimento
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Filtro de Categoria
                DropdownButton<String>(
                  hint: Text('Categoria'),
                  value: Get.find<DocumentController>()
                      .categoryController
                      .selectedCategory
                      .value
                      ?.name, // Aqui você pega a propriedade 'name' do CategoryModel
                  onChanged: (value) {
                    Get.find<DocumentController>()
                            .categoryController
                            .selectedCategory
                            .value =
                        Get.find<DocumentController>()
                            .categoryController
                            .categories
                            .firstWhere((category) =>
                                category.name ==
                                value); // Atualiza com o CategoryModel
                    Get.find<DocumentController>()
                        .filterDocuments(); // Chama o filtro
                  },
                  items: Get.find<DocumentController>()
                      .categoryController
                      .categories
                      .map((category) => DropdownMenuItem<String>(
                            value: category
                                .name, // Usando apenas o nome da categoria, que é uma String
                            child: Text(category.name),
                          ))
                      .toList(),
                ),

                // Filtro de Status de Vencimento (Por exemplo, "Todos", "Vencidos", "A vencer", "Vencendo Hoje")
                DropdownButton<String>(
                  hint: Text('Status'),
                  value: Get.find<DocumentController>()
                          .dueDateController
                          .text
                          .isNotEmpty
                      ? Get.find<DocumentController>().dueDateController.text
                      : null,
                  onChanged: (value) {
                    Get.find<DocumentController>().dueDateController.text =
                        value ?? '';
                    Get.find<DocumentController>()
                        .filterDocuments(); // Chama o filtro
                  },
                  items: [
                    'Todos',
                    'Vencidos',
                    'A Vencer',
                    'Vencendo Hoje' // Adiciona a opção de "Vencendo Hoje"
                  ].map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

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

          // Lista de Documentos Filtrados
          Expanded(
            child: GetX<DocumentController>(
              builder: (controller) => ListView.builder(
                itemCount: controller.filteredDocuments.length,
                itemBuilder: (context, index) {
                  final document = controller.filteredDocuments[index];

                  return buildDocumentCard(document);
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
