import 'package:flutter/material.dart';

class ViewTodoScreen extends StatelessWidget {
  const ViewTodoScreen({Key? key}) : super(key: key);
  static const routeName = "/view-todo";

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {},
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
                  "home",
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "this is a test thsis is kjf sjdfj jsdfo kfjajj  jfjaij",
                  style: Theme.of(context).textTheme.bodyText2,
                  softWrap: true,
                ),
                const SizedBox(height: 15),
                Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: Colors.orange,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
