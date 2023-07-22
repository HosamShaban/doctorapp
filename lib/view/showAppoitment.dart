import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edidAppoitments.dart';

class ShowDoctorAppoitments extends StatefulWidget {
  const ShowDoctorAppoitments({super.key});

  @override
  State<ShowDoctorAppoitments> createState() => _ShowDoctorAppoitmentsState();
}

class _ShowDoctorAppoitmentsState extends State<ShowDoctorAppoitments> {
  final String baseUrl = "https://diabetes-23.000webhostapp.com";
  // ignore: non_constant_identifier_names
  Map<String, dynamic> all_doctors = {};

  // ignore: unnecessary_cast
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
  void dispose() {
    all_doctors.clear();
    super.dispose();
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
          title: const Text(
            "مواعيد العيادة",
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
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: all_doctors['data']['work_hours'].length,
                itemBuilder: (context, index) {
                  final workHour = all_doctors['data']['work_hours'][index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff407BFF)),
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day: ${workHour['day']}',
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                      subtitle: Text(
                        'From  ${workHour['start_time'].toString().substring(0, 5)}  To   ${workHour['end_time'].toString().substring(0, 5)}',
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            int id = workHour['id'];
                            String day = workHour['day'];
                            String from = workHour['start_time'];
                            String to = workHour['end_time'];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditAppoit(
                                          id: id,
                                          day: day,
                                          from: from,
                                          to: to,
                                        )));
                          },
                          icon: const Icon(
                            Icons.edit_calendar,
                            color: Colors.white,
                          )),
                    ),
                  );
                },
              ));
  }
}
