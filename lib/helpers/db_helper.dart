import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'todos.db'),
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE categories(id TEXT PRIMARY KEY, title TEXT, colorNumber INTEGER)');
      return db.execute(
          'CREATE TABLE todos(id TEXT PRIMARY KEY, title TEXT, description TEXT, startTime TEXT, completed INTEGER, categoryId TEXT)');
    }, version: 1);
  }

  static Future<void> addCategory(Map<String, dynamic> catData) async {
    final db = await DBHelper.database();
    await db.insert("categories", catData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> removeCategory(String catId) async {
    final db = await DBHelper.database();
    
    await db.delete("categories", where: "id = ?", whereArgs: [catId]);
    await db.delete('todos', where: "categoryId = ?", whereArgs: [catId]);
  }

  static Future<void> addTodo(Map<String, dynamic> todoData) async {
    final db = await DBHelper.database();
    await db.insert('todos', todoData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> removeTodo(String todoId) async {
    final db = await DBHelper.database();
    await db.delete("todos", where: "id = ?", whereArgs: [todoId]);
    
  }

  static Future<void> updateTodo(Map<String, dynamic> todoData) async {
    final db = await DBHelper.database();
    await db.update("todos", todoData,
        where: "id = ?", whereArgs: [todoData['id']]);
    
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await DBHelper.database();
    return db.query("categories");
  }

  static Future<List<Map<String, dynamic>>> getTodos(String categoryId) async {
    final db = await DBHelper.database();
    return db.query("todos", where: "categoryId = ?", whereArgs: [categoryId]);
  }

  static Future<void> wipeData() async {
    final db = await DBHelper.database();
    await db.execute("DROP TABLE IF EXISTS categories");
    await db.execute("DROP TABLE IF EXISTS todos");
    await db.execute(
        'CREATE TABLE categories(id TEXT PRIMARY KEY, title TEXT, colorNumber INTEGER)');
    await db.execute(
        'CREATE TABLE todos(id TEXT PRIMARY KEY, title TEXT, description TEXT, startTime TEXT, completed INTEGER, categoryId TEXT)');
  }
}
