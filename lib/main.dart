import "dart:io";

import "package:admin_easyshop/views/screens/main_screen.dart";
import "package:admin_easyshop/views/screens/sidebar_screen/dashboard_screen.dart";
import "package:admin_easyshop/views/screens/sidebar_screen/vendor_screen.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? const FirebaseOptions(
              apiKey: "AIzaSyA0gFGyRukY6VdKMBrV6_zm3k1R8xl34YU",
              appId: "1:726625939599:web:580ab4a1d2ceb5f78b00fa",
              messagingSenderId: "726625939599",
              projectId: "easyshop-project-efff5",
              storageBucket: "easyshop-project-efff5.appspot.com")
          : null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      routes: {
        DashboardScreen.routeName: (context) => const DashboardScreen(),
        VendorScreen.routeName: (context) => const VendorScreen()
      },
    );
  }
}
