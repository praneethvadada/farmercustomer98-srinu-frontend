import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphPage extends StatelessWidget {
  final List<Map<String, dynamic>> cropData;

  GraphPage({required this.cropData});

  final List<Color> barColors = [Colors.blue, Colors.red, Colors.green]; // Colors for different years

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crop Price Analysis',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView( // ✅ Enables Y-Axis Scrolling (Vertical)
        child: Container(

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade100, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(16),
          child: cropData.isEmpty
              ? Center(child: CircularProgressIndicator()) // Show loader if data is empty
              : Column(
            children: [
              Text(
                "Grouped Bar Chart (Year-wise)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SingleChildScrollView( // ✅ Enables X-Axis Scrolling (Horizontal)
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: cropData.length * 50, // ✅ Ensures chart expands for all crops
                  height: 650, // ✅ Increased height to allow more bars
                  child: BarChart(
                    BarChartData(
                      barGroups: _generateGroupedBarData(),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < cropData.length) {
                                return Transform.rotate( // ✅ Manually rotates text
                                  angle: -1.2, // Rotates text for better readability
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      cropData[index]['name'],
                                      style: TextStyle(fontSize: 8), // ✅ Reduced font size
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                            reservedSize: 120, // ✅ Increased space for labels
                            interval: 1, // ✅ Ensures all labels are shown
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: true),
                      barTouchData: BarTouchData(enabled: true),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _buildLegend(), // ✅ Legend for year colors
            ],
          ),
        ),
      ),
    );
  }

  /// Generates grouped bar chart data
  List<BarChartGroupData> _generateGroupedBarData() {
    if (cropData.isEmpty) {
      return []; // Return empty list if cropData is empty
    }

    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < cropData.length; i++) {
      List<BarChartRodData> bars = [];
      for (int j = 0; j < cropData[i]['years'].length; j++) {
        bars.add(
          BarChartRodData(
            toY: cropData[i]['prices'][j].toDouble(),
            color: barColors[j],
            width: 3.5, // ✅ Reduced width for better spacing
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }
      barGroups.add(BarChartGroupData(x: i, barRods: bars, barsSpace: 0.5)); // ✅ Minimal space to fit more bars
    }
    return barGroups;
  }

  /// 🎨 Legend for bar colors (Year representation)
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem("2020", Colors.blue),
        SizedBox(width: 10),
        _legendItem("2021", Colors.red),
        SizedBox(width: 10),
        _legendItem("2022", Colors.green),
      ],
    );
  }

  Widget _legendItem(String year, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        SizedBox(width: 5),
        Text(year, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class GraphPage extends StatefulWidget {
//   final List<Map<String, dynamic>> cropData;
//
//   GraphPage({required this.cropData});
//
//   @override
//   _GraphPageState createState() => _GraphPageState();
// }
//
// class _GraphPageState extends State<GraphPage> {
//   String? selectedCrop;
//   List<Color> barColors = [Colors.blue, Colors.red, Colors.green]; // Colors for years
//
//   @override
//   void initState() {
//     super.initState();
//     selectedCrop = widget.cropData.isNotEmpty ? widget.cropData[0]['name'] : null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Crop Price Analysis',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.green,
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.green.shade100, Colors.blue.shade100],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // 🔽 Crop Selection Dropdown
//             // DropdownButton<String>(
//             //   value: selectedCrop,
//             //   hint: Text("Select a Crop"),
//             //   isExpanded: true,
//             //   onChanged: (String? newValue) {
//             //     setState(() {
//             //       selectedCrop = newValue;
//             //     });
//             //   },
//             //   items: widget.cropData.map((crop) {
//             //     return DropdownMenuItem<String>(
//             //       value: crop['name'],
//             //       child: Text(crop['name']),
//             //     );
//             //   }).toList(),
//             // ),
//             DropdownButton<String>(
//               value: selectedCrop,
//               hint: Text("Select a Crop"),
//               isExpanded: true,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedCrop = newValue;
//                 });
//               },
//               items: widget.cropData.map((crop) {
//                 return DropdownMenuItem<String>(
//                   value: crop['name'].toString(), // ✅ Ensure the name is a string
//                   child: Text(crop['name'].toString()), // ✅ Display full crop name
//                 );
//               }).toList(),
//             ),
//
//             SizedBox(height: 20),
//
//             // 📊 Bar Chart
//             Expanded(
//               child: selectedCrop == null
//                   ? Center(child: Text("Please select a crop to display the graph."))
//                   : BarChart(
//                 BarChartData(
//                   barGroups: _generateBarData(),
//                   titlesData: FlTitlesData(
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (double value, TitleMeta meta) {
//                           final index = value.toInt();
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Text(
//                               widget.cropData.firstWhere((crop) => crop['name'] == selectedCrop)['years'][index].toString(),
//                               style: TextStyle(fontSize: 10),
//                               textAlign: TextAlign.center,
//                             ),
//                           );
//                         },
//                         reservedSize: 30,
//                         interval: 1,
//                       ),
//                     ),
//                   ),
//                   borderData: FlBorderData(show: false),
//                   gridData: FlGridData(show: true),
//                   barTouchData: BarTouchData(enabled: true),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             _buildLegend(), // 🔹 Year Legend
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// 🔹 Generate Bar Data for Selected Crop
//   List<BarChartGroupData> _generateBarData() {
//     if (selectedCrop == null) return [];
//
//     final crop = widget.cropData.firstWhere((c) => c['name'] == selectedCrop);
//     List<BarChartRodData> bars = [];
//
//     for (int i = 0; i < crop['years'].length; i++) {
//       bars.add(
//         BarChartRodData(
//           toY: crop['prices'][i].toDouble(),
//           color: barColors[i],
//           width: 20,
//           borderRadius: BorderRadius.circular(4),
//         ),
//       );
//     }
//
//     return [BarChartGroupData(x: 0, barRods: bars, barsSpace: 5)];
//   }
//
//   /// 🔹 Year Legend
//   Widget _buildLegend() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _legendItem("2020", Colors.blue),
//         SizedBox(width: 10),
//         _legendItem("2021", Colors.red),
//         SizedBox(width: 10),
//         _legendItem("2022", Colors.green),
//       ],
//     );
//   }
//
//   Widget _legendItem(String year, Color color) {
//     return Row(
//       children: [
//         Container(width: 16, height: 16, color: color),
//         SizedBox(width: 5),
//         Text(year, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }
// }
//
// // import 'package:flutter/material.dart';
// // import 'package:fl_chart/fl_chart.dart';
// //
// // class GraphPage extends StatelessWidget {
// //   final List<Map<String, dynamic>> cropData;
// //
// //   GraphPage({required this.cropData});
// //
// //   final List<Color> barColors = [Colors.blue, Colors.red, Colors.green]; // Colors for different years
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           'Crop Price Analysis',
// //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //         ),
// //         backgroundColor: Colors.green,
// //         centerTitle: true,
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [Colors.green.shade100, Colors.blue.shade100],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ),
// //         ),
// //         padding: EdgeInsets.all(16),
// //         child: cropData.isEmpty
// //             ? Center(child: CircularProgressIndicator()) // Show loader if cropData is empty
// //             : Column(
// //           children: [
// //             Text(
// //               "Grouped Bar Chart (Year-wise)",
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 10),
// //             Expanded(
// //               child: SingleChildScrollView(
// //                 scrollDirection: Axis.horizontal,
// //                 child: SizedBox(
// //                   width: 800, // Ensures scrollability on smaller screens
// //                   height: 400,
// //                   child: BarChart(
// //                     BarChartData(
// //                       barGroups: _generateGroupedBarData(),
// //                       titlesData: FlTitlesData(
// //                         leftTitles: AxisTitles(
// //                           sideTitles: SideTitles(
// //                             showTitles: true,
// //                             reservedSize: 40,
// //                           ),
// //                         ),
// //                         bottomTitles: AxisTitles(
// //                           sideTitles: SideTitles(
// //                             showTitles: true,
// //                             getTitlesWidget: (double value, TitleMeta meta) {
// //                               final index = value.toInt();
// //                               if (index >= 0 && index < cropData.length) {
// //                                 return Padding(
// //                                   padding: const EdgeInsets.only(top: 8.0),
// //                                   child: Text(
// //                                     cropData[index]['name'],
// //                                     style: TextStyle(fontSize: 10),
// //                                     textAlign: TextAlign.center,
// //                                   ),
// //                                 );
// //                               }
// //                               return Container();
// //                             },
// //                             reservedSize: 100,
// //                             interval: 1,
// //                             // Angled labels for readability
// //                           ),
// //                         ),
// //                       ),
// //                       borderData: FlBorderData(show: false),
// //                       gridData: FlGridData(show: true),
// //                       barTouchData: BarTouchData(enabled: true),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             _buildLegend(), // Legend for year colors
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Generates grouped bar chart data
// //   List<BarChartGroupData> _generateGroupedBarData() {
// //     if (cropData.isEmpty) {
// //       return []; // Return empty list if cropData is empty
// //     }
// //
// //     List<BarChartGroupData> barGroups = [];
// //     for (int i = 0; i < cropData.length; i++) {
// //       List<BarChartRodData> bars = [];
// //       for (int j = 0; j < cropData[i]['years'].length; j++) {
// //         bars.add(
// //           BarChartRodData(
// //             toY: cropData[i]['prices'][j].toDouble(),
// //             color: barColors[j],
// //             width: 10,
// //             borderRadius: BorderRadius.circular(4),
// //           ),
// //         );
// //       }
// //       barGroups.add(BarChartGroupData(x: i, barRods: bars, barsSpace: 5));
// //     }
// //     return barGroups;
// //   }
// //
// //   /// 🎨 Legend for bar colors (Year representation)
// //   Widget _buildLegend() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         _legendItem("2020", Colors.blue),
// //         SizedBox(width: 10),
// //         _legendItem("2021", Colors.red),
// //         SizedBox(width: 10),
// //         _legendItem("2022", Colors.green),
// //       ],
// //     );
// //   }
// //
// //   Widget _legendItem(String year, Color color) {
// //     return Row(
// //       children: [
// //         Container(width: 16, height: 16, color: color),
// //         SizedBox(width: 5),
// //         Text(year, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
// //       ],
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:fl_chart/fl_chart.dart';
// // //
// // // class GraphPage extends StatelessWidget {
// // //   final List<Map<String, dynamic>> cropData = [
// // //     {"name": "Rice", "price": 3300, "year": 2020},
// // //     {"name": "Wheat", "price": 3300, "year": 2020},
// // //     {"name": "Corn", "price": 3300, "year": 2020},
// // //     {"name": "Barley", "price": 3300, "year": 2020},
// // //     {"name": "Soybean", "price": 3300, "year": 2020},
// // //     {"name": "Cotton", "price": 3300, "year": 2020},
// // //     {"name": "Sugarcane", "price": 3300, "year": 2020},
// // //     {"name": "Potato", "price": 3300, "year": 2020},
// // //     {"name": "Tomato", "price": 3300, "year": 2020},
// // //     {"name": "Onion", "price": 3300, "year": 2020},
// // //     {"name": "Peanut", "price": 3300, "year": 2020},
// // //     {"name": "Sunflower", "price": 3300, "year": 2020},
// // //     {"name": "Millet", "price": 3300, "year": 2020},
// // //     {"name": "Lentil", "price": 3300, "year": 2020},
// // //     {"name": "Chickpea", "price": 3300, "year": 2020},
// // //     {"name": "Pea", "price": 3300, "year": 2020},
// // //     {"name": "Oat", "price": 3300, "year": 2020},
// // //     {"name": "Mustard", "price": 3300, "year": 2020},
// // //     {"name": "Sesame", "price": 3300, "year": 2020},
// // //     {"name": "Sorghum", "price": 3300, "year": 2020},
// // //     {"name": "Cabbage", "price": 3300, "year": 2020},
// // //     {"name": "Carrot", "price": 3300, "year": 2020},
// // //     {"name": "Garlic", "price": 3300, "year": 2020},
// // //     {"name": "Ginger", "price": 3300, "year": 2020},
// // //     {"name": "Spinach", "price": 3300, "year": 2020},
// // //     {"name": "Lettuce", "price": 3300, "year": 2020},
// // //     {"name": "Radish", "price": 3300, "year": 2020},
// // //     {"name": "Pumpkin", "price": 3300, "year": 2020},
// // //     {"name": "Cucumber", "price": 3300, "year": 2020},
// // //     {"name": "Eggplant", "price": 3300, "year": 2020},
// // //     {"name": "Mango", "price": 3300, "year": 2020},
// // //     {"name": "Banana", "price": 3300, "year": 2020},
// // //     {"name": "Apple", "price": 3300, "year": 2020},
// // //     {"name": "Grapes", "price": 3300, "year": 2020},
// // //     {"name": "Pineapple", "price": 3300, "year": 2020},
// // //     {"name": "Papaya", "price": 3300, "year": 2020},
// // //     {"name": "Strawberry", "price": 3300, "year": 2020},
// // //     {"name": "Watermelon", "price": 3300, "year": 2020},
// // //     {"name": "Guava", "price": 3300, "year": 2020},
// // //     {"name": "Pomegranate", "price": 3300, "year": 2020},
// // //     {"name": "Coffee", "price": 3300, "year": 2020},
// // //     {"name": "Tea", "price": 3300, "year": 2020},
// // //     {"name": "Cocoa", "price": 3300, "year": 2020},
// // //     {"name": "Vanilla", "price": 3300, "year": 2020},
// // //     {"name": "Almond", "price": 3300, "year": 2020},
// // //     {"name": "Cashew", "price": 3300, "year": 2020},
// // //     {"name": "Walnut", "price": 3300, "year": 2020},
// // //     {"name": "Pistachio", "price": 3300, "year": 2020},
// // //     {"name": "Date", "price": 3300, "year": 2020},
// // //     {"name": "Fig", "price": 3300, "year": 2020},
// // //   ];
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(
// // //           'Crop Price Analysis',
// // //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // //         ),
// // //         backgroundColor: Colors.green,
// // //         centerTitle: true,
// // //       ),
// // //       body: Container(
// // //         decoration: BoxDecoration(
// // //           gradient: LinearGradient(
// // //             colors: [Colors.green.shade100, Colors.blue.shade100],
// // //             begin: Alignment.topLeft,
// // //             end: Alignment.bottomRight,
// // //           ),
// // //         ),
// // //         padding: EdgeInsets.all(16),
// // //         child: SingleChildScrollView(
// // //           scrollDirection: Axis.horizontal,
// // //           child: SizedBox(
// // //             width: 1000,
// // //             height: 400,
// // //             child: BarChart(
// // //               BarChartData(
// // //                 barGroups: _generateBarGroups(),
// // //                 titlesData: FlTitlesData(
// // //                   leftTitles: AxisTitles(
// // //                     sideTitles: SideTitles(showTitles: true, reservedSize: 40),
// // //                   ),
// // //                   bottomTitles: AxisTitles(
// // //                     sideTitles: SideTitles(
// // //                       showTitles: true,
// // //                       getTitlesWidget: (double value, TitleMeta meta) {
// // //                         final index = value.toInt();
// // //                         if (index >= 0 && index < cropData.length) {
// // //                           return Text(
// // //                             cropData[index]['name'],
// // //                             style: TextStyle(fontSize: 10),
// // //                           );
// // //                         }
// // //                         return Container();
// // //                       },
// // //                       reservedSize: 100,
// // //                       interval: 1,
// // //                       // rotateAngle: 60,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 borderData: FlBorderData(show: false),
// // //                 gridData: FlGridData(show: true),
// // //                 barTouchData: BarTouchData(enabled: true),
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   List<BarChartGroupData> _generateBarGroups() {
// // //     List<BarChartGroupData> barGroups = [];
// // //     for (int i = 0; i < cropData.length; i++) {
// // //       barGroups.add(
// // //         BarChartGroupData(
// // //           x: i,
// // //           barRods: [
// // //             BarChartRodData(
// // //               toY: cropData[i]['price'].toDouble(),
// // //               color: Colors.green,
// // //               width: 12,
// // //               borderRadius: BorderRadius.circular(4),
// // //             ),
// // //           ],
// // //         ),
// // //       );
// // //     }
// // //     return barGroups;
// // //   }
// // // }
// // //
// // //
// // //
// // //
// // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:fl_chart/fl_chart.dart';
// // // //
// // // //
// // // //
// // // // class GraphPage extends StatelessWidget {
// // // //   final List<Map<String, dynamic>> data = [
// // // //     {'state': 'UP', 'cost': 9794.05, 'production': 1941.55, 'rainfall': 3373.2, 'yield': 9.83},
// // // //     {'state': 'Karnataka', 'cost': 10593.15, 'production': 2172.46, 'rainfall': 3520.7, 'yield': 7.47},
// // // //     {'state': 'Gujarat', 'cost': 13468.82, 'production': 1898.30, 'rainfall': 2957.4, 'yield': 9.59},
// // // //     {'state': 'AP', 'cost': 17051.66, 'production': 3670.54, 'rainfall': 3079.6, 'yield': 6.42},
// // // //     {'state': 'Maharashtra', 'cost': 17130.55, 'production': 2775.80, 'rainfall': 2566.7, 'yield': 8.72},
// // // //   ];
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: Text('Agriculture Graphs')),
// // // //       body: SingleChildScrollView(
// // // //         child: Column(
// // // //           children: [
// // // //             SizedBox(height: 20),
// // // //             Text("Cost of Cultivation (Bar Chart)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // // //             SizedBox(height: 250, child: BarChartWidget(data)),
// // // //             SizedBox(height: 20),
// // // //             Text("Production Trends (Line Chart)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // // //             SizedBox(height: 250, child: LineChartWidget(data)),
// // // //             SizedBox(height: 20),
// // // //             Text("Rainfall vs Yield (Scatter Plot)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // // //             SizedBox(height: 250, child: ScatterChartWidget(data)),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //
// // // //
// // // //
// // // // class BarChartWidget extends StatelessWidget {
// // // //   final List<Map<String, dynamic>> data;
// // // //   BarChartWidget(this.data);
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return BarChart(
// // // //       BarChartData(
// // // //         barGroups: data.asMap().entries.map((e) {
// // // //           return BarChartGroupData(
// // // //             x: e.key,
// // // //             barRods: [
// // // //               BarChartRodData(
// // // //                 fromY: 0, // Starting point
// // // //                 toY: e.value['cost'], // Updated property name
// // // //                 gradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
// // // //               ),
// // // //             ],
// // // //           );
// // // //         }).toList(),
// // // //         titlesData: FlTitlesData(
// // // //           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)), // Updated
// // // //           bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //
// // // // class LineChartWidget extends StatelessWidget {
// // // //   final List<Map<String, dynamic>> data;
// // // //   LineChartWidget(this.data);
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return LineChart(
// // // //       LineChartData(
// // // //         lineBarsData: [
// // // //           LineChartBarData(
// // // //             spots: data.asMap().entries.map((e) {
// // // //               return FlSpot(e.key.toDouble(), e.value['production']);
// // // //             }).toList(),
// // // //             isCurved: true,
// // // //             gradient: LinearGradient(colors: [Colors.green, Colors.lightGreen]),
// // // //           ),
// // // //         ],
// // // //         titlesData: FlTitlesData(
// // // //           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
// // // //           bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //
// // // // class ScatterChartWidget extends StatelessWidget {
// // // //   final List<Map<String, dynamic>> data;
// // // //   ScatterChartWidget(this.data);
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return ScatterChart(
// // // //       ScatterChartData(
// // // //         scatterSpots: data.map((e) {
// // // //           return ScatterSpot(e['rainfall'] / 1000, e['yield']);
// // // //         }).toList(),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
