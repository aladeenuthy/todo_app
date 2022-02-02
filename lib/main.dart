import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app/providers/auth.dart';
import 'package:todos_app/screens/add_category_screen.dart';
import 'package:todos_app/screens/add_todo_screen.dart';
import 'package:todos_app/screens/auth_screen.dart';
import 'package:todos_app/screens/view_category_screen.dart';
import 'package:todos_app/screens/view_todo_screen.dart';
import 'screens/categories_list_screen.dart';
import 'package:todos_app/providers/todos.dart';
import 'package:todos_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Todoss>(
            create: (_) => Todoss("", "", []),
            update: (ctx, auth, previousProducts) => Todoss(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items)),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline5: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                  headline6: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                  bodyText2: const TextStyle(fontSize: 21, color: Colors.grey)),
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: const Color.fromRGBO(78, 77, 157, 1.0))),
          home: auth.isAuth
              ? const CategoriesListScreen()
              : FutureBuilder(
                  future: auth.tryAutLogin(),
                  builder: (ctx, snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            AddCategoryScreen.routeName: (ctx) => const AddCategoryScreen(),
            ViewCategotyScreen.routeName: (ctx) => const ViewCategotyScreen(),
            AddTodoScreen.routeName: (ctx) => AddTodoScreen(),
            ViewTodoScreen.routeName: (ctx) => const ViewTodoScreen()
          },
        ),
      ),
    );
  }
}
