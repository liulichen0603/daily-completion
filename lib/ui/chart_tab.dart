import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 300,
        margin: EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            barGroups: _createSampleData(),
            titlesData: FlTitlesData(
              leftTitles: SideTitles(showTitles: true),
              bottomTitles: SideTitles(showTitles: true),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createSampleData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            y: 5,
            color: Colors.blue,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            y: 25,
            color: Colors.green,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            y: 100,
            color: Colors.orange,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            y: 75,
            color: Colors.red,
          ),
        ],
      ),
    ];
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fl Chart Example'),
        ),
        body: ChartTab(),
      ),
    ),
  );
}
