import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  static const String routeName = "/ProductScreen";

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";

  Widget _buildRow(String text, IconData icon, int flex,
      {Color? backgroundColor}) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 50,
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

  Widget _buildProductRow(DocumentSnapshot product) {
    final data = product.data() as Map<String, dynamic>?;
    final String firstImage =
        (data?['imageUrlList'] as List<dynamic>?)?.first ?? '';
    final String productName = data?['productName'] ?? '';
    final int productPrice = data?['productPrice'] ?? 0;

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
                firstImage,
                width: 45,
                height: 45,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
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
                '\$$productPrice',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showProductDetails(data);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    ),
                    child: const Text(
                      'View More',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      _deleteProduct(product.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(String productId) {
    _firestore.collection('products').doc(productId).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: $error')),
      );
    });
  }

  void _showProductDetails(Map<String, dynamic>? data) {
    if (data == null) return;

    // Convert Timestamp to DateTime
    Timestamp createdAtTimestamp = data['createdAt'];
    DateTime createdAt = createdAtTimestamp.toDate();
    String formattedDate = DateFormat.yMMMd().format(createdAt);

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
                    '\$${data['productPrice']}',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow('Description', data['productDescription']),
                  const SizedBox(height: 10),
                  _buildDetailRow('Category', data['category']),
                  const SizedBox(height: 10),
                  _buildDetailRow('Brand Name', data['brandName']),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                      'Quantity', data['productQuantity'].toString()),
                  const SizedBox(height: 10),
                  _buildDetailRow('Shipping Fees', '\$${data['shippingFees']}'),
                  const SizedBox(height: 10),
                  _buildDetailRow('In Stock', data['instock']),
                  const SizedBox(height: 10),
                  _buildDetailRow('City', data['city']),
                  const SizedBox(height: 10),
                  _buildDetailRow('State', data['state']),
                  const SizedBox(height: 10),
                  _buildDetailRow('Country', data['country']),
                  const SizedBox(height: 10),
                  _buildDetailRow('Store Name', data['storeName']),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Store Image: ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(data['storeImage']),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow('Created At', formattedDate),
                  const SizedBox(height: 10),
                  _buildDetailRow('Size List',
                      (data['sizeList'] as List<dynamic>).join(', ')),
                  const SizedBox(height: 10),
                  _buildDetailRow('Color List',
                      (data['colorList'] as List<dynamic>).join(', ')),
                  const SizedBox(height: 20),
                  const Text(
                    'Product Images:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  _buildImageGallery(data['imageUrlList'] as List<dynamic>),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageGallery(List<dynamic> imageUrlList) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: 3.0,
      ),
      itemCount: imageUrlList.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrlList[index],
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 40);
              },
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

  void _searchProduct(String query) {
    setState(() {
      _searchQuery = query.toLowerCase(); // Convert query to lowercase
    });
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
                    'Products',
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
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Products',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _searchProduct('');
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                          ),
                          onChanged: (value) {
                            _searchProduct(value);
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
                  'Image',
                  Icons.image,
                  1,
                  backgroundColor: Colors.blueGrey.shade50,
                ),
                _buildRow(
                  'Name',
                  Icons.label,
                  2,
                  backgroundColor: Colors.blueGrey.shade50,
                ),
                _buildRow(
                  'Price',
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
              stream: _firestore.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final productDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>?;
                  final productName =
                      data?['productName'].toString().toLowerCase() ?? '';
                  return _searchQuery.isEmpty ||
                      productName.contains(_searchQuery);
                }).toList();

                return Column(
                  children: productDocs.map((doc) {
                    return _buildProductRow(doc);
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
