import 'package:flutter/material.dart';
import 'package:todos_app/screens/add_category_screen.dart';
import 'package:todos_app/screens/view_category_screen.dart';
import 'package:todos_app/widget/create_grid.dart';
import 'package:todos_app/widget/todo_category.dart';
import 'package:todos_app/providers/todos.dart';
import 'package:provider/provider.dart';

class TodoCategories extends StatelessWidget {
  const TodoCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Todoss>(context, listen: false).fetchAndSetFromDB(),
      builder: (ctx, snapShot) => snapShot.connectionState == ConnectionState.waiting? const SizedBox( height: 200, child:  Center(child: CircularProgressIndicator(color: Colors.grey,),)) : Consumer<Todoss>(
        builder: (ctx, todosObj, _) => GridView.count(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 20,
          childAspectRatio: 2.4 / 2,
          children: [
            ...todosObj.items.map((category) => GestureDetector(
              child: TodoGrid(category: category),
              onTap: () => Navigator.of(context).pushNamed(ViewCategotyScreen.routeName, arguments: category),
              )).toList(), 
              if(todosObj.items.length < 8)
            GestureDetector(
              child: const CreateGrid(),
              onTap: () {
                Navigator.of(context).pushNamed(AddCategoryScreen.routeName);
              },
            )
          ],
        ),
      ),
    );
  }
}
