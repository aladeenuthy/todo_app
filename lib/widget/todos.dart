import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app/models/todo.dart';
import 'package:todos_app/providers/todos.dart';
import 'package:todos_app/screens/view_todo_screen.dart';
import 'package:todos_app/helpers/helper.dart';
import 'package:todos_app/models/http_exeption.dart';

class Todos extends StatelessWidget {
  final List<Todo> todos;
  final String catId;
  const Todos({Key? key, required this.todos, required this.catId})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (ctx, i) => Dismissible(
        onDismissed: (direction) async {
          final isOnline = await Helper.hasNetwork();
          if (isOnline) {
            try {
              Helper.showLoadingDialog(context);
              await Provider.of<Todoss>(context, listen: false)
                  .removeTodo(catId, todos[i].id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("todo removed")));
            } on HttpException catch (_) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("could not remove todo")));
            }
          } else {
            Navigator.of(context).pop();
            Helper.showErrorDialog(context, "connect to internet");
          }
        },
        background: Container(
          child: const Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(right: 18),
          color: Colors.red,
          alignment: Alignment.centerRight,
        ),
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        child: ListTile(
          leading: IconButton(
              onPressed: () {}, icon: const Icon(Icons.minimize_outlined)),
          title: Text(todos[i].title),
          onTap: () {
            Navigator.of(context).pushNamed(ViewTodoScreen.routeName,
                arguments: {"todo": todos[i], "catId": catId});
          },
        ),
      ),
      itemCount: todos.length,
      separatorBuilder: (context, i) => const Divider(
        thickness: 1,
      ),
    );
  }
}
