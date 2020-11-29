import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:list_todo/constants/Constants.dart';
import 'package:list_todo/constants/FadeAnimation.dart';
import 'package:list_todo/controllers/CategoryController.dart';
import 'package:list_todo/controllers/TodoController.dart';
import 'package:list_todo/models/Todo.dart';
import 'package:loading_indicator/loading_indicator.dart';

// ignore: camel_case_types
class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}
// ignore: camel_case_types
class _homePageState extends State<homePage> {
  var days = {
    "1": "Monday",
    "2": "Tuesday",
    "3": "Wednesday",
    "4": "Thursday",
    "5": "Friday",
    "6": "Saturday",
    "7": "Sunday"
  };
  int selected = 0;
  bool done = true;
  int day = DateTime.now().weekday;
  TodoController todoController = Get.find();
  CategoryController categoryController = Get.find();

  _startFunction() async {
    await Future.delayed(const Duration(seconds: 2));
    categoryController.getCategories();
    todoController.getCount();
    setState(() {
      done = false;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    if (categoryController.categories.isNotEmpty)
      todoController.getTodos(categoryController.categories[0].id);

    if (box.read('intro') == null) {
      print(box.read('intro'));
      Get.toNamed(introductionRoute);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: MaterialButton(
        onPressed: () {
          if (categoryController.categories.isEmpty) {
            categoryController.noCategoryDialog();
            return;
          }

          todoController
              .createDialog(categoryController.categories[selected].id);
        },
        height: 50,
        color: primaryColor,
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              height: MediaQuery.of(context).size.height - 70,
              child: done
                  ? Center(
                      child: Container(
                      height: 250,
                      width: 250,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballClipRotateMultiple,
                        color: primaryColor,
                      ),
                    ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _firstSection(),
                        Text(
                          "All To Do",
                          style: GoogleFonts.ubuntu(fontSize: 25),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(child: Obx(() {
                          if (todoController.todos.isEmpty)
                            return Center(
                              child: Text(
                                'Create one, it will appear here ',
                                style: GoogleFonts.ubuntu(fontSize: 22),
                              ),
                            );
                          return SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                  todoController.todos.length, (index) {
                                return _todoCard(todoController.todos[index]);
                              }),
                            ),
                          );
                        }))
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  _categoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() => Row(
            children: List.generate(categoryController.categories.length + 1,
                (index) {
              bool check = selected == index ? true : false;
              if (categoryController.categories.isEmpty ||
                  index == categoryController.categories.length)
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      categoryController.createDialog();

                      _startFunction();
                    },
                    child: Container(
                      height: 45,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          // color: Colors.blue,
                          border: Border.all(color: primaryColor)),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = index;
                    });
                    todoController
                        .getTodos(categoryController.categories[index].id);
                  },
                  onLongPress: () {
                    categoryController.deleteDialog(
                        categoryController.categories[index].name,
                        categoryController.categories[index].id);
                  },
                  child: Container(
                    height: 45,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: check ? primaryColor : deactiveColor,
                    ),
                    child: Center(
                      child: Text(
                        categoryController.categories[index].name,
                        style: GoogleFonts.ubuntu(
                            color: check ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
              );
            }),
          )),
    );
  }

  _todoCard(Todo todo) {
    return FadeAnimation(
        1,
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onLongPress: () {
              todoController.deleteDialog(todo.id, todo.categoryId);
            },
            onDoubleTap: () {
              if (todo.done == 0) todoController.finishedDialog(todo);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              height: 100,
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ListTile(
                    title: Text(
                      todo.title,
                      style: GoogleFonts.ubuntu(fontSize: 25),
                    ),
                    trailing: Container(
                      height: 20,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: todo.done == 0 ? warningColor : doneTodo,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[400],
                                blurRadius: 10,
                                offset: Offset(0, 5))
                          ]),
                      child: Center(
                          child: todo.done == 0
                              ? Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 15,
                                )
                              : Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 15,
                                )),
                    ),
                    subtitle: Text(
                      todo.subtitle,
                      style: GoogleFonts.ubuntu(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  _firstSection() {
    return Container(
      width: Get.width,
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${days['$day']}",
                style: GoogleFonts.ubuntu(fontSize: 50),
              ),
              Container(
                height: 45,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: primaryColor),
                child: Center(
                    child: Obx(() => Text(
                          "${todoController.count}",
                          style: GoogleFonts.ubuntu(
                              fontSize: 20, color: Colors.white),
                        ))),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          _categoryList()
        ],
      ),
    );
  }
}
