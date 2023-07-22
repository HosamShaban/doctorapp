import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Consts/colors.dart';

class ViewPatintMesures extends StatefulWidget {
  late int id;

  ViewPatintMesures({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ViewPatintMesures> createState() => _ViewPatintMesuresState();
}

class _ViewPatintMesuresState extends State<ViewPatintMesures> {
  int get id => widget.id;
  final String baseUrl = "https://diabetes-23.000webhostapp.com";
  // ignore: non_constant_identifier_names
  Map<String, dynamic> allmesures = {};
  bool showWidget = false;
  void startTimer() {
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        showWidget = true;
      });
    });
  }
  // ignore: unnecessary_cast
  // ignore: non_constant_identifier_names

  // ignore: non_constant_identifier_names
  void FetchMesuresFromApi() async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var response = await dio.get("$baseUrl/api/doctor/patientProfile/$id");

      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          allmesures = response.data;
        });
      }
    } on DioError catch (e) {
      print('Error retrieving doctor information: $e');
    }
  }

  @override
  void initState() {
    FetchMesuresFromApi();
    startTimer();
    //fetchDataWithToken();
    super.initState();
  }

  @override
  void dispose() {
    allmesures.clear();
    super.dispose();
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
            "سجل قياسات المريض",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        body: allmesures.isEmpty
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
                itemCount: allmesures['data']['measurements'].length,
                itemBuilder: (context, index) {
                  final Mesures = allmesures['data']['measurements'][index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red,
                    ),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Fasting : ${Mesures['Fasting']}',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Creator : ${Mesures['creator']}',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Random : ${Mesures['random']}',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.date_range_sharp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${Mesures['created_at']}'.substring(0, 10),
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.timer,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${Mesures['created_at']}'.substring(11, 16),
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
