import 'package:flutter/material.dart';
import 'package:todos_app/screens/add_todo_screen.dart';
import 'package:todos_app/widget/todos.dart';

class ViewCategotyScreen extends StatelessWidget {
  const ViewCategotyScreen({Key? key}) : super(key: key);
  static const routeName = '/view-category';

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
        children: [
          const SizedBox(
            height: 70,
          ),
          Container(
            margin: const EdgeInsets.only(left: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.circle_outlined,
                      size: 35,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 9,
                    ),
                    Text("Home")
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 45),
                  child: Text("0 task"),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          const Expanded(child: Todos())
        ],
      ),
      floatingActionButton: SizedBox(
        height: 75,
        child: FloatingActionButton(
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Colors.orange,
          onPressed: () {
            Navigator.of(context).pushNamed(AddTodoScreen.routeName);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          elevation: 0,
        ),
      ),
      floatingActionButtonLocation: const CustomFloatingActionButtonLocation(),
    );
  }
}

class CustomFloatingActionButtonLocation
    implements FloatingActionButtonLocation {
  static const double fabIconHeight = 50.0;

  const CustomFloatingActionButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
        scaffoldGeometry.scaffoldSize.width - 50,
        scaffoldGeometry.scaffoldSize.height -
            (50.0 / 2.7) -
            fabIconHeight -
            (fabIconHeight / 2));
  }
}
