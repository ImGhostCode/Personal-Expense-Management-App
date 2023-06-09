import 'package:expanse_management/Constants/color.dart';
import 'package:expanse_management/Constants/days.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Constants/categories.dart';
import '../models/transaction_model.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categoryItems.length,
        itemBuilder: (context, index) {
          final category = categoryItems[index];
          return ListTile(
            leading: Image.asset('images/$category.png', height: 40),
            title: Text(category),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryDetailsScreen(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryDetailsScreen extends StatefulWidget {
  final String category;

  const CategoryDetailsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  late List<Transaction> filteredTransactions;

  @override
  void initState() {
    super.initState();
    filterTransactions();
  }

  void filterTransactions() {
    final box = Hive.box<Transaction>('transactions');
    filteredTransactions = box.values
        .where((transaction) => transaction.category == widget.category)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        itemCount: filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = filteredTransactions[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child:
                  Image.asset('images/${transaction.category}.png', height: 40),
            ),
            title: Text(
              transaction.notes,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${days[transaction.createAt.weekday - 1]}  ${transaction.createAt.day}/${transaction.createAt.month}/${transaction.createAt.year}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Text(
              '\$${transaction.amount}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color:
                    transaction.type == 'Expense' ? Colors.red : Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
