import 'package:expanse_management/Widgets/chart.dart';
import 'package:expanse_management/data/utilty.dart';
import 'package:expanse_management/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

ValueNotifier notifier = ValueNotifier(0);

class _StatisticsState extends State<Statistics> {
  final box = Hive.box<Transaction>('data');

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
    box.listenable().addListener(fetchTransactions);
  }

  @override
  void dispose() {
    box.listenable().removeListener(updateNotifier);
    box.listenable().removeListener(fetchTransactions);

    super.dispose();
  }

  void updateNotifier() {
    notifier.value =
        notifier.value + 1; // Update the value to trigger a rebuild
  }

  void fetchTransactions() {
    listTransaction[0] = getTransactionToday();
    listTransaction[1] = getTransactionWeek();
    listTransaction[2] = getTransactionMonth();
    listTransaction[3] = getTransactionYear();
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
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Expense',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.arrow_downward_sharp,
                            color: Colors.grey,
                          )
                        ]),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Chart(
              currIndex: indexColor,
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
                    'images/${currListTransaction[index].category}.png',
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
                '${currListTransaction[index].datetime.day}/${currListTransaction[index].datetime.month}/${currListTransaction[index].datetime.year}',
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
