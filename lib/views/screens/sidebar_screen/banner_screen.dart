import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});
  static const String routeName = "/BannerScreen";

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final FirebaseStorage _storageReference = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  dynamic _image;
  String? fileName;
  bool _isLoading = false;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.single.name;
      });
    }
  }

  Future<String> _uploadFile(dynamic image) async {
    Reference platformRef =
        _storageReference.ref().child('Banners').child(fileName!);
    UploadTask uploadTask = platformRef.putData(image);

    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> addImageToFirebaseStore() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No image selected. Please pick an image first.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String imageUrl = await _uploadFile(_image);
      await _db.collection("banners").doc(fileName).set({
        "image": imageUrl,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle bannerText = GoogleFonts.roboto(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    // Define a button style
    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(120, 40),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
    TextStyle buttonText = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    TextStyle sectionTitle = const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Manage Banners',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.cyan),
                  ),
                  child: _image != null
                      ? Image.memory(
                          _image,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Text(
                            "Banners",
                            style: bannerText,
                          ),
                        ),
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        pickImage();
                      },
                      icon: const Icon(Icons.cloud_upload, size: 18),
                      label: Text('Upload', style: buttonText),
                      style: buttonStyle,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : addImageToFirebaseStore,
                      icon: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white))
                          : const Icon(Icons.save, size: 18),
                      label: Text(_isLoading ? 'In Progress...' : 'Save',
                          style: buttonText),
                      style: buttonStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Banners",
              style: sectionTitle,
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.cyan),
                  ),
                  child: const Center(
                    child: Text("Image"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
