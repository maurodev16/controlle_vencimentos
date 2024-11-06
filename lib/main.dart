import 'package:controlle_vencimentos/bindings/all_bindings.dart';
import 'package:controlle_vencimentos/views/document_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();
  //await box.erase();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: MyBinding(),
        home: DocumentListScreen());
  }
}
