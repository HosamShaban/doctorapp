import 'package:flutter/material.dart';

class NewReview extends StatefulWidget {
  const NewReview({Key? key}) : super(key: key);

  @override
  State<NewReview> createState() => _NewReviewState();
}

class _NewReviewState extends State<NewReview> {
  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TimeOfDay time = const TimeOfDay(hour: 7, minute: 15);

  void selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (newTime != null) {
      setState(() {
        time = newTime;
      });
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
        title: const Text(
          "مراجعة جديدة",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 15, left: 100),
              child: const Text("يرجى تحديد وقت و موعد المراجعة للمريض الجديد")),
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
              onTap: () => selectDate(context),
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                hintText: "7/11/1961",
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
              onTap: selectTime,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.punch_clock_rounded),
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
                  style: ElevatedButton.styleFrom(backgroundColor : const Color(0xff407BFF)),
                  onPressed: () {},
                  child: const Text(
                    "حفظ",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
