import 'package:expanse_management/models/category_model.dart';

final List<CategoryModel> defaultIncomeCategories = [
  CategoryModel('Salary', 'Salary.png', 'Income'),
  CategoryModel('Gifts', 'Gifts.png', 'Income'),
  CategoryModel('Investments', 'Investments.png', 'Income'),
];
final List<CategoryModel> defaultExpenseCategories = [
  CategoryModel('Food', 'Food.png', 'Expense'),
  CategoryModel('Transfer', 'Transfer.png', 'Expense'),
  CategoryModel('Transportation', 'Transportation.png', 'Expense'),
  CategoryModel('Education', 'Education.png', 'Expense')
];
