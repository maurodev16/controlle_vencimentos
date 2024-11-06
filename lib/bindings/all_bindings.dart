import 'package:controlle_vencimentos/controllers/category_controller.dart';
import 'package:controlle_vencimentos/controllers/document_controller.dart';
import 'package:get/get.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentController>(() => DocumentController());
    Get.lazyPut<CategoryController>(() => CategoryController());
  }
}
