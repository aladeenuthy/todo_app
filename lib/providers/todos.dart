import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todos_app/models/http_exeption.dart';
import 'package:todos_app/models/todo.dart';
import 'package:todos_app/models/todo_error.dart';
import 'package:todos_app/helpers/db_helper.dart';
import 'package:todos_app/models/category.dart';

class Todoss with ChangeNotifier {
  List<Category> _items;
  final String? authToken;
  final String userId;
  Todoss(this.authToken, this.userId, this._items);

  List<Category> get items {
    return [..._items];
  }

  // category related
  Future<void> addCategory(String title, int colorNumber) async {
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

  Future<void> removeCategory(String catId) async {
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

  Future<void> addTodo(String categoryId, String title, String description,
      TimeOfDay startTIme) async {
    final url =
        'https://flutter-update-71bb2-default-rtdb.firebaseio.com/Todos/$userId/$categoryId/todos.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            "title": title,
            "description": description,
            'completed': false,
            "startTime": startTIme.toString(),
          }));
      await DBHelper.addTodo({
        "id": json.decode(response.body)['name'],
        "title": title,
        "description": description,
        "startTime": startTIme.toString(),
        'completed': 0,
        "categoryId": categoryId
      });
      getCategory(categoryId).todos.insert(
          0,
          Todo(
              id: json.decode(response.body)['name'],
              title: title,
              description: description,
              startTime: startTIme));
      notifyListeners();
    } catch (error) {
      throw HttpException("a problem occured while adding a todo");
    }
  }

  Future<void> removeTodo(String categoryId, String todoId) async {
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

  Future<void> toggleCompleted(String categoryId, String todoId) async {
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
      'startTime': todo.startTime.toString(),
      'completed': !todo.completed ? 1 : 0,
      'categoryId': categoryId
    });
    todo.completed = !todo.completed;
    notifyListeners();
  }

  Future<void> fetchAndSetFromDB() async {
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
            var time = todo['startTime'].split("(")[1].split(")")[0];
            time = TimeOfDay(
                hour: int.parse(time.split(":")[0]),
                minute: int.parse(time.split(":")[1]));
            return Todo(
                id: todo['id'],
                title: todo['title'],
                description: todo['description'],
                startTime: time);
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
  }
}
