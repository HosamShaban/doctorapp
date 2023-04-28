import 'package:doctorapp/Consts/Defaultimages.dart';
import 'package:doctorapp/Model/date_model.dart';
import 'package:flutter/material.dart';

class DateController extends ChangeNotifier {
  int _tabFlag = 0;

  int get tabFlag => _tabFlag;

  set tabFlag(int value) {
    _tabFlag = value;
    notifyListeners();
  }

  List<DateModel> dateList = [
    DateModel("محمد", DefaultImages.profile , "العيادة"),
    DateModel("حسام", DefaultImages.profile , "منزلي"),
    DateModel("عبدالله", DefaultImages.profile , "العيادة"),
    DateModel("احمد", DefaultImages.profile , "منزلي"),
  ];

}
