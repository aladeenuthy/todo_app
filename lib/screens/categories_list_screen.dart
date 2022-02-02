import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app/providers/auth.dart';
import 'package:todos_app/widget/todo_categories.dart';

class CategoriesListScreen extends StatelessWidget {
  const CategoriesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 110),
                Container(
                  margin: const EdgeInsets.only(left: 40),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ToDoS!",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const TodoCategories()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        onPressed: () {
          Provider.of<Auth>(context, listen: false).logout();
        },
      ),
    );
  }
}
