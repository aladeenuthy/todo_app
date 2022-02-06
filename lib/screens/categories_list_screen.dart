import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/providers/auth.dart';
import '/widget/todo_categories.dart';
import '/providers/todos.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  var isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.get("isFetched") == null) {
        setState(() {
          isLoading = true;
        });
        final authToken =
            await Provider.of<Auth>(context, listen: false).getOrRefreshToken();
        await Provider.of<Todoss>(context, listen: false)
            .fetchAndsetFromSever(authToken);
        setState(() {
          isLoading = false;
        });
        prefs.setBool("isFetched", true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: mediaQuery.size.height * 0.19),
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
                        height: 15,
                      ),
                      isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(top: 200),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.grey,
                              )),
                            )
                          : const TodoCategories()
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
        onPressed: () async {
          Provider.of<Auth>(context, listen: false).logout();
        },
      ),
    );
  }
}
