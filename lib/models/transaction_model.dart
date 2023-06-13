import 'package:hive/hive.dart';

import 'category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  CategoryModel category;

  @HiveField(1)
  String notes;

  @HiveField(2)
  String amount;

  @HiveField(3)
  String type;

  @HiveField(4)
  DateTime createAt;

  // static void setupCategoryTable() {
  //   var box = Hive.box<Category>('categories');
  //   if (!box.containsKey('default')) {
  //     List<Category> defaultCategory = [
  //       Category('Food', 'Food.png', 'Expense'),
  //       Category('Transfer', 'Transfer.png', 'Expense'),
  //       Category('Transportation', 'Transportation.png', 'Expense'),
  //       Category('Education', 'Education.png', 'Expense'),
  //       Category('Salary', 'Salary.png', 'Income'),
  //     ];
  //     box.addAll(defaultCategory);
  //   }
  // }

  Transaction(this.type, this.amount, this.createAt, this.notes, this.category);
}
