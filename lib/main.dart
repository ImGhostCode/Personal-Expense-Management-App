import 'package:expanse_management/presentation/widgets/bottom_navbar.dart';
import 'package:expanse_management/domain/models/category_model.dart';
import 'package:expanse_management/domain/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

// Future<void> clearData() async {
//   final appDocumentDirectory =
//       await path_provider.getApplicationDocumentsDirectory();
//   Hive.init(appDocumentDirectory.path);
//   await Hive.deleteFromDisk();
// }

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await clearData();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<CategoryModel>('categories');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bottom(),
    );
  }
}
