// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart_app/util/extensions/color_extensions.dart';
import 'dart:math';

import 'package:expanse_management/data/utilty.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartDetail extends StatefulWidget {
  int currIndex;

  BarChartDetail({super.key, required this.currIndex});
  // final Color leftBarColor = const Color(0xFFFFC300);
  // final Color rightBarColor = const Color(0xFFE80054);
  // final Color avgColor = Colors.redAccent;
  final Color leftBarColor = Colors.green;
  final Color rightBarColor = const Color(0xFFE80054);
  final Color avgColor = Colors.greenAccent;

  // final Color leftBarColor = AppColors.contentColorYellow;
  // final Color rightBarColor = AppColors.contentColorRed;
  // final Color avgColor =
  //     AppColors.contentColorOrange.avg(AppColors.contentColorRed);
  @override
  State<StatefulWidget> createState() => BarChartDetailState();
}

class BarChartDetailState extends State<BarChartDetail> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;
  late double maxYValue;
  @override
  void initState() {
    super.initState();

    Map<int, double> weeklyIncome = calculateWeeklyIncome();
    Map<int, double> weeklyExpense = calculateWeeklyExpense();
    maxYValue = max(
        weeklyIncome.values
            .toList()
            .reduce((value, element) => value > element ? value : element),
        weeklyExpense.values
            .toList()
            .reduce((value, element) => value > element ? value : element));

    final barGroup1 = makeGroupData(
        0, weeklyIncome.values.elementAt(0), weeklyExpense.values.elementAt(0));
    final barGroup2 = makeGroupData(
        1, weeklyIncome.values.elementAt(1), weeklyExpense.values.elementAt(1));
    final barGroup3 = makeGroupData(
        2, weeklyIncome.values.elementAt(2), weeklyExpense.values.elementAt(2));
    final barGroup4 = makeGroupData(
        3, weeklyIncome.values.elementAt(3), weeklyExpense.values.elementAt(3));
    final barGroup5 = makeGroupData(
        4, weeklyIncome.values.elementAt(4), weeklyExpense.values.elementAt(4));
    final barGroup6 = makeGroupData(
        5, weeklyIncome.values.elementAt(5), weeklyExpense.values.elementAt(5));
    final barGroup7 = makeGroupData(
        6, weeklyIncome.values.elementAt(6), weeklyExpense.values.elementAt(6));

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // const Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            //     SizedBox(
            //       width: 38,
            //     ),
            //     Text(
            //       'Transactions',
            //       style: TextStyle(color: Colors.red, fontSize: 22),
            //     ),
            //     SizedBox(
            //       width: 4,
            //     ),
            //     Text(
            //       'state',
            //       style: TextStyle(color: Color(0xff77839a), fontSize: 16),
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 10000,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                              in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: showingBarGroups[touchedGroupIndex]
                                .barRods
                                .map((rod) {
                              return rod.copyWith(
                                  toY: avg, color: widget.avgColor);
                            }).toList(),
                          );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 50,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 1000) {
      text = '1K';
    } else if (value == 5000) {
      text = '5K';
    } else if (value == 10000) {
      text = '10K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: const Color(0xff368983).withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: const Color(0xff368983).withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: const Color(0xff368983).withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: const Color(0xff368983).withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: const Color(0xff368983).withOpacity(0.4),
        ),
      ],
    );
  }
}
