import 'package:flutter/material.dart';
import 'package:todos_app/models/category.dart';

class TodoGrid extends StatelessWidget {
  final Category category;
  const TodoGrid({
    Key? key,
    required this.category
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.19),
                spreadRadius: 5,
                blurRadius: 4,
                offset: const Offset(0, 3))
          ],
          borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.circle_outlined,
                  size: 35,
                  color: Colors.primaries[category.colorNumber],
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 3),
                Text(
                  "${category.todos.length.toString()} todos",
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            )
          ],
        ),

    );
  }
}
