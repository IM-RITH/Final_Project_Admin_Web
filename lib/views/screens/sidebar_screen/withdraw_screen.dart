import 'package:flutter/material.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});
  static const String routeName = "/WithdrawScreen";

  Widget _buildRow(String text, IconData icon, int flex,
      {Color? backgroundColor}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          color: backgroundColor,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, color: Colors.blueGrey.shade700),
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Withdraw',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
            ),
          ),
          Row(
            children: [
              _buildRow('Name', Icons.person, 2),
              _buildRow('Amount', Icons.attach_money_outlined, 1),
              _buildRow('Email', Icons.email, 2),
              _buildRow('Phone', Icons.phone, 2),
              _buildRow('Bank', Icons.account_balance, 2),
              _buildRow('Bank Account Name', Icons.text_snippet, 2),
            ],
          )
        ],
      ),
    );
  }
}
