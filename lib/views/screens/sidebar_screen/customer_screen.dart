import 'package:flutter/material.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});
  static const String routeName = "/CustomerScreen";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: const Text(
          'Customers',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
