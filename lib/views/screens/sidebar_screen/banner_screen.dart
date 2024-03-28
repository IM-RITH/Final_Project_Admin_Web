import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});
  static const String routeName = "/BannerScreen";

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
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.cyan),
                  ),
                  child: Center(
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
                      onPressed: () {},
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
        ],
      ),
    );
  }
}
