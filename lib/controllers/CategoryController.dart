import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:list_todo/constants/Constants.dart';
import 'package:list_todo/database/DatabaseHelper.dart';
import 'package:list_todo/models/Category.dart';
import 'package:list_todo/controllers/TodoController.dart';

class CategoryController extends GetxController {
  DatabaseHelper db = DatabaseHelper();
  final categories = [].obs;
  TodoController todoController = Get.find();
  //CategoryController categoryController = Get.find();

  TextEditingController name = TextEditingController();

  createCategory(Category category) async {
    int res = await db.createCategory(category);
    getCategories();
  }

  getCategories() async {
    List res = await db.getCategories();
    categories.clear();
    categories.addAll(res.map((e) => Category.fromJson(e)).toList());
  }

  deleteCategory(int id) async {
    await db.deleteCategory(id);
    await db.deleteTodos(id);
    todoController.getCount();
    getCategories();
    todoController.getTodos(categories.last.id);
  }

  deleteDialog(String name, int id) {
    Get.dialog(
      AlertDialog(
        title: Text("Delete Confirm"),
        content: Text("Do you want to delete $name ?"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          MaterialButton(
            onPressed: () {
              deleteCategory(id);
              Get.back();
            },

            color: primaryColor,
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  createDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Create Category"),
        content: TextField(
          controller: name,
          style: GoogleFonts.ubuntu(
            height: 0.5,
          ),
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              labelText: 'Category Name',
              labelStyle: GoogleFonts.ubuntu(color: primaryColor),
              border: OutlineInputBorder(
                  borderSide: new BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10))),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Exit",
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          MaterialButton(
            onPressed: () {
              createCategory(Category(name: name.text));
              name.clear();
              Get.back();
            },
            color: primaryColor,
            child: Text(
              "Done",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  noCategoryDialog() async {
    Get.dialog(
      AlertDialog(
        title: Text(
          "Message",
          style: GoogleFonts.ubuntu(),
        ),
        content: Text(
          "Please, Create Category First",
          style: GoogleFonts.ubuntu(),
        ),
      ),
    );
  }
}
