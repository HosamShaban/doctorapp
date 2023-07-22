import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewReviewDetails extends StatefulWidget {
  late int id;

  NewReviewDetails({
    Key? key,
    required this.id,
  }) : super(key: key);
  @override
  State<NewReviewDetails> createState() => _NewReviewDetailsState();
}

class _NewReviewDetailsState extends State<NewReviewDetails> {
  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date.text =
            '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}';
      });
    }
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        time.text = selectedTime.format(context);
      });
    }
  }

  TextEditingController day = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();

  int get id => widget.id;
  final String baseUrl = "https://diabetes-23.000webhostapp.com";
  final _formKey = GlobalKey<FormState>();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  Future<void> AddReview() async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };
    var response = await dio.post("$baseUrl/api/doctor/addReview/$id", data: {
      "review_day": day.text.trim(),
      "review_date": date.text.trim(),
      "review_time": time.text.trim()
    });
    print(response.data);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'تم اضافة المراجعة بنجاح',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
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
          "مراجعة جديدة",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 15, left: 100),
                  child: const Text("يرجى تحديد وقت و موعد المراجعة للمريض  ")),
              const SizedBox(
                height: 10,
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10, left: 250),
                  child: const Text(
                    "يوم المراجعة",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                    color: const Color(0xffEAEAEA),
                    borderRadius: BorderRadius.circular(12.0)),
                width: 260,
                height: 48,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  },
                  controller: day,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Sunday",
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10, left: 250),
                  child: const Text(
                    "تاريخ المراجعة",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffEAEAEA),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                width: 260,
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: date,
                        onTap: () => selectDate(context),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          } else if (value.length <= 5 ||
                              !value.contains('/')) {
                            return ("من فضلك أدخل الاسم بشكل صحيح");
                          } else
                            return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "26/8/2023",
                          hintTextDirection: TextDirection.ltr,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => selectDate(context),
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 250),
                child: const Text(
                  "وقت المراجعة",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffEAEAEA),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                width: 260,
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: time,
                        onTap: () => selectTime(context),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          } else if (value.length <= 3 ||
                              !value.contains(':')) {
                            return ("من فضلك أدخل الاسم بشكل صحيح");
                          } else
                            return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "09:00",
                          hintTextDirection: TextDirection.ltr,
                          border: InputBorder.none,
                        ),
                        // Add onChanged callback to format the input as 24-hour format
                        onChanged: (value) {
                          if (value.length == 2 && !value.contains(':')) {
                            value += ':';
                            time.text = value;
                            time.selection = TextSelection.fromPosition(
                              TextPosition(offset: value.length),
                            );
                          }
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () => selectTime(context),
                      icon: const Icon(Icons.timer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 310,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color(0xff407BFF),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        AddReview();
                      }
                    },
                    child: const Text(
                      "حفظ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
