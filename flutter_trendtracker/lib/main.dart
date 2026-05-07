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
                return Card(
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
                );
              },
            );
          }
        },
      ),
    );
  }
}