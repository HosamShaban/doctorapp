import 'package:dio/dio.dart';
import 'package:doctorapp/view/showAppoitment.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAppoit extends StatefulWidget {
  late int id;
  late String day;
  late String from;
  late String to;

  EditAppoit(
      {Key? key,
      required this.id,
      required this.day,
      required this.to,
      required this.from})
      : super(key: key);

  @override
  State<EditAppoit> createState() => _EditAppoitState();
}

class _EditAppoitState extends State<EditAppoit> {
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
    titleStyle: TextStyle(color: Colors.red, fontSize: 25),
    alertAlignment: Alignment.center,
  );
  int get id => widget.id;
  String get day => widget.day;
  String get from => widget.from;
  String get to => widget.to;
  final String baseUrl = "https://diabete-23.000webhostapp.com";

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
        await dio.post("$baseUrl/api/doctor/editWorkHours/$id", data: {
      "day": day,
      "start_time": fromController.text.trim(),
      "end_time": toController.text.trim(),
    });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'تم تعديل موعدالدوام بنجاح',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    print(response.data);
  }

  final _formKey = GlobalKey<FormState>();
  Future<void> DeleteAppointment() async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };
    var response =
        await dio.post("$baseUrl/api/doctor/deleteWorkHours/$id", data: {
      "day": day,
      "start_time": fromController.text.trim(),
      "end_time": toController.text.trim(),
    });
    print(response.data);
  }

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
        title: Text(
          "تعديل الموعد",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
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
                            if (value == null || value.isEmpty) {
                              return 'هذا الحقل مطلوب';
                            } else if (!value.contains(":")) {
                              return 'أدخل وقت صحيح';
                            }
                            return null;
                          },
                          controller: fromController,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            hintText: from.substring(0, 5),
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
                          controller: toController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'هذا الحقل مطلوب';
                            } else if (!value.contains(":")) {
                              return 'أدخل وقت صحيح';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            hintText: to.substring(0, 5),
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
                const SizedBox(height: 25),
                Center(
                  child: SizedBox(
                    width: 311,
                    height: 48,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () async {
                          Alert(
                            context: context,
                            style: alertStyle,
                            type: AlertType.warning,
                            title: "حذف اليوم",
                            desc: "هل تريد تأكيد حذف اليوم والموعد ؟",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "نعم",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () async {
                                  DeleteAppointment();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'تم حذف اليوم',
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
                        child: const Text(
                          "حذف",
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
                                      ShowDoctorAppoitments()));
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
