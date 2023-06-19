import 'package:expanse_management/data/utilty.dart';
import 'package:expanse_management/domain/models/transaction_model.dart';
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
  bool hour = true;
  bool day = true;
  bool month = true;
  @override
  Widget build(BuildContext context) {
    switch (widget.currIndex) {
      case 0:
        currListTransaction = getTransactionToday();
        hour = true;
        day = true;
        month = false;
        break;
      case 1:
        currListTransaction = getTransactionWeek();
        hour = false;
        day = true;
        month = false;
        break;
      case 2:
        currListTransaction = getTransactionMonth();
        hour = false;
        day = true;
        month = false;

        break;
      case 3:
        currListTransaction = getTransactionYear();
        hour = false;
        day = false;
        month = true;
        break;
      default:
    }
    var container = SizedBox(
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
                    time(currListTransaction!, hour, day, month).length,
                    (index) {
                  return SalesData(
                      day
                          ? hour
                              ? currListTransaction![index]
                                  .createAt
                                  .hour
                                  .toString()
                              : currListTransaction![index]
                                  .createAt
                                  .day
                                  .toString()
                          : currListTransaction![index]
                              .createAt
                              .month
                              .toString(),
                      day
                          ? index > 0
                              ? time(currListTransaction!, false, true, false)[index] +
                                  time(currListTransaction!, false, true,
                                      false)[index - 1]
                              : time(currListTransaction!, false, true, false)[
                                  index]
                          : month
                              ? index > 0
                                  ? time(currListTransaction!, false, false, true)[index] +
                                      time(currListTransaction!, false, false,
                                          true)[index - 1]
                                  : time(currListTransaction!, false, false,
                                      true)[index]
                              : index > 0
                                  ? time(currListTransaction!, false, false, false)[index] +
                                      time(currListTransaction!, false, false,
                                          false)[index - 1]
                                  : time(currListTransaction!, false, false,
                                      false)[index]);
                })
              ],
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales),
        ],
      ),
    );
    return container;
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final int sales;
}
