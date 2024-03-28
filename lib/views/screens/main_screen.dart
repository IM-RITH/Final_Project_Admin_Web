import 'package:admin_easyshop/views/screens/sidebar_screen/banner_screen.dart';
import 'package:admin_easyshop/views/screens/sidebar_screen/category_screen.dart';
import 'package:admin_easyshop/views/screens/sidebar_screen/customer_screen.dart';
import 'package:admin_easyshop/views/screens/sidebar_screen/order_screen.dart';
import 'package:admin_easyshop/views/screens/sidebar_screen/product_screen.dart';
import 'package:admin_easyshop/views/screens/sidebar_screen/withdraw_screen.dart';
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
    const CategoryScreen(),
    const ProductScreen(),
    const VendorScreen(),
    const CustomerScreen(),
    const BannerScreen(),
    const OrderScreen(),
    const WithdrawScreen()
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
            title: 'Categories',
            icon: Icons.category,
            route: '/categories',
          ),
          AdminMenuItem(
            title: 'Products',
            icon: Icons.shopping_bag,
            route: '/products',
          ),
          AdminMenuItem(
            title: 'Vendors',
            icon: Icons.store_mall_directory,
            route: '/vendors',
          ),
          AdminMenuItem(
            title: 'Customers',
            icon: Icons.people,
            route: '/customers',
          ),
          AdminMenuItem(
            title: 'Banners',
            icon: Icons.branding_watermark,
            route: '/banners',
          ),
          AdminMenuItem(
            title: 'Orders',
            icon: Icons.list,
            route: '/orders',
          ),
          AdminMenuItem(
            title: 'Withdrawal',
            icon: Icons.currency_exchange,
            route: '/withdrawal',
          ),
        ],
        selectedRoute: '/',
        onSelected: (item) {
          // Check the title or route of the item to decide which screen to show
          if (item.route == '/') {
            _changeScreen(0);
          } else if (item.route == '/categories') {
            _changeScreen(1);
          } else if (item.route == '/products') {
            _changeScreen(2);
          } else if (item.route == '/vendors') {
            _changeScreen(3);
          } else if (item.route == '/customers') {
            _changeScreen(4);
          } else if (item.route == '/banners') {
            _changeScreen(5);
          } else if (item.route == '/orders') {
            _changeScreen(6);
          } else {
            _changeScreen(7);
          }
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
