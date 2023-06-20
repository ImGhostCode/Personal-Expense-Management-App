import 'package:expanse_management/presentation/widgets/spline_chart.dart';
import 'package:expanse_management/data/utilty.dart';
import 'package:expanse_management/domain/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

ValueNotifier notifier = ValueNotifier(0);

class _StatisticsState extends State<Statistics> {
  final box = Hive.box<Transaction>('transactions');

  List day = ['Day', 'Week', 'Month', 'Year'];
  List listTransaction = [
    getTransactionToday(),
    getTransactionWeek(),
    getTransactionMonth(),
    getTransactionYear()
  ];
  List<Transaction> currListTransaction = [];
  int indexColor = 0;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    box.listenable().addListener(updateNotifier);
    fetchTransactions();
  }

  @override
  void dispose() {
    box.listenable().removeListener(updateNotifier);
    // box.listenable().removeListener(fetchTransactions);

    super.dispose();
  }

  void updateNotifier() {
    // notifier.value =
    //     notifier.value + 1; // Update the value to trigger a rebuild
    fetchTransactions();
  }

  void fetchTransactions() {
    listTransaction[0] = getTransactionToday();
    listTransaction[1] = getTransactionWeek();
    listTransaction[2] = getTransactionMonth();
    listTransaction[3] = getTransactionYear();
    // setState(() {});
  }

  String _getFormattedDate(int index) {
    switch (index) {
      case 0:
        return DateFormat('MMM dd, yyyy').format(selectedDate.toLocal());
      case 1:
        final startOfWeek =
            selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return '${DateFormat('dd').format(startOfWeek)}-${DateFormat('dd').format(endOfWeek)} ${DateFormat('MMM, yyyy').format(selectedDate.toLocal())}';
      case 2:
        return DateFormat('MMM yyyy').format(selectedDate.toLocal());
      case 3:
        return DateFormat('yyyy').format(selectedDate.toLocal());
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: notifier,
        builder: (BuildContext context, dynamic value, Widget? child) {
          currListTransaction = listTransaction[value % listTransaction.length];
          return customScrollView();
        },
      )),
    );
  }

  // Widget makeTransactionsIcon() {
  //   const width = 4.5;
  //   const space = 3.5;
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: <Widget>[
  //       Container(
  //         width: width,
  //         height: 10,
  //         color: const Color(0xff368983).withOpacity(0.4),
  //       ),
  //       const SizedBox(
  //         width: space,
  //       ),
  //       Container(
  //         width: width,
  //         height: 28,
  //         color: const Color(0xff368983).withOpacity(0.8),
  //       ),
  //       const SizedBox(
  //         width: space,
  //       ),
  //       Container(
  //         width: width,
  //         height: 42,
  //         color: const Color(0xff368983).withOpacity(1),
  //       ),
  //       const SizedBox(
  //         width: space,
  //       ),
  //       Container(
  //         width: width,
  //         height: 28,
  //         color: const Color(0xff368983).withOpacity(0.8),
  //       ),
  //       const SizedBox(
  //         width: space,
  //       ),
  //       Container(
  //         width: width,
  //         height: 10,
  //         color: const Color(0xff368983).withOpacity(0.4),
  //       ),
  //     ],
  //   );
  // }

  CustomScrollView customScrollView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Statistics',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...List.generate(4, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          indexColor = index;
                          notifier.value = index;
                          if (indexColor == 1) {
                            selectedDate = DateTime.now().subtract(
                                Duration(days: DateTime.now().weekday - 1));
                          } else {
                            selectedDate = DateTime.now();
                          }

                          print(selectedDate);
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: indexColor == index
                              ? const Color.fromARGB(255, 47, 125, 121)
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          day[index],
                          style: TextStyle(
                            color: indexColor == index
                                ? Colors.white
                                : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getFormattedDate(indexColor),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (indexColor == 0) {
                                  selectedDate = selectedDate
                                      .subtract(const Duration(days: 1));
                                } else if (indexColor == 1) {
                                  selectedDate = selectedDate
                                      .subtract(const Duration(days: 7));
                                } else if (indexColor == 2) {
                                  selectedDate = DateTime(selectedDate.year,
                                      selectedDate.month - 1, selectedDate.day);
                                } else if (indexColor == 3) {
                                  selectedDate = DateTime(selectedDate.year - 1,
                                      selectedDate.month, selectedDate.day);
                                }
                              });
                              print(selectedDate);
                            },
                            icon: const Icon(Icons.arrow_back_ios_new)),
                        const SizedBox(
                          width: 15,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (indexColor == 0) {
                                  selectedDate =
                                      selectedDate.add(const Duration(days: 1));
                                } else if (indexColor == 1) {
                                  selectedDate =
                                      selectedDate.add(const Duration(days: 7));
                                } else if (indexColor == 2) {
                                  selectedDate = DateTime(selectedDate.year,
                                      selectedDate.month + 1, selectedDate.day);
                                } else if (indexColor == 3) {
                                  selectedDate = DateTime(selectedDate.year + 1,
                                      selectedDate.month, selectedDate.day);
                                }
                              });
                              print(selectedDate);
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      ],
                    )
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            const SplineChart(),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.black,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Income',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '1234 vnd',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.black,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Expenses',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '1234 vnd',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 30),
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '1234 vnd',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Spending',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.swap_vert,
                    size: 25,
                    color: Colors.grey,
                  )
                ],
              ),
            )
          ]),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                    'images/${currListTransaction[index].category.categoryImage}',
                    height: 40),
              ),
              title: Text(
                currListTransaction[index].notes,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '${currListTransaction[index].createAt.day}/${currListTransaction[index].createAt.month}/${currListTransaction[index].createAt.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(
                '\$${currListTransaction[index].amount}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                  color: currListTransaction[index].type == 'Expense'
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            );
          }, childCount: currListTransaction.length),
        )
      ],
    );
  }
}
