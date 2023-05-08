import 'package:doctorapp/Consts/colors.dart';
import 'package:doctorapp/controller/date_controller.dart';
import 'package:doctorapp/view/newpatient.dart';
import 'package:doctorapp/view/newreviewB.dart';
import 'package:doctorapp/widget/NavBar.dart';
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

  void _navigateToPreviousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, _currentDate.day);
    });
  }

  void _navigateToNextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, _currentDate.day);
    });
  }

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    endDrawer: NavBar(),
    appBar: AppBar(
      elevation: 0.0,
      title: const Text(
        ' مواعيد العيادة',
        style: TextStyle(fontSize: 20, color: Colors.black , fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () {
          },
          icon: const Icon(
            Icons.email_outlined,
            color: Colors.black,
          ),
        ),

        IconButton(
          onPressed: () {
          },
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
      ],
    ),
    body: Column(
      children: [
       const SizedBox(height: 5,),
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Text('الجمعة', style: TextStyle(fontWeight: FontWeight.w700 , color: Color(0xff909090))),
        Text('الخميس', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff909090))),
        Text('الأربعاء', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff909090))),
        Text('الثلاثاء', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff909090))),
        Text('الاثنين', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff909090))),
        Text('الأحد', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff909090))),
        Text('السبت', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff909090))),

      ],
    ),
    const SizedBox(height: 10),
        Row(
          children: [
            IconButton(
              onPressed: _navigateToPreviousMonth,
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(31, (index) {
                    return GestureDetector(
                      onTap: () {
                        },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        width: 30,
                        height: 30,
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            IconButton(
              onPressed: _navigateToNextMonth,
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
        const SizedBox(height: 30),
    Container(
      decoration: const BoxDecoration(
        color:  Color(0xFFF3F4F9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        ),
      ),
        child:TabBar(
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
            children:  [
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
  ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "مريض جديد",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.person,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
             Navigator.push(context,MaterialPageRoute(builder: (context) => const NewPatient()));

            },
          ),
          Bubble(
            title: "مراجعة جديدة",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.local_hospital,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => const NewReviewDetails()));
            },
          ),
        ],
        animation: _animation,
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        iconColor: Colors.white,
        iconData: Icons.add,
        backGroundColor: Colors.blue,
      ),
  );
}
}
