import 'package:expanse_management/Constants/color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../domain/models/transaction_model.dart';

class CircularChart extends StatefulWidget {
  final String title;
  final List<Transaction> transactions;
  final int currIndex;
  const CircularChart(
      {super.key,
      required this.title,
      required this.currIndex,
      required this.transactions});

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, color: primaryColor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];
    return SizedBox(
        width: double.infinity,
        height: 250,
        child: SfCircularChart(
            title: ChartTitle(
                text: widget.title,
                textStyle: TextStyle(
                    color:
                        widget.title == 'Income' ? Colors.green : Colors.red)),
            legend: Legend(isVisible: true),
            tooltipBehavior: _tooltipBehavior,
            series: <CircularSeries>[
              // Render pie chart
              DoughnutSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  dataLabelSettings: const DataLabelSettings(isVisible: true)),
            ]));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
  // final Color color;
}
