import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app/models/http_exeption.dart';
import 'package:todos_app/providers/todos.dart';
import 'package:todos_app/widget/input_form.dart';
import 'package:todos_app/helpers/helper.dart';

class AddTodoScreen extends StatelessWidget {
  static const routeName = "/add-todo";
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay? pickedTime;

  void _saveStartTime(TimeOfDay startTime) {
    pickedTime = startTime;
  }



  void _submitTodoData(BuildContext context, String catId) async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        pickedTime != null) {
      final isOnline = await Helper.hasNetwork();
      if (isOnline) {
        try {
          Helper.showLoadingDialog(context);
          await Provider.of<Todoss>(context, listen: false).addTodo(
              catId,
              _titleController.text,
              _descriptionController.text,
              pickedTime as TimeOfDay);
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
    final catId = ModalRoute.of(context)!.settings.arguments as String;
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
                    _submitTodoData(context, catId);
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
        saveStartTime: _saveStartTime,
      ),
    );
  }
}
