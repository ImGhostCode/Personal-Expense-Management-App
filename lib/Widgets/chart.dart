import 'package:expanse_management/data/utilty.dart';
import 'package:expanse_management/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  int currIndex;
  Chart({super.key, required this.currIndex});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Transaction>? currListTransaction;
  bool b = true;
  bool j = true;
  @override
  Widget build(BuildContext context) {
    switch (widget.currIndex) {
      case 0:
        currListTransaction = getTransactionToday();
        b = true;
        j = true;
        break;
      case 1:
        currListTransaction = getTransactionWeek();
        b = false;
        j = true;
        break;
      case 2:
        currListTransaction = getTransactionMonth();
        b = false;
        j = true;
        break;
      case 3:
        currListTransaction = getTransactionYear();

        j = false;
        break;
      default:
    }
    return Container(
      width: double.infinity,
      height: 380,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <SplineSeries<SalesData, String>>[
          SplineSeries<SalesData, String>(
              color: Colors.green,
              width: 3,
              dataSource: <SalesData>[
                ...List.generate(
                    time(currListTransaction!, b ? true : false).length,
                    (index) {
                  return SalesData(
                      j
                          ? b
                              ? currListTransaction![index]
                                  .datetime
                                  .hour
                                  .toString()
                              : currListTransaction![index]
                                  .datetime
                                  .day
                                  .toString()
                          : currListTransaction![index]
                              .datetime
                              .month
                              .toString(),
                      b
                          ? index > 0
                              ? time(currListTransaction!, true)[index] +
                                  time(currListTransaction!, true)[index - 1]
                              : time(currListTransaction!, true)[index]
                          : index > 0
                              ? time(currListTransaction!, false)[index] +
                                  time(currListTransaction!, false)[index - 1]
                              : time(currListTransaction!, false)[index]);
                })
              ],
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final int sales;
}
