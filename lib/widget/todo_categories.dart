import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/add_category_screen.dart';
import '/screens/view_category_screen.dart';
import '/widget/create_grid.dart';
import '/widget/todo_category.dart';
import '/providers/todos.dart';


class TodoCategories extends StatefulWidget {
  const TodoCategories({Key? key}) : super(key: key);
  @override
  State<TodoCategories> createState() => _TodoCategoriesState();
}

class _TodoCategoriesState extends State<TodoCategories> {
  Future? _fetchFromDB;

  @override
  void initState() {
    _fetchFromDB =
        Provider.of<Todoss>(context, listen: false).fetchAndSetFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchFromDB,
        builder: (ctx, snapShot) {
          if (snapShot.hasData) {
            return Consumer<Todoss>(
              builder: (ctx, todosObj, _) => GridView.count(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 20,
                childAspectRatio: 2.3 / 2,
                children: [
                  ...todosObj.items
                      .map((category) => GestureDetector(
                            child: TodoGrid(category: category),
                            onTap: () => Navigator.of(context).pushNamed(
                                ViewCategotyScreen.routeName,
                                arguments: category),
                          ))
                      .toList(),
                  if (todosObj.items.length < 8)
                    GestureDetector(
                      child: const CreateGrid(),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AddCategoryScreen.routeName);
                      },
                    )
                ],
              ),
            );
          } else {
            return const Padding(
                padding: EdgeInsets.only(top: 200),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ));
          }
        });
  }
}
