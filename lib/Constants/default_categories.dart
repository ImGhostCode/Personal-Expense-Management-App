import 'package:expanse_management/domain/models/category_model.dart';

final List<CategoryModel> defaultIncomeCategories = [
  CategoryModel('Salary', 'Salary.png', 'Income'),
  CategoryModel('Gifts', 'Gifts.png', 'Income'),
  CategoryModel('Investments', 'Investments.png', 'Income'),
  CategoryModel('Rentals', 'Rentals.png', 'Income'),
  CategoryModel('Savings', 'Savings.png', 'Income'),
  CategoryModel('Others Income', 'Others.png', 'Income'),
];
final List<CategoryModel> defaultExpenseCategories = [
  CategoryModel('Food', 'Food.png', 'Expense'),
  CategoryModel('Transportation', 'Transportation.png', 'Expense'),
  CategoryModel('Education', 'Education.png', 'Expense'),
  CategoryModel('Bills', 'Bills.png', 'Expense'),
  CategoryModel('Travels', 'Travels.png', 'Expense'),
  CategoryModel('Pets', 'Pets.png', 'Expense'),
  CategoryModel('Tax', 'Tax.png', 'Expense'),
  CategoryModel('Others Expense', 'Others.png', 'Income'),
];
