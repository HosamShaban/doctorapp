import 'package:dio/dio.dart';
import 'package:doctorapp/view/view_bio.dart';
import 'package:doctorapp/view/view_mesures.dart';
import 'package:doctorapp/view/viewattachments.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Consts/colors.dart';
import '../Model/patint.dart';
import 'newbio.dart';
import 'newreviewB.dart';

class PatintProfile extends StatefulWidget {
  late int id;

  PatintProfile({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<PatintProfile> createState() => _PatintProfileState();
}

List<PaitentModel> patient = [];

class _PatintProfileState extends State<PatintProfile>
    with TickerProviderStateMixin {
  bool showWidget = false;
  void startTimer() {
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        showWidget = true;
      });
    });
  }

  int get id => widget.id;
  final String baseUrl = "https://diabete-23.000webhostapp.com";
  void FetchDoctorsFromApi() async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var response = await dio.get("$baseUrl/api/doctor/patientProfile/$id");

      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        var jsonData = response.data['data'];

        if (jsonData is List) {
          for (var doctorData in jsonData) {
            setState(() {
              patient.add(PaitentModel.fromJson(doctorData));
            });
          }
        } else if (jsonData is Map<String, dynamic>) {
          setState(() {
            patient.add(PaitentModel.fromJson(jsonData));
          });
        } else {
          // Handle other cases as needed
        }
      }
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  late TabController _controller;
  bool showFloatingB = true;

  late Animation<double> _animation;
  late AnimationController _animationController;
  @override
  void initState() {
    FetchDoctorsFromApi();
    startTimer();
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
    super.initState();
  }

  @override
  void dispose() {
    patient.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 30),
          child: InkWell(
            child: Image.asset("assets/images/whats.png"),
            onTap: () {
              String nom = patient[0].phoneNo.toString();
              final Uri whatsapp = Uri.parse('https://wa.me/$nom');
              launchUrl(whatsapp);
            },
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.only(right: 5),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        title: Text(
          "ملف المريض",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      body: patient.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 200.0,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        Center(child: Text("انتظر قليلا ")),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Center(
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage('assets/images/23.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        patient[0].name.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: const Text(
                          "حول المريض",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xffD9D9D9),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: Text(
                                patient[0].email.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: const Text(
                                "البريد الإلكتروني",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: Text(
                                patient[0].phoneNo.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: const Text(
                                "جوال",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: Text(
                                patient[0].address.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: const Icon(Icons.location_on),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: Text(
                                patient[0]
                                    .createdAt
                                    .toString()
                                    .substring(0, 10),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: const Text(
                                "مسجل منذ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),

                        //  Text(all_doctors[0].id.toString())
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: const Text(
                          "بياناته الطبية",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xffD9D9D9),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: Text(
                                  patient[0].age.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: const Text(
                                  "العمر",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: Text(
                                  patient[0].gender.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: const Text(
                                  "الجنس",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: Text(
                                  patient[0].diabeticType.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: const Text(
                                  "نوع السكري",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),

                  /* const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 311,
                      height: 48,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff407BFF)),
                          onPressed: () {
                            int uid = all_doctors[0].id!;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AppointmentBooking(id: uid)));
                          },
                          child: const Text(
                            "حجز موعد",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          )),
                    ),
                  ),*/
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: const Text(
                          "حالة المريض",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    //: const EdgeInsets.only(left: 15, right: 15),
                    padding: const EdgeInsets.all(15),
                    width: 360,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xffD9D9D9),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          patient[0].patientStatus.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: MaterialButton(
                                height: 50,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                color: ConstColors.primaryColor,
                                child: const Text(
                                  "قياسات السكر",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                onPressed: () {
                                  int id = patient[0].id as int;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewPatintMesures(
                                                id: id,
                                              )));
                                })),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: MaterialButton(
                                height: 50,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                color: ConstColors.primaryColor,
                                child: const Text(
                                  "السيرة المرضية",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                onPressed: () {
                                  int id = patient[0].id as int;
                                  String name = patient[0].name as String;

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewPatintBio(
                                                id: id,
                                                name: name,
                                              )));
                                })),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: MaterialButton(
                                height: 50,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                color: ConstColors.primaryColor,
                                child: const Text(
                                  "المرفقات",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                onPressed: () {
                                  int id = patient[0].id as int;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewPatintAttachments(
                                                id: id,
                                              )));
                                })),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const SizedBox(height: 100),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "مراجعة جديدة",
            iconColor: Colors.white,
            bubbleColor: Colors.red,
            icon: Icons.add_alarm,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              int id = patient[0].id as int;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewReviewDetails(
                            id: id,
                          )));
            },
          ),
          Bubble(
            title: "اضافة سيرة مرضية ",
            iconColor: Colors.white,
            bubbleColor: Colors.red,
            icon: Icons.local_hospital_sharp,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              int id = patient[0].id as int;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewBio(
                            id: id,
                          )));
            },
          ),
        ],
        animation: _animation,
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        iconColor: Colors.white,
        iconData: Icons.add,
        backGroundColor: Colors.red,
      ),
    );
  }
}
