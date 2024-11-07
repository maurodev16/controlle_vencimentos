import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:controlle_vencimentos/controllers/document_controller.dart';
import 'package:controlle_vencimentos/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/category_model.dart';

class CreateDocumentScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DocumentController documentController = Get.find();
  final CategoryController categoryController = Get.find();

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
                  controller: documentController.nameController,
                  decoration: InputDecoration(
                      labelText: 'Tipo de Documento',
                      prefixIcon: Icon(FontAwesomeIcons.fileContract)),
                  style: TextStyle(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do documento.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: documentController.dueDateController,
                  decoration: InputDecoration(
                      labelText: 'Data de Vencimento (dd/MM/yyyy)',
                      prefixIcon: Icon(FontAwesomeIcons.calendarDay)),
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      documentController.dueDateController.text =
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
                DropdownButtonFormField<CategoryModel?>(
                  decoration: InputDecoration(
                      labelText: 'Categoria',
                      prefixIcon: Icon(FontAwesomeIcons.box)),
                  value: categoryController
                      .selectedCategory.value, // A categoria selecionada
                  onChanged: (newValue) {
                    categoryController.selectedCategory.value = newValue;
                  },
                  items: categoryController.categories.map((category) {
                    return DropdownMenuItem<CategoryModel?>(
                      value:
                          category, // Passando o objeto CategoryModel completo
                      child:
                          Text(category.name), // Exibindo o nome da categoria
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione uma categoria.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: documentController.priceController,
                  decoration: InputDecoration(
                      labelText: 'Preço',
                      prefixIcon: Icon(FontAwesomeIcons.moneyBill1Wave)),
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
                      documentController.addDocument();
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.scale,
                        dialogType: DialogType.info,
                        body: Center(
                          child: Text(
                            'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        title: 'This is Ignored',
                        desc: 'This is also Ignored',
                        btnOkOnPress: () {},
                      )..show();
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
