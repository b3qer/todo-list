import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:list_todo/constants/Constants.dart';
import 'package:list_todo/database/DatabaseHelper.dart';
import 'package:list_todo/models/Todo.dart';

class TodoController extends GetxController {
  DatabaseHelper db = DatabaseHelper();
  final todos = [].obs;
  var count = 0.obs;
  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();

  createTodo(Todo todo) async {
    int result = await db.createTodo(todo);
    getTodos(todo.categoryId);
    getCount();
  }

  getCount() async {
    var result = await db.getTodoCount();
    count.value = result;
  }

  getTodos(int id) async {
    List res = await db.getTodos(id);
    todos.clear();
    todos.addAll(res.map((e) => Todo.fromJson(e)).toList());
  }

  deleteTodo(int id, int category_id) async {
    int res = await db.deleteTodo(id);
    getCount();
    getTodos(category_id);
  }

  updateTodo(Todo todo) async {
    int res = await db.updateTodo(todo);
    getCount();
    getTodos(todo.categoryId);
  }

  createDialog(int id) async {
    Get.dialog(
      AlertDialog(
        title: Text("Create To Do"),
        content: Container(
          height: 130,
          child: Column(
            children: [
              TextField(
                controller: title,
                style: GoogleFonts.ubuntu(
                  height: 0.5,
                ),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    labelText: 'Title',
                    labelStyle: GoogleFonts.ubuntu(color: primaryColor),
                    border: OutlineInputBorder(
                        borderSide: new BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: subtitle,
                style: GoogleFonts.ubuntu(
                  height: 0.5,
                ),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    labelText: 'Subtitle',
                    labelStyle: GoogleFonts.ubuntu(color: primaryColor),
                    border: OutlineInputBorder(
                        borderSide: new BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(10))),
              ),
            ],
          ),
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
              if (title.isNull == false && subtitle.isNull == false) {
                createTodo(Todo(
                    title: title.text,
                    subtitle: subtitle.text,
                    categoryId: id,
                    done: 0));
                title.clear();
                subtitle.clear();
                Get.back();
              }
            },
            color: primaryColor,
            child: Text(
              "Done",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              //side: BorderSide(color: Colors.red)),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  deleteDialog(int id, int category_id) {
    Get.dialog(
      AlertDialog(
        title: Text("Delete Confirm"),
        content: Text("Do you want to delete this todo?"),
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
              deleteTodo(id, category_id);
              Get.back();
            },
            color: primaryColor,
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              //side: BorderSide(color: Colors.red)),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  finishedDialog(Todo todo) {
    Get.dialog(
      AlertDialog(
        title: Text("Finished Confirm"),
        content: Text("Do you finished this todo?"),
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
              todo.done = 1;
              updateTodo(todo);
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
}
