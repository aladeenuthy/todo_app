import 'package:flutter/material.dart';
import 'package:todos_app/screens/add_category_screen.dart';
import 'package:todos_app/screens/view_category_screen.dart';
import 'package:todos_app/widget/create_grid.dart';
import 'package:todos_app/widget/todo_category.dart';

class TodoCategories extends StatelessWidget {
  const TodoCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 20,
      childAspectRatio: 2.4 / 2,
      children: [
        ...List.generate(6, (index) => GestureDetector(
                  child: const TodoCategory(),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(ViewCategotyScreen.routeName);
                  },
                )),
        GestureDetector(
          child: const CreateGrid(),
          onTap: () {
            Navigator.of(context).pushNamed(AddCategoryScreen.routeName);
          },
        )
      ],
    );
  }
}
