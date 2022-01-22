import 'package:flutter/material.dart';
import 'package:todos_app/screens/view_todo_screen.dart';

class Todos extends StatelessWidget {
  const Todos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (ctx, i) => Dismissible(
        onDismissed: (direction) {},
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
        key: Key(i.toString()),
        child: ListTile(
          leading: IconButton(
              onPressed: () {}, icon: const Icon(Icons.minimize_outlined)),
          title: const Text("wash"),
          onTap: () {
            Navigator.of(context).pushNamed(ViewTodoScreen.routeName);
          },
        ),
      ),
      itemCount: 9,
      separatorBuilder: (context, i) => const Divider(
        thickness: 1,
      ),
    );
  }
}
