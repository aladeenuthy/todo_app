import 'package:todos_app/models/todo.dart';

class Category {
  String id;
  String title;
  int colorNumber;
  List<Todo> todos;
  Category(
      { required this.id, required this.title, required this.colorNumber, required this.todos});
}
