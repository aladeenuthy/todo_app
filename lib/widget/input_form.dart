import 'package:flutter/material.dart';
class InputForm extends StatefulWidget {
  const InputForm({ Key? key }) : super(key: key);

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay? _pickedTime;
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
              const Icon(
                Icons.circle_outlined,
                size: 32,
                color: Colors.orange,
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: TextField(
                  cursorHeight: 30,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                      fontSize: 29,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(
                          fontSize: 22,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                  controller: _titleController,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            cursorColor: Colors.black,
            cursorHeight: 20,
            maxLines: 4,
            style: const TextStyle(
                fontSize: 21, color: Colors.black, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(
                  fontSize: 19,
                  color: Colors.grey,
                )),
            controller: _descriptionController,
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey)),
                child: TextButton.icon(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            _pickedTime = value;
                          });
                        }
                      });
                    },
                    icon: Icon(
                      Icons.timelapse,
                      color: Theme.of(context).textTheme.bodyText2!.color,
                    ),
                    label: Text(
                      "Pick time to start",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2!.color,
                          fontSize: 19),
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              if (_pickedTime != null)
                Text(
                  "${_pickedTime!.hour}:${_pickedTime!.minute}: ${_pickedTime!.period.name}",
                  style: const TextStyle(fontSize: 20, color: Colors.orange),
                )
            ],
          ),
        ],
      ),
    );
  }
}