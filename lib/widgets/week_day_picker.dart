import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:jo_study/utils/consts.dart';
import 'package:jo_study/utils/date_utils.dart';

class WeekDayPicker extends StatefulWidget {
DateTime currentDate;
Set<int> pickedDay;

WeekDayPicker(this.currentDate, this.pickedDay);

@override
  _WeekDayPickerState createState() => _WeekDayPickerState();
}

class _WeekDayPickerState extends State<WeekDayPicker> {

  @override
  void initState() {
    widget.pickedDay.add(widget.currentDate.weekday-1);
    super.initState();
  }
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
                if (widget.pickedDay.contains(getIndexOfDay(day))) {
                  widget.pickedDay.remove(getIndexOfDay(day));
                } else {
                  widget.pickedDay.add(getIndexOfDay(day));
                }
              });
            },
            child: Container(
              color: widget.pickedDay.contains(getIndexOfDay(day)) ? Colors.white70:Colors.white12 ,
              height: 40,
              width: 40,
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  int getIndexOfDay(String day) => Utils.weekdays.indexOf(day);
}
