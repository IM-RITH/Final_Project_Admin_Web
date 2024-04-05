import 'package:flutter/material.dart';

class VendorScreen extends StatelessWidget {
  const VendorScreen({super.key});
  static const String routeName = "/VendorScreen";

  // Row
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
              'Vendors',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
            ),
          ),
          Row(
            children: [
              _buildRow(
                'Store Logo',
                Icons.store,
                1,
              ),
              _buildRow('Store Name', Icons.person, 2),
              _buildRow('Email', Icons.email, 2),
              _buildRow('Address', Icons.map, 3),
              _buildRow('Action', Icons.more_vert, 1),
              _buildRow('View More', Icons.arrow_forward, 1),
            ],
          )
        ],
      ),
    );
  }
}
