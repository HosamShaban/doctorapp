import 'package:dio/dio.dart';
import 'package:doctorapp/view/newreview.dart';
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
  TextEditingController day = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();

  int get id => widget.id;
  final String baseUrl = "https://diabete-23.000webhostapp.com";

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
          "   مراجعة جديدة",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 15, left: 110),
              child: const Text("يرجى تحديد وقت و موعد المراجعة للمريض  ")),
          Container(
              margin: const EdgeInsets.only(top: 10, left: 270),
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
            padding: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: const Color(0xffEAEAEA),
                borderRadius: BorderRadius.circular(12.0)),
            width: 350,
            height: 48,
            child: TextFormField(
              controller: day,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.date_range),
                hintText: "Sunday",
                hintTextDirection: TextDirection.rtl,
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 10, left: 270),
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
            padding: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: const Color(0xffEAEAEA),
                borderRadius: BorderRadius.circular(12.0)),
            width: 350,
            height: 48,
            child: TextFormField(
              controller: date,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.calendar_today),
                hintText: "2023/7/5",
                hintTextDirection: TextDirection.rtl,
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 10, left: 270),
              child: const Text(
                "وقت المراجعة",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: const Color(0xffEAEAEA),
                borderRadius: BorderRadius.circular(12.0)),
            width: 350,
            height: 48,
            child: TextFormField(
              controller: time,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.timer),
                hintText: "8:15 ",
                hintTextDirection: TextDirection.rtl,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: SizedBox(
              width: 350,
              height: 48,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff407BFF)),
                  onPressed: () {
                    AddReview();
                  },
                  child: const Text(
                    "حفظ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
