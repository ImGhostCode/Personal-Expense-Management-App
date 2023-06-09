import 'package:expanse_management/models/transaction_model.dart';
import 'package:hive/hive.dart';

int totals = 0;

final box = Hive.box<Transaction>('transactions');

int totalBalance() {
  var transactions = box.values.toList();
  List listAmount = [0, 0];
  for (var i = 0; i < transactions.length; i++) {
    listAmount.add(transactions[i].type == 'Income'
        ? int.parse(transactions[i].amount)
        : int.parse(transactions[i].amount) * -1);
  }
  totals = listAmount.reduce((value, element) => value + element);
  return totals;
}

int totalIncome() {
  var transactions = box.values.toList();
  List listAmount = [0, 0];
  for (var i = 0; i < transactions.length; i++) {
    listAmount.add(transactions[i].type == 'Income'
        ? int.parse(transactions[i].amount)
        : 0);
  }
  totals = listAmount.reduce((value, element) => value + element);
  return totals;
}

int totalExpense() {
  var transactions = box.values.toList();
  List listAmount = [0, 0];
  for (var i = 0; i < transactions.length; i++) {
    listAmount.add(transactions[i].type == 'Income'
        ? 0
        : int.parse(transactions[i].amount) * -1);
  }
  totals = listAmount.reduce((value, element) => value + element);
  return totals;
}

List<Transaction> getTransactionToday() {
  List<Transaction> result = [];
  var transactions = box.values.toList();
  DateTime date = DateTime.now();
  for (var i = 0; i < transactions.length; i++) {
    if (transactions[i].createAt.day == date.day) {
      result.add(transactions[i]);
    }
  }

  return result;
}

List<Transaction> getTransactionWeek() {
  List<Transaction> result = [];
  DateTime date = DateTime.now();
  var transactions = box.values.toList();
  for (var i = 0; i < transactions.length; i++) {
    if (date.day - 7 <= transactions[i].createAt.day &&
        transactions[i].createAt.day <= date.day) {
      result.add(transactions[i]);
    }
  }

  return result;
}

List<Transaction> getTransactionMonth() {
  List<Transaction> result = [];
  var transactions = box.values.toList();
  DateTime date = DateTime.now();
  for (var i = 0; i < transactions.length; i++) {
    if (transactions[i].createAt.month == date.month) {
      result.add(transactions[i]);
    }
  }

  return result;
}

List<Transaction> getTransactionYear() {
  List<Transaction> result = [];
  var transactions = box.values.toList();
  DateTime date = DateTime.now();
  for (var i = 0; i < transactions.length; i++) {
    if (transactions[i].createAt.year == date.year) {
      result.add(transactions[i]);
    }
  }

  return result;
}

int totalChart(List<Transaction> transactions) {
  List listAmount = [0, 0];
  for (var i = 0; i < transactions.length; i++) {
    listAmount.add(transactions[i].type == 'Income'
        ? int.parse(transactions[i].amount)
        : int.parse(transactions[i].amount) * -1);
  }
  totals = listAmount.reduce((value, element) => value + element);
  return totals;
}

List time(List<Transaction> transactions, bool hour) {
  List<Transaction> a = [];
  List total = [];
  int counter = 0;
  for (var c = 0; c < transactions.length; c++) {
    for (var i = c; i < transactions.length; i++) {
      if (hour) {
        if (transactions[i].createAt.hour == transactions[c].createAt.hour) {
          a.add(transactions[i]);
          counter = i;
        }
      } else {
        if (transactions[i].createAt.day == transactions[c].createAt.day) {
          a.add(transactions[i]);
          counter = i;
        }
      }
    }
    total.add(totalChart(a));
    a.clear();
    c = counter;
  }
  print(total);
  return total;
}
