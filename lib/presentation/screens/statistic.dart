import 'package:expanse_management/Constants/color.dart';
import 'package:expanse_management/presentation/widgets/circular_chart.dart';
import 'package:expanse_management/presentation/widgets/column_chart.dart';
// import 'package:expanse_management/presentation/widgets/spline_chart.dart';
import 'package:expanse_management/data/utilty.dart';
import 'package:expanse_management/domain/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  get selectedDate => null;

  @override
  State<Statistics> createState() => _StatisticsState();
}

ValueNotifier<int> notifier = ValueNotifier<int>(0);

class _StatisticsState extends State<Statistics>
    with SingleTickerProviderStateMixin {
  final box = Hive.box<Transaction>('transactions');

  List day = ['Day', 'Week', 'Month', 'Year'];
  List listTransaction = [[], [], [], []];
  List<Transaction> currListTransaction = [];
  int indexColor = 0;

  DateTime selectedDate = DateTime.now();
  late int totalIn;
  late int totalEx;
  late int total;

  late TabController _tabController;
  late bool isCircularChartSelected;
  @override
  void initState() {
    super.initState();
    notifier.value = 0;
    isCircularChartSelected = false;
    _tabController = TabController(length: 2, vsync: this);
    box.listenable().addListener(updateNotifier);
    fetchTransactions();
  }

  @override
  void dispose() {
    box.listenable().removeListener(updateNotifier);
    _tabController.dispose();
    super.dispose();
  }

  void updateNotifier() {
    fetchTransactions();
  }

  void fetchTransactions() {
    listTransaction[0] = getTransactionToday(selectedDate);
    listTransaction[1] = getTransactionWeek(selectedDate);
    listTransaction[2] = getTransactionMonth(selectedDate);
    listTransaction[3] = getTransactionYear(selectedDate);
    totalIn = totalFilterdIncome(currListTransaction);
    totalEx = totalFilterdExpense(currListTransaction);
    total = totalIn - totalEx;
    // print(
    //   'total: $total $totalIn $totalEx',
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder<int>(
        valueListenable: notifier,
        builder: (BuildContext context, int value, Widget? child) {
          // print(value);
          // print(currListTransaction);
          currListTransaction = listTransaction[value];
          totalIn = totalFilterdIncome(currListTransaction);
          totalEx = totalFilterdExpense(currListTransaction);
          total = totalIn - totalEx;
          // print(
          //   'total: $total $totalIn $totalEx',
          // );
          fetchTransactions();
          return customScrollView();
        },
      )),
    );
  }

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
            const SizedBox(height: 10),
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

                          fetchTransactions();
                        });
                        // print(selectedDate);
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
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getFormattedDate(indexColor, selectedDate),
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
                              fetchTransactions();
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
                                fetchTransactions();
                              });
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      ],
                    )
                  ],
                )),

            // SplineChart(
            //   transactions: currListTransaction,
            //   currIndex: indexColor,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TabBar(
                controller: _tabController,
                indicatorColor: primaryColor,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(text: 'Column'),
                  Tab(text: 'Circular'),
                ],
                onTap: (index) {
                  setState(() {
                    isCircularChartSelected = index == 1;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            isCircularChartSelected
                ? Column(
                    children: [
                      CircularChart(
                          title: "Income",
                          currIndex: indexColor,
                          transactions: currListTransaction),
                      CircularChart(
                          title: "Expense",
                          currIndex: indexColor,
                          transactions: currListTransaction),
                    ],
                  )
                : ColumnChart(
                    transactions: currListTransaction,
                    currIndex: indexColor,
                  ),

            const SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
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
                        formatCurrency(totalIn),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
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
                        formatCurrency(totalEx),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
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
                        formatCurrency(total),
                        style: const TextStyle(
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
                formatCurrency(int.parse(currListTransaction[index].amount)),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
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
