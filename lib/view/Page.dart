import 'package:doctorapp/Consts/Defaultimages.dart';
import 'package:doctorapp/Consts/colors.dart';
import 'package:doctorapp/controller/screenIndexProvider.dart';
import 'package:doctorapp/view/date_screen.dart';
import 'package:doctorapp/view/doctorprofile.dart';
import 'package:doctorapp/view/home_screen.dart';
import 'package:doctorapp/widget/tab_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatefulWidget {
  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late final ScaffoldState scaffoldState;

  @override
  void initState() {
    context.read<screenIndexProvider>().tabFlag = 0;
    super.initState();
  }

  List<dynamic> screens = [
    const HomeScreen(),
    const DateScreen(),
    const DoctorProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    final _screenindexprovider = Provider.of<screenIndexProvider>(context);
    int currentScreenIndex = _screenindexprovider.tabFlag;
    return Scaffold(
      body: screens[currentScreenIndex],
      bottomNavigationBar: Container(
        height: 60,
        width: 300,
        decoration: BoxDecoration(
          color: ConstColors.primaryColor,
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.04),
              offset: const Offset(0, -2),
            ),
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.10),
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TabCard(
              color: currentScreenIndex == 1
                  ? ConstColors.whiteFontColor
                  : ConstColors.deselectColor,
              image: DefaultImages.date,
              title: "مواعيدي",
              onTap: () {
                setState(() {
                  _screenindexprovider.tabFlag = 1;
                });
              },
            ),
            TabCard(
              color: currentScreenIndex == 0
                  ? ConstColors.whiteFontColor
                  : ConstColors.deselectColor,
              image: DefaultImages.home,
              title: "الرئيسية",
              onTap: () {
                setState(() {
                  _screenindexprovider.tabFlag = 0;
                });
              },
            ),
            TabCard(
              color: currentScreenIndex == 2
                  ? ConstColors.whiteFontColor
                  : ConstColors.deselectColor,
              image: DefaultImages.profile,
              title: "صفحتي",
              onTap: () {
                setState(() {
                  _screenindexprovider.tabFlag = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
