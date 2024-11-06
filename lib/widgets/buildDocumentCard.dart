import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/documents_model.dart';

Card buildDocumentCard(DocumentModel document) {
  // Verifica se o documento está vencido, vencendo hoje ou a vencer
  final dueDate = document.dueDate;
  final now = DateTime.now();
  final isExpired = dueDate!.isBefore(now); // Vencido
  final isDueToday = dueDate.year == now.year &&
      dueDate.month == now.month &&
      dueDate.day == now.day; // Vencendo hoje
  final isUpcoming = !isExpired && !isDueToday; // A vencer

  Color cardColor;
  Color borderColor;
  Color textColor;
  Icon icon;

  // Define as cores e o ícone com base no status
  if (isExpired) {
    cardColor = Color.fromARGB(255, 242, 0, 36); // Vermelho para vencidos
    borderColor = Colors.red;
    textColor = Colors.red[800]!;
    icon = Icon(FontAwesomeIcons.skull, color: Colors.red[800], size: 30.0);
  } else if (isDueToday) {
    cardColor = Colors.yellow[100]!; // Amarelo para "Vencendo Hoje"
    borderColor = Colors.orange;
    textColor = Colors.orange[800]!;
    icon = Icon(FontAwesomeIcons.triangleExclamation,
        color: Colors.orange[800], size: 30.0); // Ícone de alerta
  } else {
    cardColor = Colors.green[50]!; // Verde para "A Vencer"
    borderColor = Colors.green;
    textColor = Colors.green[800]!;
    icon = Icon(FontAwesomeIcons.circleCheck,
        color: Colors.green[800], size: 30.0); // Ícone de sucesso
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
          // Ícone de Vencido, Vencendo Hoje ou A Vencer
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: icon,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome do Documento
                Text(
                  document.name!,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 4.0),
                // Categoria e Preço
                Text(
                  'Categoria: ${document.category!.name}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Text(
                  'Preço: R\$${document.price!.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 8.0),
                // Data de Vencimento
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
