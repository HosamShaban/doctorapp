import 'package:doctorapp/view/newreview.dart';
import 'package:flutter/material.dart';

class NewReviewDetails extends StatelessWidget {
  const NewReviewDetails({Key? key}) : super(key: key);

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
          "مراجعة جديدة",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
              // Add your navigation code here, e.g.:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewReview()),
              );
            },
            child: Container(
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
            ),
            );
          }),
    );
  }
}
