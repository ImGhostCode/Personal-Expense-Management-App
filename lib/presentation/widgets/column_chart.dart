import 'package:expanse_management/domain/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:expanse_management/Constants/color.dart';

class ColumnChart extends StatefulWidget {
  final List<Transaction> transactions;
  final int currIndex;
  const ColumnChart(
      {super.key, required this.transactions, required this.currIndex});

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  late TooltipBehavior _tooltipBehavior;
  List<String> customFormats = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  // List<ChartData> chartDataIncome = [];
  // List<ChartData> chartDataExpense = [];
  final List<ChartData> chartData = [];

  Map<String, List<double>> mapData = {};
  DateFormat dateFormat = DateFormat.MMM();

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, color: primaryColor);
    super.initState();
    calculateChartData();
  }

  @override
  void didUpdateWidget(ColumnChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currIndex != oldWidget.currIndex ||
        widget.transactions != oldWidget.transactions) {
      calculateChartData();
    }
  }

  void calculateChartData() {
    mapData.clear();

    for (var element in widget.transactions) {
      String formattedDate =
          getFormattedDate(widget.currIndex, element.createAt);
      if (mapData.containsKey(formattedDate)) {
        if (element.type == 'Income') {
          mapData[formattedDate]![0] += double.parse(element.amount);
        } else {
          mapData[formattedDate]![1] += double.parse(element.amount);
        }
      } else {
        mapData[formattedDate] = [0, 0];
        if (element.type == 'Income') {
          mapData[formattedDate]![0] = double.parse(element.amount);
        } else {
          mapData[formattedDate]![1] = double.parse(element.amount);
        }
      }
    }

    chartData.clear();

    mapData.forEach((key, value) {
      chartData.add(ChartData(key, value[0], value[1]));
    });

    chartData.sort((a, b) => a.x.compareTo(b.x));
  }

  String getFormattedDate(int index, DateTime dateTime) {
    if (index == 3) {
      return customFormats[dateTime.month - 1];
    } else {
      return '${dateFormat.format(dateTime)} ${dateTime.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 380,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
            // labelRotation: -45,
            // labelIntersectAction: AxisLabelIntersectAction.rotate45,
            ),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat.compact(),
          // maximum: 20000000,
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          toggleSeriesVisibility: true,
        ),
        //Enables the tooltip for all the series
        tooltipBehavior: _tooltipBehavior,
        series: <ChartSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
            name: 'Income',
            dataSource: chartData,
            color: Colors.green,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            // markerSettings: const MarkerSettings(isVisible: true),
            dataLabelSettings: const DataLabelSettings(
                // Renders the data label
                isVisible: false),
            enableTooltip: true,
          ),
          ColumnSeries<ChartData, String>(
            name: 'Expense',
            color: Colors.red,
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y1,
            // markerSettings: const MarkerSettings(isVisible: true),
            dataLabelSettings: const DataLabelSettings(
                // Renders the data label
                isVisible: false),
            enableTooltip: true,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x;
  final double y;
  final double y1;
}
