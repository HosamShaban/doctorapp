import 'package:flutter/material.dart';

class NewPatient extends StatelessWidget {
  const NewPatient({Key? key}) : super(key: key);

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
          "مريض جديدة",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xffEAEAEA),
                  borderRadius: BorderRadius.circular(12.0)),
              child: const ListTile(
                  leading: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  trailing: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: Text(
                    "توفيق احمد",
                    textDirection: TextDirection.rtl,
                  )),
            );
          }),
    );
  }
}