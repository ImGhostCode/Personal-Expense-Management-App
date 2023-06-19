import 'dart:math';

import 'package:expanse_management/domain/models/transaction_model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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

List<Transaction> getExpenseTransactionToday() {
  List<Transaction> result = [];
  var transactions = box.values.toList();
  DateTime date = DateTime.now();
  for (var i = 0; i < transactions.length; i++) {
    if (transactions[i].category.type == 'Expense' &&
        transactions[i].createAt.day == date.day) {
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
    // if (date.day - 7 <= transactions[i].createAt.day &&
    //     transactions[i].createAt.day <= date.day) {
    //   result.add(transactions[i]);
    // }
    if (isWithinCurrentWeek(transactions[i].createAt)) {
      result.add(transactions[i]);
    }
  }

  result.sort((a, b) => a.createAt.compareTo(b.createAt));

  return result;
}

// Map<DateTime, double> calculateTotalIncomeInCurrentWeek() {
//   var incomeInCurrentWeek = <DateTime, double>{};

//   var currentDate = DateTime.now();
//   var startOfWeek =
//       currentDate.subtract(Duration(days: currentDate.weekday - 1));

//   for (var i = 0; i < box.length; i++) {
//     var transaction = box.getAt(i);

//     if (transaction != null &&
//         transaction.type == 'Income' &&
//         transaction.createAt.isAfter(startOfWeek)) {
//       var transactionDate = transaction.createAt;
//       var transactionAmount = double.tryParse(transaction.amount) ?? 0.0;

//       if (incomeInCurrentWeek.containsKey(transactionDate)) {
//         incomeInCurrentWeek[transactionDate] =
//             incomeInCurrentWeek[transactionDate]! + transactionAmount;
//       } else {
//         incomeInCurrentWeek[transactionDate] = transactionAmount;
//       }
//     }
//   }

//   return incomeInCurrentWeek;
// }

Map<int, double> calculateWeeklyIncome() {
  // Mở box để truy cập dữ liệu giao dịch
  // var transactionBox = await Hive.openBox<Transaction>('transactions');

  // Tạo map để lưu trữ tổng income theo từng ngày trong tuần
  Map<int, double> weeklyIncome = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};

  // Lặp qua tất cả các giao dịch trong box
  for (var i = 0; i < box.length; i++) {
    var transaction = box.getAt(i);

    // Kiểm tra xem giao dịch có thuộc loại "Income" hay không
    if (transaction?.type == 'Income') {
      var transactionDate = transaction?.createAt;

      // Kiểm tra xem ngày của giao dịch có thuộc tuần hiện tại hay không
      if (isWithinCurrentWeek(transactionDate!)) {
        // Tính tổng income cho ngày đó
        var dailyIncome = weeklyIncome[transactionDate.weekday] ?? 0;
        dailyIncome += double.parse(transaction!.amount);
        weeklyIncome[transactionDate.weekday] = dailyIncome;
      }
    }
  }

  // Đóng box sau khi hoàn thành
  // await transactionBox.close();

  // Trả về kết quả tổng income theo từng ngày trong tuần
  print(weeklyIncome);
  return weeklyIncome;
}

Map<int, double> calculateMonthlyIncome() {
  // Mở box để truy cập dữ liệu giao dịch
  // var transactionBox = await Hive.openBox<Transaction>('transactions');

  // Tạo map để lưu trữ tổng income theo từng ngày trong tuần
  Map<int, double> monthlyIncome = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0,
    9: 0,
    10: 0,
    11: 0,
    12: 0
  };

  // Lặp qua tất cả các giao dịch trong box
  for (var i = 0; i < box.length; i++) {
    var transaction = box.getAt(i);
    int currYear = DateTime.now().year;
    // Kiểm tra xem giao dịch có thuộc loại "Income" hay không
    if (transaction?.createAt.year == currYear &&
        transaction?.type == 'Income') {
      var transactionDate = transaction?.createAt;

      // Kiểm tra xem ngày của giao dịch có thuộc tuần hiện tại hay không
      // if (isWithinCurrentWeek(transactionDate!)) {
      // Tính tổng income cho ngày đó
      var monthIncome = monthlyIncome[transactionDate?.month] ?? 0;
      monthIncome += double.parse(transaction!.amount);
      monthlyIncome[transactionDate!.month] = monthIncome;
      // }
    }
  }

  // Đóng box sau khi hoàn thành
  // await transactionBox.close();

  // Trả về kết quả tổng income theo từng ngày trong tuần
  print(monthlyIncome);
  return monthlyIncome;
}

