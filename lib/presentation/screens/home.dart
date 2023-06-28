import 'package:expanse_management/Constants/days.dart';
import 'package:expanse_management/data/utilty.dart';
import 'package:expanse_management/domain/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Transaction transactionHistory;
  final box = Hive.box<Transaction>('transactions');
  // late int totalIn;
  // late int totalEx;
  // late int total;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, value, child) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(height: 340, child: _head()),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transactions History',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'See all',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    transactionHistory = box.values.toList()[index];
                    return listTransaction(transactionHistory, index);
                  }, childCount: box.length)),
                ],
              );
            }),
      ),
    );
  }

  Widget listTransaction(Transaction transactionHistory, int index) {
    return Dismissible(
        key: UniqueKey(),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content: const Text(
                    "Are you sure you want to delete this transaction?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Delete"),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          transactionHistory.delete();
        },
        child: getTransaction(index, transactionHistory));
  }

  ListTile getTransaction(int index, Transaction transactionHistory) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
            'images/${transactionHistory.category.categoryImage}',
            height: 40),
      ),
      title: Text(
        transactionHistory.notes,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${days[transactionHistory.createAt.weekday - 1]}  ${transactionHistory.createAt.day}/${transactionHistory.createAt.month}/${transactionHistory.createAt.year}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        formatCurrency(int.parse(transactionHistory.amount)),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
          color:
              transactionHistory.type == 'Expense' ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}

Stack _head() {
  return Stack(
    children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: const BoxDecoration(
              color: Color(0xff368983),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                    top: 30,
                    right: 30,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    )),
                const Padding(
                    padding: EdgeInsets.only(top: 40, left: 30),
                    child: Text(
                      "Dashboard",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            height: 180,
            width: 360,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(47, 125, 121, 0.3),
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 6,
                ),
              ],
              color: const Color(0xff368983),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        formatCurrency(totalBalance()),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
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
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
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
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency(totalIncome()),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        formatCurrency(totalExpense()),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ],
  );
}
