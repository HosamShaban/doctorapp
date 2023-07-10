import 'package:doctorapp/Consts/colors.dart';
import 'package:doctorapp/controller/date_controller.dart';
import 'package:doctorapp/view/newreviewB.dart';
import 'package:doctorapp/widget/date_card.dart';
import 'package:doctorapp/widget/wait_card.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

class DateScreen extends StatefulWidget {
  const DateScreen({Key? key}) : super(key: key);

  @override
  State<DateScreen> createState() => DateScreenState();
}

class DateScreenState extends State<DateScreen> with TickerProviderStateMixin {
  late TabController _controller;
  bool showFloatingB = true;
  final dateController = DateController();
  String query = '';

  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    _controller.addListener(() {
      if (_controller.index == 0) {
        setState(() {
          showFloatingB = true;
        });
      } else {
        setState(() {
          showFloatingB = false;
        });
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  DateTime _currentDate = DateTime.now();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'الحجوزات',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.messenger,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
            child: TabBar(
              indicatorColor: ConstColors.primaryColor,
              controller: _controller,
              tabs: const [
                Tab(
                  child: Text(
                    'الحجوزات',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'قائمة الإنتظار',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 350,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffF3F4F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemCount: dateController.dateList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final item = dateController.dateList[index];
                              if (query.isNotEmpty &&
                                  !item.title
                                      .toLowerCase()
                                      .contains(query.toLowerCase())) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, bottom: 15),
                                child: DateCard(
                                  title: item.title,
                                  image: item.image,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 350,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffF3F4F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemCount: dateController.dateList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final item = dateController.dateList[index];
                              if (query.isNotEmpty &&
                                  !item.title
                                      .toLowerCase()
                                      .contains(query.toLowerCase())) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, bottom: 15),
                                child: WaitCard(
                                  title: item.title,
                                  image: item.image,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "مراجعة جديدة",
            iconColor: Colors.white,
            bubbleColor: Colors.grey,
            icon: Icons.local_hospital,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.black),
            onPress: () {},
          ),
        ],
        animation: _animation,
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        iconColor: Colors.black,
        iconData: Icons.add,
        backGroundColor: Colors.grey,
      ),
    );
  }
}
