import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth.dart';
import '/providers/todos.dart';
import '/models/http_exeption.dart';
import '/helpers/helper.dart';

class ViewTodoScreen extends StatelessWidget {
  const ViewTodoScreen({Key? key}) : super(key: key);
  static const routeName = "/view-todo";

  @override
  Widget build(BuildContext context) {
    final todoData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 96),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                        final authToken =
                            await Provider.of<Auth>(context, listen: false)
                                .getOrRefreshToken();
                        await Provider.of<Todoss>(context, listen: false)
                            .removeTodo(todoData["catId"], todoData['todo'].id, authToken);
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
          SizedBox(
            height: mediaQuery.size.height * 0.05,
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
                  builder: (ctx, todosObj, _) => Switch.adaptive(
                    value: todoData['todo'].completed,
                    onChanged: (value) async {
                      try {
                        final authToken =
                            await Provider.of<Auth>(context, listen: false)
                                .getOrRefreshToken();
                        await todosObj.toggleCompleted(
                            todoData["catId"], todoData['todo'].id, authToken);
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
