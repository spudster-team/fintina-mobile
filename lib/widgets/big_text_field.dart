import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  const CustomTextArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [const TextField(
          maxLines: 30,
          decoration: InputDecoration(
            fillColor: Colors.white,
          ),
        ),]
      ),
    );
  }
}
