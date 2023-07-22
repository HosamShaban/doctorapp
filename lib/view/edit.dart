import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'confirmed.dart';
import 'my_appoitments.dart';

class EditPatintBookingTime extends StatefulWidget {
  late int id;
  late String day;
  late String date;
  late String time;
  late String status;

  EditPatintBookingTime(
      {Key? key,
      required this.id,
      required this.day,
      required this.date,
      required this.status,
      required this.time})
      : super(key: key);

  @override
  State<EditPatintBookingTime> createState() => _EditPatintBookingTimeState();
}

class _EditPatintBookingTimeState extends State<EditPatintBookingTime> {
  int get id => widget.id;
  String get day => widget.day;
  String get date => widget.date;
  String get time => widget.time;
  String get status => widget.status;
  TextEditingController timeController = TextEditingController();
  final String baseUrl = "https://diabetes-23.000webhostapp.com";

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  Future<void> EditAppointment() async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };
    var response =
        await dio.post("$baseUrl/api/doctor/updateAppointment/$id", data: {
      "booking_time": timeController.text.trim(),
    });
    /*if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'تم تعديل موعدالحجز بنجاح',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }*/
    print(response.data);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text(
          "تعديل  موعد الحجز",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      body: status.toString().startsWith("can")
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 150,
                          width: 150,
                          child: Image.asset("assets/images/error.png"),
                        ),
                      ),
                      SizedBox(height: 25),
                      Center(
                        child: Container(
                            child: Text(
                          "! اجراء غير مسموح ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 25,
                          ),
                        )),
                      ),
                      SizedBox(height: 25),
                      Center(
                        child: Container(
                            child: Text(
                          "لايمكنك التعديل على حجز مرفوض مسبقا",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 25),
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 20),
                            const Text(
                              "اليوم",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: const Color(0xffEAEAEA),
                                  borderRadius: BorderRadius.circular(12.0)),
                              width: 311,
                              height: 48,
                              child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: day,
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintTextDirection: TextDirection.rtl,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "التاريخ",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: const Color(0xffEAEAEA),
                                  borderRadius: BorderRadius.circular(12.0)),
                              width: 311,
                              height: 48,
                              child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  hintText: date,
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintTextDirection: TextDirection.rtl,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "الوقت",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: const Color(0xffEAEAEA),
                                  borderRadius: BorderRadius.circular(12.0)),
                              width: 311,
                              height: 48,
                              child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  hintText: time.substring(0, 5),
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintTextDirection: TextDirection.rtl,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "الوقت",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: const Color(0xffEAEAEA),
                                  borderRadius: BorderRadius.circular(12.0)),
                              width: 311,
                              height: 48,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'هذا الحقل مطلوب';
                                  } else if (!value.contains(":")) {
                                    return 'أدخل وقت صحيح';
                                  }
                                  return null;
                                },
                                controller: timeController,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  hintText: "ادخل الموعد الجديد هنا",
                                  hintTextDirection: TextDirection.rtl,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: SizedBox(
                          width: 311,
                          height: 48,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff407BFF)),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  EditAppointment();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'تم تعديل الموعد بنجاح',
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'فشل تعديل الموعد',
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "تعديل",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              )),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: 311,
                          height: 48,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff407BFF)),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ConfirmedAppoitments()));
                              },
                              child: const Text(
                                "استعراض",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
