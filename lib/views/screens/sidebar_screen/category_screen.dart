import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  static const String routeName = "/CategoryScreen";

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController _categoryNameController = TextEditingController();

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle bannerText = GoogleFonts.roboto(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
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
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: sectionTitle,
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      height: 150,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.cyan),
                      ),
                      child: Center(
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
                            // pickImage();
                          },
                          icon: const Icon(Icons.cloud_upload, size: 18),
                          label: Text('Upload', style: buttonText),
                          style: buttonStyle,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.save, size: 18),
                          label: Text('Save', style: buttonText),
                          style: buttonStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 400.0,
                  height: 50.0,
                  child: TextFormField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter category name',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
