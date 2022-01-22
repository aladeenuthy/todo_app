import 'package:flutter/material.dart';
import 'package:todos_app/screens/add_category_screen.dart';
import 'package:todos_app/screens/add_todo_screen.dart';
import 'package:todos_app/screens/sign_up_screen.dart';
import 'package:todos_app/screens/view_category_screen.dart';
import 'package:todos_app/screens/view_todo_screen.dart';
import 'screens/categories_list_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        textTheme:  ThemeData.light().textTheme.copyWith(
          headline5: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
          headline6: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
          bodyText2: const TextStyle(
            fontSize: 21,
            color: Colors.grey
          )
        )
      ),
      home: const SignUpScreen(),
      routes: {
        AddCategoryScreen.routeName: (ctx) => AddCategoryScreen(),
        ViewCategotyScreen.routeName: (ctx) => const ViewCategotyScreen(),
        AddTodoScreen.routeName: (ctx) => const AddTodoScreen(),
        ViewTodoScreen.routeName: (ctx) => const ViewTodoScreen()
      },
    );
  }
}

