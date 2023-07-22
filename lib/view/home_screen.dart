import 'package:dio/dio.dart';
import 'package:doctorapp/controller/date_controller.dart';
import 'package:doctorapp/view/patintProfile.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/patint.dart';
import '../auth/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<PaitentModel> allPatients = [];

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool showWidget = false;
  void startTimer() {
    Future.delayed(const Duration(seconds: 7), () {
      setState(() {
        showWidget = true;
      });
    });
  }

  final dateController = DateController();
  String query = '';
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    descStyle: const TextStyle(fontWeight: FontWeight.bold),
    descTextAlign: TextAlign.center,
    animationDuration: const Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(color: Colors.red, fontSize: 25),
    alertAlignment: Alignment.center,
  );
  final String baseUrl = "https://diabetes-23.000webhostapp.com";
  void FetchDoctorsFromApi() async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var response = await dio.get("$baseUrl/api/doctor/allPatients");

      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        var jsonData = response.data['data'];

        if (jsonData is List) {
          for (var doctorData in jsonData) {
            setState(() {
              allPatients.add(PaitentModel.fromJson(doctorData));
            });
          }
        } else if (jsonData is Map<String, dynamic>) {
          setState(() {
            allPatients.add(PaitentModel.fromJson(jsonData));
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
    allPatients.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Alert(
                  context: context,
                  style: alertStyle,
                  type: AlertType.warning,
                  title: "تسجيل الخروج",
                  desc: "هل تريد تسجيل الخروج من التطبيق ؟",
                  buttons: [
                    DialogButton(
                      child: const Text(
                        "نعم",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        Logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'تم تسجيل خروجك',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                      color: Colors.red,
                      radius: BorderRadius.circular(8.0),
                    ),
                  ],
                ).show();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/ppt.png"),
                  const SizedBox(width: 10),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: const Text(
                      'Your Patients ',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            /* Center(
              child: SizedBox(
                width: 311,
                height: 48,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff407BFF)),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var token = prefs.getString('token');
                      print(token);
                    },
                    child: const Text(
                      "تحدث مع الطبيب",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    )),
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 400,
                height: 525,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff407BFF)),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: allPatients.isEmpty
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
                                            width: 155,
                                            height: 155,
                                            child:
                                                const CircularProgressIndicator(
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: showWidget
                                              ? const Text(
                                                  'ليس لديك اي مرضى ',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              : Center(
                                                  child: Container(
                                                    width: 150,
                                                    height: 150,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: allPatients.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    int id = allPatients[index].id as int;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PatintProfile(id: id),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    height: 70,
                                    margin: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue,
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
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: ListTile(
                                        leading: Image.asset(
                                            "assets/images/meed.png"),
                                        trailing: const Expanded(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 27,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                allPatients[index]
                                                    .name
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        subtitle: Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.email_outlined,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  allPatients[index]
                                                      .email
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future Logout() async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      dio.options.headers = {'Authorization': 'Bearer $token'};
      var response = await dio.get("$baseUrl/api/logout");

      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        allPatients.clear();
        print(response.data);

        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        print('Error : ${response.data}');
      }
    } on DioError catch (e) {
      print(e.toString());
    }
  }
}
