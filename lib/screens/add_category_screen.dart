import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app/models/http_exeption.dart';
import 'package:todos_app/models/todo_error.dart';
import 'package:todos_app/providers/todos.dart';
import 'package:todos_app/helpers/helper.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);
  static const routeName = "/add-category";

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _categorNameController = TextEditingController();
  var _isLoading = false;

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
                  Icons.close,
                  size: 40,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            actions: [
              _isLoading
                  ? Transform.scale(
                      scale: 0.6,
                      child: const SizedBox(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                          strokeWidth: 4.0,
                        ),
                        width: 50,
                      ),
                    )
                  : IconButton(
                      onPressed: () async {
                        if (_categorNameController.text.isEmpty) {
                          return;
                        }
                        final isOnline = await Helper.hasNetwork();
                        if (isOnline) {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await Provider.of<Todoss>(context, listen: false)
                                .addCategory(_categorNameController.text,
                                    Random().nextInt(Colors.primaries.length));
                            Navigator.of(context).pop();
                          } on TodoException catch (error) {
                            Helper.showErrorDialog(context, error.toString());
                          } on HttpException catch (error) {
                            Helper.showErrorDialog(context, error.toString());
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          Helper.showErrorDialog(context,"No internet connection");
                        }
                      },
                      icon: const Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.grey,
                      ))
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 50),
        width: 350,
        child: TextField(
          cursorHeight: 30,
          style: const TextStyle(
              fontSize: 29, color: Colors.black, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Category Name',
              hintStyle: TextStyle(
                  fontSize: 29,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold)),
          controller: _categorNameController,
        ),
      ),
    );
  }
}
