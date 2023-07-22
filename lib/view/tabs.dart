import 'package:flutter/material.dart';

import 'canceled.dart';
import 'confirmed.dart';
import 'my_appoitments.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({super.key});

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "الحجوزات",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          bottom: const TabBar(tabs: [
            Tab(
              child: Text(
                "قائمة الانتظار",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
              ),
            ),
            Tab(
              child: Text(
                "مؤكدة",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
              ),
            ),
            Tab(
              child: Text(
                "مرفوضة",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
              ),
            ),
          ]),
        ),
        body: const TabBarView(children: [
          MyAppoitmnts(),
          ConfirmedAppoitments(),
          CancelledAppoitments(),
        ]),
      ),
    );
  }
}
