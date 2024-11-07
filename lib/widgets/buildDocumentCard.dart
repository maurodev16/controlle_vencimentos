import 'package:controlle_vencimentos/controllers/document_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/documents_model.dart';
import '../views/enums.dart';

Card buildDocumentCard(DocumentModel document) {
  final documentController = Get.find<DocumentController>();
  final dueDate = document.dueDate!;
  final status = documentController.getDocumentStatus(dueDate);

  // Definir cores e ícone com base no status do documento
  Color cardColor;
  Color borderColor;
  Color textColor;
  Icon icon;

  switch (status) {
    case DocumentStatus.EXPIRED:
      cardColor = Color.fromARGB(255, 242, 0, 36); // Vermelho para vencidos
      borderColor = Colors.red;
      textColor = Colors.red[800]!;
      icon = Icon(FontAwesomeIcons.skull, color: Colors.red[800], size: 30.0);
      break;

    case DocumentStatus.DUETODAY:
      cardColor = const Color.fromARGB(255, 18, 16, 12);
      borderColor = const Color.fromARGB(255, 78, 72, 63);
      textColor = const Color.fromARGB(255, 215, 200, 187);
      icon = Icon(FontAwesomeIcons.triangleExclamation,
          color: Colors.orange[800], size: 30.0);
      break;

    case DocumentStatus.UPCOMING:
      cardColor = Colors.green[50]!;
      borderColor = Colors.green;
      textColor = Colors.green[800]!;
      icon = Icon(
        FontAwesomeIcons.circleCheck,
        color: Colors.green[800],
        size: 30.0,
      );
      break;
  }

  return Card(
    margin: EdgeInsets.all(8.0),
    color: cardColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
      side: BorderSide(
        color: borderColor,
        width: 1.5,
      ),
    ),
    elevation: 4.0,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: icon,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name!,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  'Categoria: ${document.category!.name}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Text(
                  'Preço: R\$${document.price!.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Vencimento: ${DateFormat('dd/MM/yyyy').format(document.dueDate!)}',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
