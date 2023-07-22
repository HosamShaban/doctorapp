import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Consts/colors.dart';

class ViewPatintBio extends StatefulWidget {
  late int id;
  late String name;
  ViewPatintBio({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<ViewPatintBio> createState() => _ViewPatintBioState();
}

class _ViewPatintBioState extends State<ViewPatintBio> {
  int get id => widget.id;
  String get name => widget.name;

  final String baseUrl = "https://diabetes-23.000webhostapp.com";
  // ignore: non_constant_identifier_names
  Map<String, dynamic> bio = {};

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
          bio = response.data;
        });
      }
    } on DioError catch (e) {
      print('Error retrieving doctor information: $e');
    }
  }

  @override
  void initState() {
    FetchMesuresFromApi();
    //fetchDataWithToken();
    super.initState();
  }

  @override
  void dispose() {
    bio.clear();
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
          title: const Text(
            " سجل التشخيصات",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        body: bio.isEmpty
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
                itemCount: bio['data']['patient_biography'].length,
                itemBuilder: (context, index) {
                  final Bio = bio['data']['patient_biography'][index];
                  return Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: ConstColors.primaryColor,
                    ),
                    child: ListTile(
                      title: Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    "$name",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                Text(
                                  " / الاسم",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    bio['data']['age'].toString(),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                Text(
                                  " / العمر",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    bio['data']['diabetic_type'].toString(),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                Text(
                                  " / نوع السكري",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 190),
                                child: const Text(
                                  " : التشخيص",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            ' ${Bio['diagnostics']}',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: Text(
                                  ": العلاج",
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            ' ${Bio['medications']}',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                ' ${Bio['created_at']}'.substring(0, 11),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                              const Text(
                                " / تاريخ التشخيص",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                ' ${Bio['created_at']}'.substring(12, 17),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              const Text(
                                "/ الساعة",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
