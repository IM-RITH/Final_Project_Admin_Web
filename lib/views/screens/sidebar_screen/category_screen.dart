import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});
  static const String routeName = "/CategoryScreen";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: const Text(
          'Category',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
