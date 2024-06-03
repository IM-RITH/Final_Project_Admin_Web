import 'package:admin_easyshop/views/screens/sidebar_screen/widgets/category_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  static const String routeName = "/CategoryScreen";

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirebaseStorage _storageReference = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController _categoryNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  dynamic _image;
  String? fileName;
  late String categoryName;
  bool _isLoading = false;

  Future<void> _pickImage() async {
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
        _storageReference.ref().child('CategoryImages').child(fileName!);
    UploadTask uploadTask = platformRef.putData(image);

    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  // upload to database
  Future<void> uploadCategory() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No image selected. Please pick an image first.')),
        );
        return;
      }
      setState(
        () => _isLoading = true,
      );
      try {
        String imgUrl = await _uploadFile(_image);
        await _db.collection("categories").doc(fileName).set({
          "categoryName": categoryName,
          "image": imgUrl,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category uploaded successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category uploaded successfully!'),
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle bannerText = GoogleFonts.roboto(
      fontSize: 20,
      color: Colors.grey,
      fontWeight: FontWeight.w600,
    );
    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(120, 40),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    );
    TextStyle buttonText = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    TextStyle sectionTitle = GoogleFonts.roboto(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: Colors.blueGrey,
    );

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Category',
                style: sectionTitle,
              ),
              const Divider(color: Colors.grey),
              Row(
                children: [
                  Container(
                    height: 200,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueGrey),
                    ),
                    child: _image != null
                        ? Image.memory(
                            _image,
                            fit: BoxFit.contain,
                          )
                        : Center(
                            child: Text(
                              "Category Image",
                              style: bannerText,
                            ),
                          ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _pickImage();
                        },
                        icon: const Icon(Icons.cloud_upload, size: 18),
                        label: Text('Upload', style: buttonText),
                        style: buttonStyle,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : uploadCategory,
                        icon: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Icon(Icons.save, size: 18),
                        label: Text(_isLoading ? 'In Progress...' : 'Save',
                            style: buttonText),
                        style: buttonStyle,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: SizedBox(
                  width: 250.0,
                  child: TextFormField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter category name',
                      labelStyle: const TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.w500),
                      prefixIcon:
                          const Icon(Icons.category, color: Colors.blueGrey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) => {
                      categoryName = value,
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Category name is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Category",
                  style: sectionTitle,
                ),
              ),
              const Divider(color: Colors.grey),
              const CategoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
