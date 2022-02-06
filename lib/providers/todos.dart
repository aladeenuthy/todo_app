import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '/models/http_exeption.dart';
import '/models/todo.dart';
import '/models/todo_error.dart';
import '/helpers/db_helper.dart';
import '/models/category.dart';

class Todoss with ChangeNotifier {
  List<Category> _items;
  final String? userId;
  Todoss( this.userId, this._items);

  List<Category> get items {
    return [..._items];
  }

  // category related
  Future<void> addCategory(String title, int colorNumber, String? authToken) async {
    final containsHome = _items.indexWhere(
        (category) => category.title.toLowerCase() == title.toLowerCase());
    if (containsHome != -1) {
      throw TodoException("Category already exist");
    }
    final url =
        'https://flutter-update-71bb2-default-rtdb.firebaseio.com/Todos/$userId.json?auth=$authToken';
    final response = await http.post(Uri.parse(url),
        body: json.encode({'title': title, 'colorNumber': colorNumber}));
    if (response.statusCode >= 400) {
      throw HttpException("an error occcured");
    } else {
      await DBHelper.addCategory({
        "id": json.decode(response.body)['name'],
        "title": title,
        "colorNumber": colorNumber
      });
      _items.insert(
          0,
          Category(
              id: json.decode(response.body)['name'],
              title: title,
              colorNumber: colorNumber,
              todos: []));
      notifyListeners();
    }
  }

  Future<void> removeCategory(String catId, String? authToken) async {
    final url =
        'https://flutter-update-71bb2-default-rtdb.firebaseio.com/Todos/$userId/$catId.json?auth=$authToken';

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      throw HttpException("could not delete category");
    }
    await DBHelper.removeCategory(catId);
    _items.removeWhere((category) => category.id == catId);
    notifyListeners();
  }

  // todo related
  Category getCategory(String categoryId) {
    return _items.firstWhere((category) => category.id == categoryId);
  }

  Future<void> addTodo(
    String categoryId,
    String title,
    String description,
    String? authToken
  ) async {
    final url =
        'https://flutter-update-71bb2-default-rtdb.firebaseio.com/Todos/$userId/$categoryId/todos.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            "title": title,
            "description": description,
            'completed': false,
          }));
      await DBHelper.addTodo({
        "id": json.decode(response.body)['name'],
        "title": title,
        "description": description,
        'completed': 0,
        "categoryId": categoryId
      });
      getCategory(categoryId).todos.insert(
          0,
          Todo(
            id: json.decode(response.body)['name'],
            title: title,
            description: description,
          ));
      notifyListeners();
    } catch (error) {
      throw HttpException("a problem occured while adding a todo");
    }
  }

  Future<void> removeTodo(String categoryId, String todoId, String? authToken) async {
    final url =
        'https://flutter-update-71bb2-default-rtdb.firebaseio.com/Todos/$userId/$categoryId/todos/$todoId.json?auth=$authToken';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      notifyListeners();
      throw HttpException("couldn't remove todo");
    }
    await DBHelper.removeTodo(todoId);
    getCategory(categoryId).todos.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }

  Future<void> toggleCompleted(String categoryId, String todoId, String? authToken) async {
    final todo =
        getCategory(categoryId).todos.firstWhere((todo) => todo.id == todoId);
    final url =
        'https://flutter-update-71bb2-default-rtdb.firebaseio.com/Todos/$userId/$categoryId/todos/$todoId.json?auth=$authToken';
    await http.patch(Uri.parse(url),
        body: json.encode({'completed': !todo.completed}));
    await DBHelper.updateTodo({
      'id': todo.id,
      'title': todo.title,
      'description': todo.description,
      'completed': !todo.completed ? 1 : 0,
      'categoryId': categoryId
    });
    todo.completed = !todo.completed;
    notifyListeners();
  }

  Future<bool> fetchAndSetFromDB() async {
    final categories = await DBHelper.getCategories();
    final List<Category> loadedData = [];
    if (categories.isNotEmpty) {
      for (int i = 0; i < categories.length; i++) {
        var todos = await DBHelper.getTodos(categories[i]["id"]);
        if (todos.isEmpty) {
          loadedData.insert(
              0,
              Category(
                  id: categories[i]["id"],
                  title: categories[i]["title"],
                  colorNumber: categories[i]["colorNumber"],
                  todos: []));
        } else {
          List<Todo> processedTodo = todos.map((todo) {
            return Todo(
              id: todo['id'],
              title: todo['title'],
              description: todo['description'],
            );
          }).toList();
          loadedData.insert(
              0,
              Category(
                  id: categories[i]["id"],
                  title: categories[i]["title"],
                  colorNumber: categories[i]["colorNumber"],
                  todos: processedTodo));
        }
      }
    }
    _items = loadedData;
    notifyListeners();
    return true;
  }

  Future<void> fetchAndsetFromSever(String? authToken) async {
    final url =
        'https://flutter-update-71bb2-default-rtdb.firebaseio.com/Todos/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    if (json.decode(response.body) != null) {
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      responseData.forEach((key, value) async {
        final categoryId = key;
        await DBHelper.addCategory({
          'id': categoryId,
          'title': value['title'],
          'colorNumber': value['colorNumber']
        });
        if (value['todos'] != null) {
          final todos = value['todos'] as Map<String, dynamic>;
          todos.forEach((key, value) async {
            await DBHelper.addTodo({
              'id': key,
              'title': value['title'],
              'description': value['description'],
              'completed': value['completed'] ? 1 : 0,
              'categoryId': categoryId
            });
          });
        }
      });
      notifyListeners();
    }
  }
}
