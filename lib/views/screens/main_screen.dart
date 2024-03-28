import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:admin_easyshop/views/screens/sidebar_screen/dashboard_screen.dart';
import 'package:admin_easyshop/views/screens/sidebar_screen/vendor_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Current index to manage which screen to show
  int _currentIndex = 0;

  // List of screens for easy access
  final List<Widget> _screens = [
    const DashboardScreen(),
    const VendorScreen(),
  ];

  // Function to change index
  void _changeScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  TextStyle headerStyle = GoogleFonts.roboto(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    TextStyle appBarStyle = GoogleFonts.roboto(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    return AdminScaffold(
      appBar: AppBar(
        title: Text('Admin Panel', style: appBarStyle),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            route: '/',
          ),
          AdminMenuItem(
            title: 'Vendors',
            icon: Icons.store_mall_directory,
            route: '/vendors',
          ),
        ],
        selectedRoute: '/',
        onSelected: (item) {
          // Check the title or route of the item to decide which screen to show
          if (item.route == '/') {
            _changeScreen(0);
          } else if (item.route == '/vendors') {
            _changeScreen(1); // Vendors
          }
          // Add more conditions for other screens
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: Center(
            child: Text(
              'Easy Shop',
              style: headerStyle,
            ),
          ),
        ),
        footer: SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'Logout',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
      body: _screens[_currentIndex],
    );
  }
}
