import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/category.dart';
import '/providers/auth.dart';
import '/providers/todos.dart';
import '/screens/add_todo_screen.dart';
import '/widget/todos.dart';
import '/models/http_exeption.dart';
import '/helpers/helper.dart';

class ViewCategotyScreen extends StatelessWidget {
  const ViewCategotyScreen({Key? key}) : super(key: key);
  static const routeName = '/view-category';


  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as Category;
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 96),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                  onPressed: () async {
                    final isOnline = await Helper.hasNetwork();
                    if (isOnline) {
                      try {
                        Helper.showLoadingDialog(context);
                        final authToken =
                            await Provider.of<Auth>(context, listen: false)
                                .getOrRefreshToken();
                        await Provider.of<Todoss>(context, listen: false)
                            .removeCategory(category.id, authToken);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } on HttpException catch (error) {
                        Navigator.of(context).pop();
                        Helper.showErrorDialog(context, error.toString());
                      }
                    } else {
                      Helper.showErrorDialog(context, "Connect to internet");
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 35,
                    color: Colors.grey,
                  ))
            ],
          ),
        ),
      ),
      body: Consumer<Todoss>(
        builder: (ctx, todo, _) => Column(
          children: [
            SizedBox(
              height: mediaQuery.size.height * 0.09,
            ),
            Container(
              margin: const EdgeInsets.only(left: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        size: 35,
                        color: Colors.primaries[category.colorNumber],
                      ),
                      const SizedBox(
                        width: 9,
                      ),
                      Text(category.title, style:Theme.of(context).textTheme.headline6)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45),
                    child: Text("${category.todos.length} task"),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Expanded(
                child: Todos(
              todos: category.todos,
              catId: category.id,
            ))
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 75,
        child: FloatingActionButton(
          backgroundColor: Colors.primaries[category.colorNumber] ,
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(AddTodoScreen.routeName, arguments: {'catId':category.id, 'catColor': category.colorNumber});
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
