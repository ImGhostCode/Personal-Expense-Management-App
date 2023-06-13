// import 'package:expanse_management/Constants/color.dart';
// import 'package:expanse_management/Constants/days.dart';
// import 'package:expanse_management/models/category_model.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../Constants/categories.dart';
// import '../models/transaction_model.dart';

// class CategoryScreen extends StatefulWidget {
//   const CategoryScreen({Key? key});

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen> {
//   final box = Hive.box<CategoryModel>('categories');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('Categories'),
//       ),
//       body: ListView.builder(
//         itemCount: box.length,
//         itemBuilder: (context, index) {
//           final category = box.getAt(index);
//           return ListTile(
//             leading: Image.asset('images/$category.png', height: 40),
//             title: Text(category!.title),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       CategoryDetailsScreen(category: category),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class CategoryDetailsScreen extends StatefulWidget {
//   final String category;

//   const CategoryDetailsScreen({Key? key, required this.category})
//       : super(key: key);

//   @override
//   State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
// }

// class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
//   late List<Transaction> filteredTransactions;

//   @override
//   void initState() {
//     super.initState();
//     filterTransactions();
//   }

//   void filterTransactions() {
//     final box = Hive.box<Transaction>('transactions');
//     filteredTransactions = box.values
//         .where((transaction) => transaction.category == widget.category)
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.category),
//         backgroundColor: primaryColor,
//       ),
//       body: ListView.builder(
//         itemCount: filteredTransactions.length,
//         itemBuilder: (context, index) {
//           final transaction = filteredTransactions[index];
//           return ListTile(
//             leading: ClipRRect(
//               borderRadius: BorderRadius.circular(5),
//               child:
//                   Image.asset('images/${transaction.category}.png', height: 40),
//             ),
//             title: Text(
//               transaction.notes,
//               style: const TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             subtitle: Text(
//               '${days[transaction.createAt.weekday - 1]}  ${transaction.createAt.day}/${transaction.createAt.month}/${transaction.createAt.year}',
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             trailing: Text(
//               '\$${transaction.amount}',
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 19,
//                 color:
//                     transaction.type == 'Expense' ? Colors.red : Colors.green,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:expanse_management/Constants/color.dart';
import 'package:expanse_management/Constants/default_categories.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:expanse_management/models/category_model.dart';
import 'package:expanse_management/models/transaction_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Box<CategoryModel> box;
  List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    openBox().then((_) {
      fetchCategories();
    });
  }

  Future<void> openBox() async {
    box = await Hive.openBox<CategoryModel>('categories');
  }

  Future<void> fetchCategories() async {
    categories = [
      ...box.values.toList(),
      ...defaultExpenseCategories,
      ...defaultIncomeCategories
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            leading:
                Image.asset('images/${category.categoryImage}', height: 40),
            title: Text(category.title),
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
  final CategoryModel category;

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
        .where((transaction) =>
            transaction.category.title == widget.category.title)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
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
