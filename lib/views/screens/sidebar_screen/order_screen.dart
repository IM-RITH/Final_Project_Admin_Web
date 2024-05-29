import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isSearching = false;

  void _searchOrders(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  Widget _buildRow(String text, IconData icon, int flex,
      {Color? backgroundColor}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          color: backgroundColor ?? Colors.white,
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

  Widget _buildOrderRow(DocumentSnapshot order, BuildContext context) {
    final data = order.data() as Map<String, dynamic>?;
    final List<dynamic> productImages = data?['productImage'] ?? [];
    final String productImage =
        productImages.isNotEmpty ? productImages.first : '';
    final String productName = data?['productName'] ?? '';
    final String buyerName = data?['buyerName'] ?? '';
    final double totalPrice = data?['totalPrice']?.toDouble() ?? 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 1),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                productImage,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return const Icon(Icons.image, size: 40);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                productName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                buyerName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _showOrderDetails(data, context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic>? data, BuildContext context) {
    if (data == null) return;

    // Convert Timestamp to DateTime
    Timestamp dateTimestamp = data['date'];
    DateTime date = dateTimestamp.toDate();
    String formattedDate = DateFormat.yMMMd().format(date);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['productName'],
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${data['totalPrice']}',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow('Buyer Name', data['buyerName']),
                  const SizedBox(height: 10),
                  _buildDetailRow('Buyer Email', data['buyerEmail']),
                  const SizedBox(height: 10),
                  _buildDetailRow('Phone', data['phone']),
                  const SizedBox(height: 10),
                  _buildDetailRow('Address', data['address']),
                  const SizedBox(height: 10),
                  _buildDetailRow('Payment Method', data['paymentMethod']),
                  const SizedBox(height: 10),
                  _buildDetailRow('Quantity', data['quantity'].toString()),
                  const SizedBox(height: 10),
                  _buildDetailRow('Shipping Fees', '\$${data['shippingFees']}'),
                  const SizedBox(height: 10),
                  _buildDetailRow('Date', formattedDate),
                  const SizedBox(height: 10),
                  _buildStatusRow('Accepted', data['accept']),
                  const SizedBox(height: 10),
                  _buildStatusRow('Delivered', data['delivered']),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String title, bool status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status ? 'Yes' : 'No',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text(
                    'Orders',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const Spacer(),
                  if (_isSearching)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              offset: const Offset(0, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by product or buyer name',
                            border: InputBorder.none,
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = "";
                                  _searchController.clear();
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                          onChanged: (value) {
                            _searchOrders(value);
                          },
                        ),
                      ),
                    ),
                  IconButton(
                    icon: Icon(_isSearching ? Icons.close : Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchQuery = "";
                          _searchController.clear();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _buildRow(
                  'Product Image',
                  Icons.image,
                  1,
                  backgroundColor: Colors.blueGrey.shade50,
                ),
                _buildRow(
                  'Product Name',
                  Icons.label,
                  2,
                  backgroundColor: Colors.blueGrey.shade50,
                ),
                _buildRow(
                  'Buyer Name',
                  Icons.person,
                  2,
                  backgroundColor: Colors.blueGrey.shade50,
                ),
                _buildRow(
                  'Total Price',
                  Icons.attach_money,
                  2,
                  backgroundColor: Colors.blueGrey.shade50,
                ),
                _buildRow(
                  'Action',
                  Icons.more_vert,
                  1,
                  backgroundColor: Colors.blueGrey.shade50,
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('orders').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orderDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>?;
                  final productName =
                      data?['productName'].toString().toLowerCase() ?? '';
                  final buyerName =
                      data?['buyerName'].toString().toLowerCase() ?? '';
                  return _searchQuery.isEmpty ||
                      productName.contains(_searchQuery) ||
                      buyerName.contains(_searchQuery);
                }).toList();

                return Column(
                  children: orderDocs.map((doc) {
                    return _buildOrderRow(doc, context);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
