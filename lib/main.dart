import 'package:controlle_vencimentos/bindings/all_bindings.dart';
import 'package:controlle_vencimentos/views/document_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      initialBinding: AllBinding(),
      home: DocumentListScreen()
    );
  }
}