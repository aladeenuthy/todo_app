import 'package:flutter/material.dart';
class CreateGrid extends StatelessWidget {
  const CreateGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.19),
                spreadRadius: 5,
                blurRadius: 4,
                offset: const Offset(0, 3))
          ],
          borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(
                Icons.add,
                size: 35,
                color: Colors.indigo,
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          )
        ],
      ),
    );
  }
}
