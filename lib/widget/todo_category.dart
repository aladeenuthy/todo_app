import 'package:flutter/material.dart';
class TodoCategory extends StatelessWidget {
  const TodoCategory({ Key? key }) : super(key: key);

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
            offset: const Offset(0, 3)
          )
      ],
      borderRadius: BorderRadius.circular(15)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.circle_outlined, size: 35, color: Colors.indigo,)
          ],
        ),
        const SizedBox(height: 25,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("home", style: Theme.of(context).textTheme.headline6,),
            Text("0 tasks", style: Theme.of(context).textTheme.bodyText2,)

          ],
        )
      ],),
    );
  }
}