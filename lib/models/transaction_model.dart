import 'package:hive/hive.dart';

import 'category_model.dart';
part 'transaction.g.dart';

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  String notes;

  @HiveField(2)
  String amount;

  @HiveField(3)
  String type;

  @HiveField(4)
  DateTime createAt;

  Transaction(this.type, this.amount, this.createAt, this.notes, this.category);
}
