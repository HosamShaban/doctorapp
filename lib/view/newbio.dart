import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewBio extends StatefulWidget {
  late int id;

  NewBio({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<NewBio> createState() => _NewBioState();
}

class _NewBioState extends State<NewBio> {
  TextEditingController diagnostics = TextEditingController();
  TextEditingController medications = TextEditingController();
  int get id => widget.id;
  final String baseUrl = "https://diabete-23.000webhostapp.com";

  Future<void> AddBio() async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };
    var response = await dio.post("$baseUrl/api/doctor/addPatientBiography/$id",
        data: {
          "diagnostics": diagnostics.text.trim(),
          "medications": medications.text.trim()
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
          " سيرة مرضية جديدة",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 30),
            Container(
              child: const Text(
                "قم باضافة سيرة مرضية جديدة للمريض",
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "التشخيص",
              style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xffEAEAEA),
                  borderRadius: BorderRadius.circular(12.0)),
              width: 327,
              height: 108,
              child: TextFormField(
                controller: diagnostics,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: "صف حالة المريض",
                  hintTextDirection: TextDirection.rtl,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              child: const Text(
                "العلاج",
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 40),
              padding: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                  color: const Color(0xffEAEAEA),
                  borderRadius: BorderRadius.circular(12.0)),
              width: 327,
              height: 108,
              child: TextFormField(
                controller: medications,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: "ماهو علاجك لحالة المريض",
                  hintTextDirection: TextDirection.rtl,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 327,
              height: 48,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff407BFF)),
                  onPressed: () {
                    AddBio();
                  },
                  child: const Text(
                    "حفظ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
