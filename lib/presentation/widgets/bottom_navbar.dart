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
    const Statistics(),
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
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 0;
                  });
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: indexColor == index
                    //     ? const Color.fromARGB(255, 47, 125, 121)
                    //     : Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.home,
                    size: 30,
                    color:
                        indexColor == 0 ? const Color(0xff368983) : Colors.grey,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 1;
                  });
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: indexColor == index
                    //     ? const Color.fromARGB(255, 47, 125, 121)
                    //     : Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.bar_chart_outlined,
                    size: 30,
                    color:
                        indexColor == 1 ? const Color(0xff368983) : Colors.grey,
                  ),
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
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: indexColor == index
                    //     ? const Color.fromARGB(255, 47, 125, 121)
                    //     : Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.category_outlined,
                    size: 30,
                    color:
                        indexColor == 2 ? const Color(0xff368983) : Colors.grey,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 3;
                  });
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.search_outlined,
                    size: 30,
                    color:
                        indexColor == 3 ? const Color(0xff368983) : Colors.grey,
                  ),
                )),
          ]),
        ),
      ),
      body: Screen[indexColor],
    );
  }
}
