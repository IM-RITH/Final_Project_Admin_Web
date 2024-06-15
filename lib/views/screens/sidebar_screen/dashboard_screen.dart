import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const String routeName = "/DashboardScreen";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _totalBuyers = 0;
  int _totalVendors = 0;
  double _totalSales = 0.0;
  double _previousWeekSales = 0.0;
  List<SalesData> _salesData = [];
  double _buyerChange = 0.0;
  double _vendorChange = 0.0;
  double _salesChange = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      // Fetch data for buyers
      final buyersSnapshot = await _firestore.collection('buyers').get();
      final previousWeekBuyersSnapshot = await _firestore
          .collection('buyers')
          .where('created_at',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(const Duration(days: 14)))
          .where('created_at',
              isLessThan: DateTime.now().subtract(const Duration(days: 7)))
          .get();
      final currentWeekBuyersSnapshot = await _firestore
          .collection('buyers')
          .where('created_at',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(const Duration(days: 7)))
          .get();

      // Fetch data for vendors
      final vendorsSnapshot = await _firestore.collection('vendors').get();
      final previousWeekVendorsSnapshot = await _firestore
          .collection('vendors')
          .where('created_at',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(const Duration(days: 14)))
          .where('created_at',
              isLessThan: DateTime.now().subtract(const Duration(days: 7)))
          .get();
      final currentWeekVendorsSnapshot = await _firestore
          .collection('vendors')
          .where('created_at',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(const Duration(days: 7)))
          .get();

      // Fetch data for sales
      final ordersSnapshot = await _firestore.collection('orders').get();
      final previousWeekOrdersSnapshot = await _firestore
          .collection('orders')
          .where('date',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(const Duration(days: 14)))
          .where('date',
              isLessThan: DateTime.now().subtract(const Duration(days: 7)))
          .get();
      final currentWeekOrdersSnapshot = await _firestore
          .collection('orders')
          .where('date',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(const Duration(days: 7)))
          .get();

      double totalSales = 0.0;
      Map<String, double> salesByDay = {};

      for (var doc in ordersSnapshot.docs) {
        final data = doc.data();
        final double totalPrice = data['totalPrice']?.toDouble() ?? 0.0;
        totalSales += totalPrice;

        // Parse the date and extract the day
        Timestamp dateTimestamp = data['date'];
        DateTime date = dateTimestamp.toDate();
        String day = DateFormat.yMMMd().format(date);

        if (salesByDay.containsKey(day)) {
          salesByDay[day] = salesByDay[day]! + totalPrice;
        } else {
          salesByDay[day] = totalPrice;
        }
      }

      double previousWeekSales = 0.0;
      for (var doc in previousWeekOrdersSnapshot.docs) {
        final data = doc.data();
        final double totalPrice = data['totalPrice']?.toDouble() ?? 0.0;
        previousWeekSales += totalPrice;
      }

      setState(() {
        _totalBuyers = buyersSnapshot.docs.length;
        _totalVendors = vendorsSnapshot.docs.length;
        _totalSales = totalSales;
        _previousWeekSales = previousWeekSales;
        _salesData = salesByDay.entries
            .map((entry) => SalesData(entry.key, entry.value))
            .toList();
        _buyerChange = previousWeekBuyersSnapshot.docs.isEmpty
            ? 0
            : (currentWeekBuyersSnapshot.docs.length -
                    previousWeekBuyersSnapshot.docs.length) /
                previousWeekBuyersSnapshot.docs.length *
                100;
        _vendorChange = previousWeekVendorsSnapshot.docs.isEmpty
            ? 0
            : (currentWeekVendorsSnapshot.docs.length -
                    previousWeekVendorsSnapshot.docs.length) /
                previousWeekVendorsSnapshot.docs.length *
                100;
        _salesChange = previousWeekSales == 0
            ? 0
            : (totalSales - previousWeekSales) / previousWeekSales * 100;
      });
    } catch (e) {
      print("Error fetching dashboard data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDashboardCard('Total Buyers', _totalBuyers.toString(),
                      Colors.blue, _buyerChange, Icons.person),
                  _buildDashboardCard('Total Vendors', _totalVendors.toString(),
                      Colors.green, _vendorChange, Icons.store),
                  _buildDashboardCard(
                      'Total Sales',
                      '\$${_totalSales.toStringAsFixed(2)}',
                      Colors.red,
                      _salesChange,
                      Icons.attach_money),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Sales Overview',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    labelFormat: '{value}',
                    title: AxisTitle(text: 'Sales'),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<SalesData, String>>[
                    ColumnSeries<SalesData, String>(
                      dataSource: _salesData,
                      xValueMapper: (SalesData sales, _) => sales.day,
                      yValueMapper: (SalesData sales, _) => sales.sales,
                      name: 'Sales',
                      gradient: const LinearGradient(
                        colors: <Color>[Colors.blue, Colors.lightBlueAccent],
                        stops: <double>[0.2, 0.9],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value, Color color,
      double percentageChange, IconData icon) {
    String changeText = percentageChange.isNaN
        ? "N/A"
        : percentageChange >= 0
            ? "+${percentageChange.toStringAsFixed(2)}%"
            : "${percentageChange.toStringAsFixed(2)}%";
    Color changeColor = percentageChange >= 0 ? Colors.green : Colors.red;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color(0xFF22213B),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              changeText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: changeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  final String day;
  final double sales;

  SalesData(this.day, this.sales);
}
