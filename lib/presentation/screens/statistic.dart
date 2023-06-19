// import 'package:expanse_management/Widgets/chart.dart';
// import 'package:expanse_management/Widgets/pie_chart.dart';
import 'package:expanse_management/presentation/widgets/spline_chart.dart';
import 'package:expanse_management/data/utilty.dart';
import 'package:expanse_management/domain/models/category_model.dart';
import 'package:expanse_management/domain/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

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
    // listTransaction[0] = getTransactionToday();
    // listTransaction[1] = getTransactionWeek();
    // listTransaction[2] = getTransactionMonth();
    // listTransaction[3] = getTransactionYear();
    listTransaction[0] = getTransactionToday();
    listTransaction[1] = getTransactionWeek();
    listTransaction[2] = getTransactionMonth();
    listTransaction[3] = getTransactionYear();
    // setState(() {});
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
            // const SizedBox(
            //   height: 20,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            // Container(
            //   width: 120,
            //   height: 40,
            //   decoration: BoxDecoration(
            //       border: Border.all(color: Colors.grey, width: 2),
            //       borderRadius: BorderRadius.circular(8)),
            //   child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         Text(
            //           'Expense',
            //           style: TextStyle(
            //               color: Colors.grey,
            //               fontSize: 16,
            //               fontWeight: FontWeight.bold),
            //         ),
            //         Icon(
            //           Icons.arrow_downward_sharp,
            //           color: Colors.grey,
            //         )
            //       ]),
            // )
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.,
            //       children: [Text('Income'), Text('200.000')],
            //     ),
            //     Row(
            //       children: [Text('Expense'), Text('200.000')],
            //     ),
            //   ],
            // ),
            // ),
            const SizedBox(
              height: 20,
            ),
            const SplineChart(),
            // indexColor == 0
            //     ? const PieChartDay()
            //     : Chart(
            //         currIndex: indexColor,
            //       ),
            // indexColor != 0
            //     ? BarChartDetail(
            //         currIndex: indexColor,
            //       )
            //     : const PieChartSample2(),
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
