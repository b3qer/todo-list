import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:list_todo/constants/Constants.dart';
import 'package:list_todo/controllers/CategoryController.dart';
import 'package:list_todo/views/homePage.dart';

import 'controllers/TodoController.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(TodoController());
    Get.put(CategoryController());
    GetStorage.init();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: pages,
      initialRoute: homeRoute,
    );
  }
}
