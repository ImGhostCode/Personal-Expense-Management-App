// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:expanse_management/data/utilty.dart';
import 'package:expanse_management/domain/models/transaction_model.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

class PieChartDay extends StatefulWidget {
  const PieChartDay({super.key, required listTransactions});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;
  List<Transaction> expenseTransactionsPerDay = [];
  int? total;
  final categoryAmountMap = <String, double>{};
  @override
  void initState() {
    super.initState();
    // box.listenable().addListener(updateExpenseTransactions);
    updateExpenseTransactions();
  }

  // @override
  // void dispose() {
  //   // box.listenable().removeListener(updateExpenseTransactions);
  //   // box.listenable().removeListener(fetchTransactions);

  //   super.dispose();
  // }

  void updateExpenseTransactions() {
    expenseTransactionsPerDay = getExpenseTransactionToday();

    categoryAmountMap.clear();

    for (var i = 0; i < expenseTransactionsPerDay.length; i++) {
      if (categoryAmountMap
          .containsKey(expenseTransactionsPerDay[i].category.title)) {
        categoryAmountMap[expenseTransactionsPerDay[i].category.title] =
            categoryAmountMap[expenseTransactionsPerDay[i].category.title]! +
                double.parse(expenseTransactionsPerDay[i].amount);
      } else {
        categoryAmountMap[expenseTransactionsPerDay[i].category.title] =
            double.parse(expenseTransactionsPerDay[i].amount);
      }
    }

    total = totalChart(expenseTransactionsPerDay);

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return categoryAmountMap.isEmpty
        ? const Text('No expenses')
        : AspectRatio(
            aspectRatio: 1.3,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections(),
                      ),
                    ),
                  ),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Indicator(
                      color: AppColors.contentColorBlue,
                      text: 'Food',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppColors.contentColorYellow,
                      text: 'Transfer',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppColors.contentColorPurple,
                      text: 'Transportation',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppColors.contentColorGreen,
                      text: 'Education',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          );
  }

  // List<PieChartSectionData> showingSections() {
  //   return List.generate(4, (i) {
  //     final isTouched = i == touchedIndex;
  //     final fontSize = isTouched ? 25.0 : 16.0;
  //     final radius = isTouched ? 60.0 : 50.0;
  //     const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
  //     switch (i) {
  //       case 0:
  //         return PieChartSectionData(
  //           color: AppColors.contentColorBlue,
  //           value: 40,
  //           title: '40%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //             fontSize: fontSize,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.mainTextColor1,
  //             shadows: shadows,
  //           ),
  //         );
  //       case 1:
  //         return PieChartSectionData(
  //           color: AppColors.contentColorYellow,
  //           value: 30,
  //           title: '30%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //             fontSize: fontSize,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.mainTextColor1,
  //             shadows: shadows,
  //           ),
  //         );
  //       case 2:
  //         return PieChartSectionData(
  //           color: AppColors.contentColorPurple,
  //           value: 15,
  //           title: '15%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //             fontSize: fontSize,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.mainTextColor1,
  //             shadows: shadows,
  //           ),
  //         );
  //       case 3:
  //         return PieChartSectionData(
  //           color: AppColors.contentColorGreen,
  //           value: 15,
  //           title: '15%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //             fontSize: fontSize,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.mainTextColor1,
  //             shadows: shadows,
  //           ),
  //         );
  //       default:
  //         throw Error();
  //     }
  //   });
  // }

  // List<PieChartSectionData> showingSections() {
  //   return categoryAmountMap.keys.map((category) {
  //     print(category);
  //     final index = categoryAmountMap.keys.toList().indexOf(category);
  //     final isTouched = index == touchedIndex;
  //     final fontSize = isTouched ? 25.0 : 16.0;
  //     final radius = isTouched ? 60.0 : 50.0;
  //     const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
  //     final percentage =
  //         (categoryAmountMap[category]! / -(total)! * 100).toInt();

  //     return PieChartSectionData(
  //       color: getCategoryColor(
  //           category), // Define a method to get the color based on the category
  //       value: categoryAmountMap[category]!.toDouble(),
  //       title: '$percentage%',
  //       radius: radius,
  //       titleStyle: TextStyle(
  //         fontSize: fontSize,
  //         fontWeight: FontWeight.bold,
  //         color: AppColors.mainTextColor1,
  //         shadows: shadows,
  //       ),
  //     );
  //   }).toList();

  List<PieChartSectionData> showingSections() {
    final List<PieChartSectionData> sections = [];
    final totalAmount = categoryAmountMap.values.reduce((a, b) => a + b);

    categoryAmountMap.forEach((category, amount) {
      final index = categoryAmountMap.keys.toList().indexOf(category);
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final percentage = (amount / totalAmount * 100).toInt();

      sections.add(
        PieChartSectionData(
          color: getCategoryColor(
              category), // Define a method to get the color based on the category
          value: amount.toDouble(),
          title: '$percentage%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.mainTextColor1,
            shadows: shadows,
          ),
        ),
      );
    });

    return sections;
  }
}

getCategoryColor(String category) {
  switch (category) {
    case 'Food':
      return AppColors.contentColorBlue;

    case 'Transfer':
      return AppColors.contentColorYellow;

    case 'Transportation':
      return AppColors.contentColorPurple;

    case 'Education':
      return AppColors.contentColorGreen;

    default:
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
