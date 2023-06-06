import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  String explain;

  @HiveField(2)
  String amount;

  @HiveField(3)
  String type;

  @HiveField(4)
  DateTime datetime;

  Transaction(
      this.type, this.amount, this.datetime, this.explain, this.category);
}
