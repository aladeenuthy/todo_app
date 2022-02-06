import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final int catColor;
  const InputForm({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.catColor
  }) : super(key: key);

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 50),
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle_outlined,
                size: 32,
                color: Colors.primaries[widget.catColor],
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: TextField(
                  cursorHeight: 30,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)
                          ),
                  controller: widget.titleController,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            cursorColor: Colors.black,
            cursorHeight: 25,
            maxLines: 4,         
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.primaries[widget.catColor], width: 2.0),
                ) ,
                hintText: 'Description',
                hintStyle: const TextStyle(
                  fontSize: 21,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                        BorderSide(color: Colors.primaries[widget.catColor], width: 2.0),
                ),
                ),
            controller: widget.descriptionController,
          ),
        ],
      ),
    );
  }
}
