import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jo_study/bloc/week_bloc.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/utils/consts.dart';
import 'package:jo_study/utils/date_utils.dart';

class WeekScreen extends StatefulWidget {
  @override
  _WeekScreenState createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  tables() => List.generate(
      24,
      (index) => TableRow(
          children: Utils.weekdays
              .map((day) => Container(
                    height: 80,
                    color: Colors.cyan,
                  ))
              .toList()));

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var firstDayOfWeek = Utils.firstDayOfWeek(now);
    var lastday = Utils.lastDayOfWeek(now);

    var thisWeek = Utils.daysInRange(firstDayOfWeek, lastday);

    debugPrint(firstDayOfWeek.toIso8601String());
    debugPrint(now.toIso8601String());
    debugPrint(lastday.toIso8601String());

    final WeekBloc bloc = BlocProvider.of<WeekBloc>(context);

    List<TableRow> extractTableRows(Map<DateTime, List<Classwork>> map) {
      List<TableRow> result = [];

      var rows = map.values
          .reduce((a, b) {
            return a.length > b.length ? a : b;
          })
          .asMap()
          .forEach((index, classwork) {
            result.add(TableRow(
                children: Cv.days.map((day) {
              var weekDay = map.keys.firstWhere((keyDay) {
                debugPrint("KEY DAY: ${keyDay.weekday}");
                debugPrint("DAY: ${day}");

                return keyDay.weekday == day;
              });

              var values = map[weekDay];
              if (values.length >= index) {
                return Container(
                  child: Text(day.toString()),
                  height: 80,
                  color: Colors.yellow,
                );
              } else {
                return Container(
                  child: Text(day.toString()),
                  height: 80,
                  color: Colors.greenAccent,
                );
              }

              var classwork = values[index];
            }).toList()));
          });

      return result;
    }

    return BlocBuilder<WeekBloc, WeekState>(
      bloc: bloc,
      builder: (context, state) {
        return StreamBuilder<Map<DateTime, List<Classwork>>>(
          stream: bloc.getClassworksForCurrentWeek(),
          builder: (context, snap) {
            debugPrint("WEEK STREAM BUILDER: ${snap}");

            if (snap.hasData) {
              var maxlength = snap.data.values.reduce((a, b) {
                return a.length > b.length ? a : b;
              }).length;

              return SingleChildScrollView(
                child: Container(
                  color: Colors.black54,
                  child: buildColumns(snap.data),
//                  buildBody(extractTableRows, snap),
                ),
              );
            } else {
              return Container(
                color: Colors.purpleAccent,
              );
            }
          },
        );
      },
    );
  }

  buildColumns(Map<DateTime, List<Classwork>> map) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          children: map.keys.map((d) {
            return Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: Center(child: Text(Utils.weekdays[d.weekday - 1])),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  ...map[d].map((classwork) {
                    var startDate = classwork.startDate;

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                      child: Container(
//                        child: Text("${startDate.hour}:${startDate.minute}"),
                        height: 50,
                        width: 50,
                        color: null != classwork.colorValue
                            ? Color(classwork.colorValue)
                            : Colors.black,
                      ),
                    );
                  }).toList()
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Table buildBody(
      List<TableRow> extractTableRows(Map<DateTime, List<Classwork>> map),
      AsyncSnapshot<Map<DateTime, List<Classwork>>> snap) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
            children: Cv.days
                .map((day) => Center(child: Text(Utils.weekdays[day])))
                .toList()),

        ...extractTableRows(snap.data),

//
//                      ...List.generate(
//                          maxlength,
//                          (index) => TableRow(
//                                  children: Cv.days.map((day) {
//                                var weekDay =
//                                    snap.data.keys.firstWhere((keyDay) {
//                                  keyDay.day == day;
//                                });
//
//                                return Container(
//                                  child: Text(day.toString()),
//                                  height: 80,
//                                  color: Colors.yellow,
//                                );
//                              }).toList()))
      ],
    );
  }
}
