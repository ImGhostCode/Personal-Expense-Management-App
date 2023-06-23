import 'package:expanse_management/Constants/color.dart';
import 'package:expanse_management/data/utilty.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:expanse_management/domain/models/transaction_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  late List<Transaction> filteredTransactions;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filterTransactions('');
  }

  void filterTransactions(String query) {
    final box = Hive.box<Transaction>('transactions');
    filteredTransactions = box.values
        .where((transaction) =>
            transaction.notes.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              cursorColor: primaryColor,
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by notes',
                labelStyle: const TextStyle(color: primaryColor),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  color: primaryColor,
                  onPressed: () {
                    searchController.clear();
                    filterTransactions('');
                    setState(() {});
                  },
                ),
              ),
              onChanged: (value) {
                filterTransactions(value);
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      'images/${transaction.category.categoryImage}',
                      height: 40,
                    ),
                  ),
                  title: Text(
                    transaction.notes,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${transaction.createAt.day}/${transaction.createAt.month}/${transaction.createAt.year}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Text(
                    formatCurrency(int.parse(transaction.amount)),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: transaction.type == 'Expense'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
