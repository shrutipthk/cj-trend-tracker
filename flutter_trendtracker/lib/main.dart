import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(CJTrendsApp());

class CJTrendsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: TrendDashboard(),
    );
  }
}

class TrendDashboard extends StatefulWidget {
  @override
  _TrendDashboardState createState() => _TrendDashboardState();
}

class _TrendDashboardState extends State<TrendDashboard> {
  final String apiUrl = 'http://127.0.0.1:8080/api/trends/global';
  
  get index => null;

  Future<List<dynamic>> fetchTrends() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Connection Error');
    }
  }
  void _showGrowthChart(BuildContext context, dynamic trend) {

  final Map<String, dynamic> data = Map<String, dynamic>.from(trend);
  final String itemName = data['trend_item']?.toString() ?? "Unknown Product";
  double finalGrowth = double.tryParse(trend['growth_rate'].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 5.0;
  int seed = trend['trend_item'].toString().length;

  double rawGrowth = double.tryParse(data['growth_rate'].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 5.0;
  double displayGrowth = (rawGrowth / 10).clamp(3.0, 10.0);
  double chartCeiling = 12.0;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    builder: (context) => Container(
      padding: const EdgeInsets.all(24),
      height: 400,
      child: Column(
        children: [
          Text("${trend['trend_item']} Trend", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0, 
                maxY: chartCeiling,
                minX: 0,
                maxX: 4,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, (1.0 + (seed % 2)).toDouble()),
                      FlSpot(1, (2.0 + (seed % 3)).toDouble()), 
                      FlSpot(2, (1.5 + (seed % 2)).toDouble()),
                      FlSpot(3, displayGrowth - 2), 
                      FlSpot(4, displayGrowth),
                    ],
                    isCurved: true,
                    color: const Color(0xFF004B91),
                    barWidth: 4,
                    dotData: const FlDotData(show: true), 
                    belowBarData: BarAreaData(
                      show: true, 
                      color: const Color(0xFF004B91).withOpacity(0.1)
                    ),
                  ),
                ],
                titlesData: const FlTitlesData(show: false),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          Text("Official GSP Growth: ${trend['growth_rate']}", 
               style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: const Color(0xFFE21B22),
  elevation: 4,
  centerTitle: true,
  leadingWidth: 80, 
  leading: Padding(
    padding: const EdgeInsets.only(left: 12.0),
    child: Image.asset(
      'assets/CJ_logo.png', 
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Text("CJ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
        );
      },
    ),
  ),
  title: const Text(
    "Global GSP Sensor",
    style: TextStyle(
      color: Colors.white,
      fontSize: 18, 
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  ),
  actions: [
    const Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: Icon(Icons.notifications_none, color: Colors.white),
    ),
  ],
),
      body: FutureBuilder<List<dynamic>>(
        future: fetchTrends(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Status: Server Offline"));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var trend = snapshot.data![index];
                return InkWell(
                  onTap: () => {_showGrowthChart(context, trend)},
                  borderRadius: BorderRadius.circular(12),
                  child: Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text("GSP", style: TextStyle(color: Color(0xFFE21B22), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(trend['trend_item'] ?? 'No Name', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Market Growth: ${trend['growth_rate']}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(trend['market_fit'] ?? 'Global', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        Icon(Icons.trending_up, size: 16, color: Colors.green),
                      ],
                    ),
                  ),
                  )
                );
              },
            );
          }
        },
      ),
    );
  }
}