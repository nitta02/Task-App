// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:taskie_app/widgets/custom_text.dart';

class CustomContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  const CustomContainer({
    Key? key,
    required this.height,
    required this.width,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color.fromARGB(255, 223, 222, 222),
      ),
      child: child,
    );
  }
}
