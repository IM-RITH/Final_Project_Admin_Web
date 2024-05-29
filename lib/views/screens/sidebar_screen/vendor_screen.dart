import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});
  static const String routeName = "/VendorScreen";

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";

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

  Widget _buildVendorRow(DocumentSnapshot vendor) {
    final data = vendor.data() as Map<String, dynamic>?;
    bool isApproved = data?['approved'] ?? false;

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
                data?['storeImage'] ?? '',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return const Icon(Icons.store, size: 40);
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
                data?['storeName'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data?['email'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${data?['city'] ?? ''}, ${data?['state'] ?? ''}, ${data?['country'] ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: isApproved
                    ? null
                    : () {
                        _firestore
                            .collection('vendors')
                            .doc(vendor.id)
                            .update({'approved': true});
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isApproved ? const Color(0xFF141E46) : Colors.green,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: Text(
                  isApproved ? 'Approved' : 'Approve',
                  style: TextStyle(
                    color: isApproved ? Colors.black : Colors.white,
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

  void _searchVendor(String query) {
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
                    'Vendors',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const Spacer(),
                  if (_isSearching)
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Vendors',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchVendor('');
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                        onChanged: (value) {
                          _searchVendor(value);
                        },
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
                  'Store Logo',
                  Icons.store,
                  1,
                  backgroundColor: Colors.blueGrey.shade50,
                ),
                _buildRow(
                  'Store Name',
                  Icons.person,
                  2,
                  backgroundColor: Colors.blueGrey.shade50,
                ),
                _buildRow(
                  'Email',
                  Icons.email,
                  2,
                  backgroundColor: Colors.blueGrey.shade50,
                ),
                _buildRow(
                  'Address',
                  Icons.map,
                  3,
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
              stream: _firestore.collection('vendors').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final vendorDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>?;
                  final storeName =
                      data?['storeName'].toString().toLowerCase() ?? '';
                  return _searchQuery.isEmpty ||
                      storeName.contains(_searchQuery);
                }).toList();

                vendorDocs.sort((a, b) {
                  final dataA = a.data() as Map<String, dynamic>?;
                  final dataB = b.data() as Map<String, dynamic>?;
                  final approvedA = dataA?['approved'] ?? false;
                  final approvedB = dataB?['approved'] ?? false;
                  return approvedA == approvedB ? 0 : (approvedA ? 1 : -1);
                });

                return Column(
                  children: vendorDocs.map((doc) {
                    return _buildVendorRow(doc);
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
