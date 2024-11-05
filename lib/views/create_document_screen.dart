import 'package:controlle_vencimentos/controllers/document_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/documents_model.dart';

class CreateDocumentScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Documento'),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nome do Documento'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do documento.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dueDateController,
                    decoration: InputDecoration(
                        labelText: 'Data de Vencimento (dd/MM/yyyy)'),
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null) {
                        _dueDateController.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a data de vencimento.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'Categoria'),
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Preço'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && double.tryParse(value) == null) {
                        return 'Por favor, insira um valor válido para o preço.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Criar um novo documento
                        Get.find<DocumentController>().addDocument(
                          DocumentModel(
                            id: DateTime.now()
                                .toString(), // Usar a data como ID temporário
                            name: _nameController.text,
                            dueDate: DateFormat('dd/MM/yyyy')
                                .parse(_dueDateController.text),
                            category: _categoryController.text,
                            price:
                                double.tryParse(_priceController.text) ?? 0.0,
                          ),
                        );

                        // Limpar os campos após adicionar
                        _nameController.clear();
                        _dueDateController.clear();
                        _categoryController.clear();
                        _priceController.clear();

                        // Exibir uma mensagem de sucesso
                        Get.snackbar(
                          'Sucesso',
                          'Documento adicionado com sucesso!',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        Get.back();
                      }
                    },
                    child: Text('Adicionar Documento'),
                  ),
                ],
              ),
            ),
          ),
        ),
    
    );
  }
}