Map<int, double> calculateMonthlyExpense() {
  // Mở box để truy cập dữ liệu giao dịch
  // var transactionBox = await Hive.openBox<Transaction>('transactions');

  // Tạo map để lưu trữ tổng income theo từng ngày trong tuần
  Map<int, double> monthlyExpense = {};

  // Lặp qua tất cả các giao dịch trong box
  for (var i = 0; i < box.length; i++) {
    var transaction = box.getAt(i);
    int currYear = DateTime.now().year;
    // Kiểm tra xem giao dịch có thuộc loại "Income" hay không
    if (transaction?.createAt.year == currYear &&
        transaction?.type == 'Expense') {
      var transactionDate = transaction?.createAt;

      // Kiểm tra xem ngày của giao dịch có thuộc tuần hiện tại hay không
      // if (isWithinCurrentWeek(transactionDate!)) {
      // Tính tổng income cho ngày đó
      var monthExpense = monthlyExpense[transactionDate?.month] ?? 0;
      monthExpense += double.parse(transaction!.amount);
      monthlyExpense[transactionDate!.month] = monthExpense;
      // }
    }
  }

  // Đóng box sau khi hoàn thành
  // await transactionBox.close();

  // Trả về kết quả tổng income theo từng ngày trong tuần
  print(monthlyExpense);
  return monthlyExpense;
}

Map<int, double> calculateWeeklyExpense() {
  // Mở box để truy cập dữ liệu giao dịch
  // var transactionBox = await Hive.openBox<Transaction>('transactions');

  // Tạo map để lưu trữ tổng income theo từng ngày trong tuần
  Map<int, double> weeklyExpense = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};

  // Lặp qua tất cả các giao dịch trong box
  for (var i = 0; i < box.length; i++) {
    var transaction = box.getAt(i);

    // Kiểm tra xem giao dịch có thuộc loại "Income" hay không
    if (transaction?.type == 'Expense') {
      var transactionDate = transaction?.createAt;

      // Kiểm tra xem ngày của giao dịch có thuộc tuần hiện tại hay không
      if (isWithinCurrentWeek(transactionDate!)) {
        // Tính tổng income cho ngày đó
        var dailyIncome = weeklyExpense[transactionDate.weekday] ?? 0;
        dailyIncome += double.parse(transaction!.amount);
        weeklyExpense[transactionDate.weekday] = dailyIncome;
      }
    }
  }

  // Đóng box sau khi hoàn thành
  // await transactionBox.close();

  // Trả về kết quả tổng income theo từng ngày trong tuần
  print(weeklyExpense);
  return weeklyExpense;
}

bool isWithinCurrentWeek(DateTime date) {
  var now = DateTime.now();
  var startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  var endOfWeek = startOfWeek.add(const Duration(days: 6));
  return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
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

  result.sort((a, b) => a.createAt.compareTo(b.createAt));

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

  result.sort((a, b) => a.createAt.compareTo(b.createAt));

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

List time(List<Transaction> transactions, bool hour, bool day, bool month) {
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
      } else if (day) {
        if (transactions[i].createAt.day == transactions[c].createAt.day) {
          a.add(transactions[i]);
          counter = i;
        }
      } else {
        if (transactions[i].createAt.month == transactions[c].createAt.month) {
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

double calculateMaxY(Map<int, double> income, Map<int, double> expense) {
  return max(
      income.values
          .toList()
          .reduce((value, element) => value > element ? value : element),
      expense.values
          .toList()
          .reduce((value, element) => value > element ? value : element));
}

String formatCurrency(int value) {
  final format = NumberFormat.currency(
    symbol: '', // Empty symbol to remove the currency symbol
    decimalDigits: 0, // Number of decimal digits (set to 0 for VND)
    locale: 'vi_VN', // Vietnamese locale for formatting
  );

  return '${format.format(value)} vnđ'; // Append ' vnđ' to the formatted value
}
