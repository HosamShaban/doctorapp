import 'package:dio/dio.dart';
import 'package:doctorapp/view/showAppoitment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({super.key});

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  final String baseUrl = "https://diabete-23.000webhostapp.com";
  bool isButtonVisible = true;
  void hidenbtn() {
    setState(() {
      isButtonVisible = false;
    });
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController day = TextEditingController();
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  Future<void> addappointment() async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };
    var response = await dio.post("$baseUrl/api/doctor/addWorkHours", data: {
      "day": day.text.trim(),
      "start_time": from.text.trim(),
      "end_time": to.text.trim(),
    });
    print(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'مواعيد العيادة',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Form(
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
                      SizedBox(height: 30),
                      const Text(
                        "عزيزي الطبيب قم بتعبئة ايام العمل كاملة",
                        style: TextStyle(
                            color: Color.fromARGB(255, 230, 11, 11),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
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
                          controller: day,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'هذا الحقل مطلوب';
                            } else if (value.length <= 2) {
                              return 'أدخل اليوم بشكل صحيح';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "السبت",
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
                        "من",
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
                            if (value == null ||
                                value.isEmpty ||
                                value.length <= 3) {
                              return 'هذا الحقل مطلوب';
                            } else if (!value.contains(":")) {
                              return 'أدخل وقت صحيح';
                            }
                            return null;
                          },
                          controller: from,
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            hintText: "08:00",
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
                        "الى",
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
                          controller: to,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'هذا الحقل مطلوب';
                            } else if (!value.contains(":")) {
                              return 'أدخل وقت صحيح';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            hintText: "14:30",
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
                            addappointment();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  'تم انشاء الموعد بنجاح',
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
                                  'فشل انشاء الموعد',
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
                          "حفظ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        )),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ShowDoctorAppoitments()));
                        },
                        child: const Text(
                          "استعراض وتعديل",
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
