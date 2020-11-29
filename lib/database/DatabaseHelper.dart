import 'dart:io';

import 'package:list_todo/models/Category.dart';
import 'package:list_todo/models/Todo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database _db;
  String category_table = 'category', todo_table = 'todos';
  String categroy_id = 'id', categroy_name = 'name';
  String todo_id = 'id',
      todo_title = 'title',
      todo_subtitle = 'subtitle',
      todo_done = 'done',
      todo_category_id = 'category_id';

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $category_table ($categroy_id INTEGER PRIMARY KEY, $categroy_name TEXT)');

    await db.execute(
        'CREATE TABLE $todo_table ($todo_id INTEGER PRIMARY KEY, $todo_title TEXT,'
        '$todo_subtitle TEXT, $todo_done bit,'
        '$todo_category_id INT)');
  }

  intDB() async {
    Directory d = await getApplicationDocumentsDirectory();
    String p = join(d.path, 'MyDB.db');
    var Mydb = await openDatabase(p, version: 1, onCreate: _onCreate);
    return Mydb;
  }

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await intDB();
    return _db;
  }

  // category Section

  Future<int> createCategory(Category category) async {
    var cdb = await db;
    int res = await cdb.insert(category_table, category.toJson());
    print(res);
    return res;
  }

  Future<List> getCategories() async {
    var cdb = await db;
    List res = await cdb.rawQuery('select * from $category_table');
    return res.toList();
  }

  Future<int> deleteCategory(int id) async {
    var cdb = await db;
    var res = await cdb
        .delete(category_table, where: '$categroy_id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteCategories() async {
    var cdb = await db;
    var res = await cdb.delete(category_table,
        where: '$categroy_id != ?', whereArgs: ["sadasda"]);
    return res;
  }

  // end category section

  // todo section

  Future<int> createTodo(Todo todo) async {
    var cdb = await db;
    int res = await cdb.insert(todo_table, todo.toJson());
    // bloc.fetchUserCount();

    return res;
  }

  Future<int> updateTodo(Todo todo) async {
    var cdb = await db;
    var res = await cdb.update(todo_table, todo.toJson(),
        where: '$todo_id = ?', whereArgs: [todo.id]);
    return res;
  }

  Future<List> getTodos(int id) async {
    var cdb = await db;
    List res = await cdb.rawQuery(
        "SELECT * FROM $todo_table WHERE $todo_category_id = $id ORDER BY id DESC");
    //List res = await cdb.rawQuery('select * from $table3 ORDER BY id DESC');
    return res.toList();
  }

  Future<int> deleteTodo(int id) async {
    var cdb = await db;
    var res =
        await cdb.delete(todo_table, where: '$todo_id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteTodos(int category_id) async {
    var cdb = await db;
    var res = await cdb.delete(todo_table,
        where: '$todo_category_id = ?', whereArgs: [category_id]);
    return res;
  }

  Future<int> getTodoCount() async {
    var cdb = await db;

    return Sqflite.firstIntValue(
        await cdb.rawQuery('select count(*) from $todo_table where done = 0'));
  }

  // end todo section

}
