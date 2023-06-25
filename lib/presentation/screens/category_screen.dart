import 'package:expanse_management/Constants/color.dart';
import 'package:expanse_management/Constants/default_categories.dart';
import 'package:expanse_management/data/utilty.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:expanse_management/domain/models/category_model.dart';
import 'package:expanse_management/domain/models/transaction_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  late Box<CategoryModel> box;
  // List<CategoryModel> categories = [];
  List<CategoryModel> expenseCategories = [];
  List<CategoryModel> incomeCategories = [];

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
    expenseCategories = [
      ...box.values.where((category) => category.type == 'Expense'),
      ...defaultExpenseCategories
    ];

    incomeCategories = [
      ...box.values.where((category) => category.type == 'Income'),
      ...defaultIncomeCategories
    ];

    // categories = [
    //   CategoryModel( 'Expense', , 'Header'),
    //   ...expenseCategories,
    //   CategoryModel( 'Income', 'Header'),
    //   ...incomeCategories,
    // ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Categories'),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Income',
              style: TextStyle(fontSize: 17, color: Colors.green),
            ),
          )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = incomeCategories[index];
                return ListTile(
                  leading: Image.asset('images/${category.categoryImage}',
                      height: 40),
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
              childCount: incomeCategories.length,
            ),
          ),
          const SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Expense',
                style: TextStyle(fontSize: 17, color: Colors.red)),
          )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = expenseCategories[index];
                return ListTile(
                  leading: Image.asset('images/${category.categoryImage}',
                      height: 40),
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
              childCount: expenseCategories.length,
            ),
          ),
        ],
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
              formatCurrency(int.parse(transaction.amount)),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
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
