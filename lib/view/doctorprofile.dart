import 'package:dio/dio.dart';
import 'package:doctorapp/view/showAppoitment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class doctorProfile extends StatefulWidget {
  late int id;
  doctorProfile({Key? key}) : super(key: key);

  @override
  State<doctorProfile> createState() => _doctorProfileState();
}

class _doctorProfileState extends State<doctorProfile> {
  final String baseUrl = "https://diabetes-23.000webhostapp.com";

  // ignore: non_constant_identifier_names
  Map<String, dynamic> all_doctors = {};

  // ignore: unnecessary_cast
  int get id => widget.id as int;
  // ignore: non_constant_identifier_names

  // ignore: non_constant_identifier_names
  void FetchDoctorsFromApi() async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var response = await dio.get("$baseUrl/api/doctor/profile");

      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          all_doctors = response.data;
        });
      }
    } on DioError catch (e) {
      print('Error retrieving doctor information: $e');
    }
  }

  @override
  void initState() {
    FetchDoctorsFromApi();
    //fetchDataWithToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "صفحتي الشخصية",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: all_doctors.isEmpty
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
                              child: const CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          const Center(child: Text("انتظر قليلا ")),
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
                          backgroundImage:
                              AssetImage('assets/images/doctor(2).png'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${all_doctors['data']['name'] ?? 'N/D'}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.verified,
                            size: 15,
                            color: Colors.blue,
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.email,
                                size: 20,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${all_doctors['data']['email'] ?? 'N/D'}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        margin: const EdgeInsets.only(left: 220),
                        child: const Text(
                          " بيانات العيادة",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        width: 327,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xffD9D9D9),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowDoctorAppoitments()));
                                    },
                                    child: const Text(
                                      "استعراض وتعديل",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Text(
                                    "ساعات العمل",
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
                                    '${all_doctors['data']['phone_No'] ?? 'N/D'}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Text(
                                    "رقم الجوال",
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
                                  margin: const EdgeInsets.only(right: 15),
                                  width: 70,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${all_doctors['data']['status'] ?? 'N/D'}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: all_doctors['data']['status']
                                                  .toString()
                                                  .startsWith("ope")
                                              ? Colors.blue
                                              : all_doctors['data']['status']
                                                      .toString()
                                                      .startsWith("clos")
                                                  ? Colors.red
                                                  : Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Text(
                                    "حالة العيادة",
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
                                    '${all_doctors['data']['address'] ?? 'N/D'}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Text(
                                    "العنوان",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(left: 260),
                        child: const Text(
                          "مؤهلاتك",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xffD9D9D9),
                        ),
                        child: Text(
                          '${all_doctors['data']['qualifications'] ?? 'N/D'}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ]),
              ));
  }
}
