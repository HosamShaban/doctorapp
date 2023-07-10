import 'package:dio/dio.dart';
import 'package:doctorapp/view/edit.dart';
import 'package:doctorapp/view/patintProfile.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Consts/colors.dart';
import '../Model/appotments.dart';

class MyAppoitmnts extends StatefulWidget {
  const MyAppoitmnts({super.key});

  @override
  State<MyAppoitmnts> createState() => _MyAppoitmntsState();
}

class _MyAppoitmntsState extends State<MyAppoitmnts> {
  List<AppointmentsModel> all_appoitments = [];
  @override
  void initState() {
    FetchDoctorsFromApi();
    //fetchDataWithToken();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    all_appoitments.clear();
    super.dispose();
  }

  bool showWidget = false;
  void startTimer() {
    Future.delayed(Duration(seconds: 7), () {
      setState(() {
        showWidget = true;
      });
    });
  }

  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    descTextAlign: TextAlign.center,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(color: Colors.blue, fontSize: 25),
    alertAlignment: Alignment.center,
  );

  late int id;
  final String baseUrl = "https://diabete-23.000webhostapp.com";
  Future<void> ConfirmedAppoitment() async {}

  void FetchDoctorsFromApi() async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var response =
          await dio.get("$baseUrl/api/doctor/showAllBookedAppointments");

      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        var jsonData = response.data['data'];

        if (jsonData is List) {
          for (var doctorData in jsonData) {
            setState(() {
              all_appoitments.add(AppointmentsModel.fromJson(doctorData));
            });
          }
        } else if (jsonData is Map<String, dynamic>) {
          setState(() {
            all_appoitments.add(AppointmentsModel.fromJson(jsonData));
          });
        } else {
          // Handle other cases as needed
        }
      }
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
            "الحجوزات",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: all_appoitments.isEmpty
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
                              child: const CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          Center(
                            child: showWidget
                                ? const Text(
                                    'ليس لديك اي حجوزات ',
                                    style: TextStyle(color: Colors.red),
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
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: all_appoitments.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              print(
                                  all_appoitments[index].patientId.toString());
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: 270,
                              margin: EdgeInsets.all(15),
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
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        int id =
                                            all_appoitments[index].id as int;
                                        String day = all_appoitments[index]
                                            .bookingDay
                                            .toString();
                                        String date = all_appoitments[index]
                                            .bookingDate
                                            .toString();
                                        String time = all_appoitments[index]
                                            .bookingTime
                                            .toString();
                                        String st = all_appoitments[index]
                                            .status
                                            .toString();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPatintBookingTime(
                                                    id: id,
                                                    time: time,
                                                    date: date,
                                                    day: day,
                                                    status: st,
                                                  )),
                                        );
                                      },
                                      child: Text(
                                        "تعديل الموعد",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      all_appoitments[index].id.toString() +
                                          " : رقم الحجز",
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(width: 20),
                                    all_appoitments[index]
                                            .status
                                            .toString()
                                            .startsWith("pen")
                                        ? const Text(
                                            "بانتظار الرد",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          )
                                        : const Text(
                                            "",
                                          ),
                                  ],
                                ),
                                subtitle: Column(
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Booking Day : ",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          child: Text(
                                            all_appoitments[index]
                                                .bookingDay
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Booking Date : ",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          all_appoitments[index]
                                              .bookingDate
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Booking Time : ",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          all_appoitments[index]
                                              .bookingTime
                                              .toString()
                                              .substring(0, 5),
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Booking Status : ",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          child: Text(
                                            all_appoitments[index]
                                                .status
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: all_appoitments[index]
                                                        .status
                                                        .toString()
                                                        .startsWith("conf")
                                                    ? Colors.green
                                                    : all_appoitments[index]
                                                            .status
                                                            .toString()
                                                            .startsWith("can")
                                                        ? Colors.red
                                                        : Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10,
                                                left: 10,
                                                top: 20,
                                                bottom: 15),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                if (all_appoitments[index]
                                                    .status
                                                    .toString()
                                                    .startsWith("can")) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                        'الحجز تم رفضه مسبقا',
                                                        style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          fontSize: 20,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }
                                                if (all_appoitments[index]
                                                    .status
                                                    .toString()
                                                    .startsWith("conf")) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                        'لايمكن رفض حجز موافق عليه مسبقا',
                                                        style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          fontSize: 20,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }
                                                Alert(
                                                  context: context,
                                                  style: alertStyle,
                                                  type: AlertType.warning,
                                                  title: "رفض الحجز",
                                                  desc:
                                                      "هل تريد تأكيد رفض الحجز ؟",
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "نعم",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                      onPressed: () async {
                                                        final Dio dio = Dio();
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        var token = prefs
                                                            .getString('token');
                                                        dio.options.headers = {
                                                          'Authorization':
                                                              'Bearer $token',
                                                        };
                                                        id = all_appoitments[
                                                                index]
                                                            .id as int;
                                                        var response = await dio
                                                            .post(
                                                                "$baseUrl/api/doctor/updateAppointment/$id",
                                                                data: {
                                                              "status":
                                                                  "cancelled",
                                                            });
                                                        print(response.data);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(
                                                              'تم رفض الحجز',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Tajawal',
                                                                fontSize: 20,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      color: Colors.red,
                                                      radius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ],
                                                ).show();
                                              },
                                              minWidth: 145,
                                              height: 50,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              color: Colors.red,
                                              child: const Text(
                                                'رفض',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10,
                                                left: 10,
                                                top: 20,
                                                bottom: 15),
                                            child: MaterialButton(
                                              onPressed: () {
                                                if (all_appoitments[index]
                                                    .status
                                                    .toString()
                                                    .startsWith("can")) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                        'لايمكن قبول حجز مرفوض مسبقا',
                                                        style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          fontSize: 20,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }
                                                if (all_appoitments[index]
                                                    .status
                                                    .toString()
                                                    .startsWith("conf")) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      content: Text(
                                                        'الحجز موافق عليه مسبقا',
                                                        style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          fontSize: 20,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }
                                                Alert(
                                                  context: context,
                                                  style: alertStyle,
                                                  type: AlertType.success,
                                                  title: "قبول الحجز",
                                                  desc:
                                                      "هل تريد تأكيد قبول الحجز ؟",
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "نعم",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                      onPressed: () async {
                                                        final Dio dio = Dio();
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        var token = prefs
                                                            .getString('token');
                                                        dio.options.headers = {
                                                          'Authorization':
                                                              'Bearer $token',
                                                        };
                                                        id = all_appoitments[
                                                                index]
                                                            .id as int;
                                                        var response = await dio
                                                            .post(
                                                                "$baseUrl/api/doctor/updateAppointment/$id",
                                                                data: {
                                                              "status":
                                                                  "confirmed",
                                                            });
                                                        print(response.data);

                                                        // ignore: use_build_context_synchronously
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            backgroundColor:
                                                                Colors.green,
                                                            content: Text(
                                                              'تم تأكيد الحجز بنجاح',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Tajawal',
                                                                fontSize: 20,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      color: Colors.green,
                                                      radius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ],
                                                ).show();
                                              },
                                              minWidth: 145,
                                              height: 50,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              color: ConstColors.primaryColor,
                                              child: const Text(
                                                'قبول',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    /* Row(
                                      children: [
                                        Expanded(
                                          child: MaterialButton(
                                            onPressed: () {},
                                            minWidth: 145,
                                            height: 50,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                            color: Colors.green,
                                            child: const Text(
                                              'تعديل الموعد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )*/
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ));
  }
}
