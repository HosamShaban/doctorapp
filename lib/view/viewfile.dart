import 'package:flutter/material.dart';

class ViewFike extends StatefulWidget {
  late String path;

  ViewFike({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  State<ViewFike> createState() => _ViewFikeState();
}

class _ViewFikeState extends State<ViewFike> {
  int pageNumber = 0;
  bool isPdfLoaded = true;
  String get path => widget.path;
  String file =
      'https://docs.google.com/gview?embedded=true&url=https://diabete-23.000webhostapp.com/api/patient/attachments/attachment19059849801688919052.pdf';
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
            "استعراض الملف",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        body: Center(
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
        ));
  }
}
