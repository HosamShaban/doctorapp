import 'package:doctorapp/Consts/colors.dart';
import 'package:flutter/material.dart';

class DateCard extends StatelessWidget {
  final String title;
  final String image;

  const DateCard({Key? key, required this.title, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffEAEAEA),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            //       Scaffold.of(context).showBottomSheet((context) => BottomSheet(onClosing: onClosing, builder: builder));
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                        const SizedBox(width: 30),
                        const Text(
                          'موعد الحجز : 7:15 صباحا',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ConstColors.text2Color,
                          ),
                        ),
                        const SizedBox(width: 40),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: ConstColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/images/Vector.png"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 20, left: 20, top: 20, bottom: 15),
                        child: MaterialButton(
                          onPressed: () {},
                          minWidth: 115,
                          height: 40,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          color: const Color(0xffE52222),
                          child: const Text(
                            'رفض',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 20, left: 20, top: 20, bottom: 15),
                        child: MaterialButton(
                          onPressed: () {},
                          minWidth: 115,
                          height: 40,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          color: ConstColors.primaryColor,
                          child: const Text(
                            'قبول',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
