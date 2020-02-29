import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:jo_study/utils/consts.dart';
import 'package:jo_study/utils/date_utils.dart';

class WeekDayPicker extends StatefulWidget {
  @override
  _WeekDayPickerState createState() => _WeekDayPickerState();
}

class _WeekDayPickerState extends State<WeekDayPicker> {
  Set<String> pickedDay = {};

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.weekdays.map((day) {
        return InkWell(
          focusColor: Colors.black,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (pickedDay.contains(day)) {
                  pickedDay.remove(day);
                } else {
                  pickedDay.add(day);
                }
              });
            },
            child: Container(
              color: pickedDay.contains(day) ? Colors.blue : Color(0xff828282),
              height: 36,
              width: 36,
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
