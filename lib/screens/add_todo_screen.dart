import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/http_exeption.dart';
import '/providers/auth.dart';
import '/providers/todos.dart';
import '/widget/input_form.dart';
import '/helpers/helper.dart';

class AddTodoScreen extends StatelessWidget {
  static const routeName = "/add-todo";
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  AddTodoScreen({Key? key}) : super(key: key);

  void _submitTodoData(BuildContext context, String catId) async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      final isOnline = await Helper.hasNetwork();
      if (isOnline) {
        try {
          Helper.showLoadingDialog(context);
          final authToken = await Provider.of<Auth>(context, listen: false).getOrRefreshToken();
          await Provider.of<Todoss>(context, listen: false).addTodo(
              catId,
              _titleController.text,
              _descriptionController.text,
              authToken
              );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } on HttpException catch (error) {
          Navigator.of(context).pop();
          Helper.showErrorDialog(context, error.toString());
        }
      } else {
        Helper.showErrorDialog(context, "connect to internet");
      }
    } else {
      Navigator.of(context).pop();
      Helper.showErrorDialog(context, "fill all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final catData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              IconButton(
                  onPressed: () {
                    _submitTodoData(context, catData['catId']);
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
      body: InputForm(
        titleController: _titleController,
        descriptionController: _descriptionController,
        catColor: catData['catColor']
      ),
    );
  }
}
