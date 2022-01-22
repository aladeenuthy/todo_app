import 'package:flutter/material.dart';

class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({Key? key}) : super(key: key);
  static const routeName = "/add-category";

  final _categorNameController = TextEditingController();
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
              IconButton(
                  onPressed: () {},
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
