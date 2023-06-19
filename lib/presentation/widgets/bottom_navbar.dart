import 'package:expanse_management/presentation/screens/add_transaction.dart';
import 'package:expanse_management/presentation/screens/category_screen.dart';
import 'package:expanse_management/presentation/screens/home.dart';
import 'package:expanse_management/presentation/screens/search_screen.dart';
import 'package:expanse_management/presentation/screens/statistic.dart';
import 'package:flutter/material.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int indexColor = 0;
  // ignore: non_constant_identifier_names
  List Screen = [
    const Home(),
    const Padding(
      padding: EdgeInsets.all(8.0),
      child: Statistics(),
      // child: TestStatisticScreen(),
    ),
    const CategoryScreen(),
    const SearchScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddScreen()));
        },
        backgroundColor: const Color(0xff368983),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color:
                      indexColor == 0 ? const Color(0xff368983) : Colors.grey,
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color:
                      indexColor == 1 ? const Color(0xff368983) : Colors.grey,
                )),
            const SizedBox(
              width: 20,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 2;
                  });
                },
                child: Icon(
                  Icons.category_outlined,
                  size: 30,
                  color:
                      indexColor == 2 ? const Color(0xff368983) : Colors.grey,
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 3;
                  });
                },
                child: Icon(
                  Icons.search_outlined,
                  size: 30,
                  color:
                      indexColor == 3 ? const Color(0xff368983) : Colors.grey,
                )),
          ]),
        ),
      ),
      body: Screen[indexColor],
    );
  }
}
