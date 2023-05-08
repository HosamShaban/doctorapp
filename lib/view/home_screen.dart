import 'package:doctorapp/Consts/colors.dart';
import 'package:doctorapp/controller/date_controller.dart';
import 'package:doctorapp/view/date_screen.dart';
import 'package:doctorapp/widget/NavBar.dart';
import 'package:doctorapp/widget/date_card.dart';
import 'package:doctorapp/widget/wait_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dateController = DateController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavBar(),
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'الصفحة الرئيسية',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: InkWell(
          child: IconButton(
              onPressed: () {
                //       Navigator.push(context,MaterialPageRoute(builder: (context) => const ()));
              },
              icon: const Icon(
                Icons.email_outlined,
                color: Colors.black,
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children:  [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DateScreen()));
                    },
                    child: const Text(
                      "المزيد",
                      style: TextStyle(
                        fontSize: 16,
                        color: ConstColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "الحجوزات الجديدة",
                    style:TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: 2,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    final item = dateController.dateList[index];
                    if (query.isNotEmpty && !item.title.toLowerCase().contains(query.toLowerCase())) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 5, bottom: 15),
                      child: WaitCard(
                        title: item.title,
                        image: item.image,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DateScreen()));
                  },
                  child: const Text(
                    "المزيد",
                    style: TextStyle(
                      fontSize: 16,
                      color: ConstColors.primaryColor,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "حجوزات اليوم",
                  style:TextStyle(fontSize: 24),
                ),
              ),

            ],
          ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: 2,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    final item = dateController.dateList[index];
                    if (query.isNotEmpty && !item.title.toLowerCase().contains(query.toLowerCase())) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 5, bottom: 15),
                      child: DateCard(
                        title: item.title,
                        image: item.image,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
