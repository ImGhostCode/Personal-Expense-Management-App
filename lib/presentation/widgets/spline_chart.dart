import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SplineChart extends StatefulWidget {
  const SplineChart({super.key});

  @override
  State<SplineChart> createState() => _SplineChartState();
}

class _SplineChartState extends State<SplineChart> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData1 = [
      ChartData(2010, 35),
      ChartData(2011, 13),
      ChartData(2012, 34),
      ChartData(2013, 27),
      ChartData(2014, 40)
    ];
    final List<ChartData> chartData2 = [
      ChartData(2010, 23),
      ChartData(2011, 53),
      ChartData(2012, 24),
      ChartData(2013, 57),
      ChartData(2014, 30)
    ];
    return SizedBox(
      width: double.infinity,
      height: 350,
      child: SfCartesianChart(series: <ChartSeries>[
        // Renders spline chart
        SplineSeries<ChartData, int>(
            color: Colors.green,
            dataSource: chartData1,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y),
        SplineSeries<ChartData, int>(
            color: Colors.red,
            dataSource: chartData2,
            xValueMapper: (ChartData data1, _) => data1.x,
            yValueMapper: (ChartData data1, _) => data1.y)
      ]),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double? y;
}
