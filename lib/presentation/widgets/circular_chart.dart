import 'package:expanse_management/Constants/color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
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
  final Map<String, double> mapIncomeData = {};
  final Map<String, double> mapExpenseData = {};
  final List<ChartData> incomeData = [];
  final List<ChartData> expenseData = [];

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, color: primaryColor);
    super.initState();
    calculateChartData();
  }

  @override
  void didUpdateWidget(CircularChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currIndex != oldWidget.currIndex ||
        widget.transactions != oldWidget.transactions) {
      calculateChartData();
    }
  }

  void calculateChartData() {
    mapExpenseData.clear();
    mapIncomeData.clear();
    for (var transaction in widget.transactions) {
      if (transaction.type == 'Income') {
        if (mapIncomeData.containsKey(transaction.category.title)) {
          mapIncomeData[transaction.category.title] =
              mapIncomeData[transaction.category.title]! +
                  double.parse(transaction.amount);
        } else {
          mapIncomeData[transaction.category.title] =
              double.parse(transaction.amount);
        }
      } else {
        if (mapExpenseData.containsKey(transaction.category.title)) {
          mapExpenseData[transaction.category.title] =
              mapExpenseData[transaction.category.title]! +
                  double.parse(transaction.amount);
        } else {
          mapExpenseData[transaction.category.title] =
              double.parse(transaction.amount);
        }
      }
    }

    incomeData.clear();
    expenseData.clear();

    mapIncomeData.forEach((key, value) {
      incomeData.add(ChartData(key, value));
    });
    mapExpenseData.forEach((key, value) {
      expenseData.add(ChartData(key, value));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == 'Income' && incomeData.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: 130,
        child: Opacity(
            opacity: 0.2, child: Image.asset('images/ChartIllustrator.png')),
      );
    } else if (widget.title == 'Expense' && expenseData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SizedBox(
          width: double.infinity,
          height: 130,
          child: Opacity(
              opacity: 0.2, child: Image.asset('images/ChartIllustrator.png')),
        ),
      );
    }
    return SizedBox(
        width: double.infinity,
        height: 220,
        child: SfCircularChart(
            palette: widget.title == 'Income'
                ? const <Color>[
                    Colors.lightGreenAccent,
                    Colors.green,
                    Colors.cyanAccent,
                    Colors.blue,
                    Colors.indigo,
                    Colors.teal
                  ]
                : const <Color>[
                    Colors.red,
                    Colors.amberAccent,
                    Colors.deepPurpleAccent,
                    Colors.pinkAccent,
                    Colors.brown,
                    Colors.orange
                  ],
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
                  dataSource:
                      widget.title == 'Income' ? incomeData : expenseData,
                  //  pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  dataLabelMapper: (ChartData data, _) =>
                      '${NumberFormat.compactCurrency(
                        symbol: '',
                        decimalDigits: 1,
                      ).format(data.y / 1000000)}M',
                  animationDuration: 1000,
                  dataLabelSettings: const DataLabelSettings(
                      showZeroValue: true,
                      isVisible: true,
                      labelIntersectAction: LabelIntersectAction.shift,
                      labelPosition: ChartDataLabelPosition.outside,
                      connectorLineSettings: ConnectorLineSettings(
                          type: ConnectorType.curve, length: '25%'))),
            ]));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
  // final Color color;
}
