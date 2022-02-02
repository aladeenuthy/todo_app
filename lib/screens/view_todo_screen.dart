import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app/providers/todos.dart';
import 'package:todos_app/models/http_exeption.dart';
import 'package:todos_app/helpers/helper.dart';

class ViewTodoScreen extends StatelessWidget {
  const ViewTodoScreen({Key? key}) : super(key: key);
  static const routeName = "/view-todo";

  @override
  Widget build(BuildContext context) {
    final todoData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 96),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.keyboard_return,
                  size: 35,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    final isOnline = await Helper.hasNetwork();
                    if (isOnline) {
                      try {
                        Helper.showLoadingDialog(context);
                        await Provider.of<Todoss>(context, listen: false)
                            .removeTodo(todoData["catId"], todoData['todo'].id);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("todo removed")));
                      } on HttpException catch (_) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("could not remove todo")));
                      }
                    } else {
                      Helper.showErrorDialog(context, "connect to internet");
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 35,
                    color: Colors.grey,
                  ))
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.only(left: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todoData['todo'].title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  todoData['todo'].description,
                  style: Theme.of(context).textTheme.bodyText2,
                  softWrap: true,
                ),
                const SizedBox(height: 15),
                Consumer<Todoss>(
                  builder: (ctx, todosObj, _) => Switch(
                    value: todoData['todo'].completed,
                    onChanged: (value) async {
                      try {
                        await todosObj.toggleCompleted(
                            todoData["catId"], todoData['todo'].id);
                      } catch (error) {
                        Helper.showErrorDialog(context, "connect to internet");
                      }
                    },
                    activeColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
