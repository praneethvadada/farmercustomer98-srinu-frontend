import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';



class GraphPage extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {'state': 'UP', 'cost': 9794.05, 'production': 1941.55, 'rainfall': 3373.2, 'yield': 9.83},
    {'state': 'Karnataka', 'cost': 10593.15, 'production': 2172.46, 'rainfall': 3520.7, 'yield': 7.47},
    {'state': 'Gujarat', 'cost': 13468.82, 'production': 1898.30, 'rainfall': 2957.4, 'yield': 9.59},
    {'state': 'AP', 'cost': 17051.66, 'production': 3670.54, 'rainfall': 3079.6, 'yield': 6.42},
    {'state': 'Maharashtra', 'cost': 17130.55, 'production': 2775.80, 'rainfall': 2566.7, 'yield': 8.72},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agriculture Graphs')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Cost of Cultivation (Bar Chart)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 250, child: BarChartWidget(data)),
            SizedBox(height: 20),
            Text("Production Trends (Line Chart)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 250, child: LineChartWidget(data)),
            SizedBox(height: 20),
            Text("Rainfall vs Yield (Scatter Plot)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 250, child: ScatterChartWidget(data)),
          ],
        ),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  BarChartWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: data.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                fromY: 0, // Starting point
                toY: e.value['cost'], // Updated property name
                gradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)), // Updated
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  LineChartWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value['production']);
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(colors: [Colors.green, Colors.lightGreen]),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
      ),
    );
  }
}

class ScatterChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  ScatterChartWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return ScatterChart(
      ScatterChartData(
        scatterSpots: data.map((e) {
          return ScatterSpot(e['rainfall'] / 1000, e['yield']);
        }).toList(),
      ),
    );
  }
}
