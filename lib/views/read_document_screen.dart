import 'package:controlle_vencimentos/controllers/document_controller.dart';
import 'package:controlle_vencimentos/views/create_document_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/buildDocumentCard.dart';

class ReadDocumentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de abas
      child: Scaffold(
        appBar: AppBar(
          title: Text('Documentos e Vencimentos'),
          bottom: TabBar(
            tabs: [
              Tab(text: "Vencem Hoje"),
              Tab(text: "A Vencer"),
              Tab(text: "Vencidos"),
            ],
          ),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

            // Conteúdo das abas
            Expanded(
              child: TabBarView(
                children: [
                  DocumentTab(
                      filterType: 'today'), // Documentos que vencem hoje
                  DocumentTab(
                      filterType:
                          'upcoming'), // Documentos que ainda não venceram
                  DocumentTab(filterType: 'expired'), // Documentos já vencidos
                ],
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
      ),
    );
  }
}

// Widget para exibir a lista de documentos conforme o filtro
class DocumentTab extends StatelessWidget {
  final String filterType;

  DocumentTab({required this.filterType});

  @override
  Widget build(BuildContext context) {
    return GetX<DocumentController>(
      builder: (controller) {
        // Filtrando os documentos com base no tipo de filtro
        final filteredDocuments = controller.documents.where((document) {
          final today = DateTime.now();
          final dueDate = document.dueDate!;

          // Removendo horas para fazer a comparação com apenas ano, mês e dia
          final todayDate = DateTime(today.year, today.month, today.day);
          final documentDate =
              DateTime(dueDate.year, dueDate.month, dueDate.day);

          if (filterType == 'today') {
            // Filtra documentos que vencem hoje
            return documentDate == todayDate;
          } else if (filterType == 'upcoming') {
            // Filtra documentos com data futura
            return documentDate.isAfter(todayDate);
          } else if (filterType == 'expired') {
            // Filtra documentos já vencidos (exclui documentos que vencem hoje)
            return documentDate.isBefore(todayDate);
          }
          return false;
        }).toList();

        return ListView.builder(
          itemCount: filteredDocuments.length,
          itemBuilder: (context, index) {
            final document = filteredDocuments[index];
            return buildDocumentCard(document);
          },
        );
      },
    );
  }
}
