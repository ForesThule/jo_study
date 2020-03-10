import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jo_study/bloc/blocs.dart';
import 'package:jo_study/bloc/events.dart';
import 'package:jo_study/bloc/month_bloc.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/utils/date_utils.dart';
import 'package:jo_study/widgets/custom_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_format/date_format.dart';


class MonthScreen extends StatefulWidget {
  @override
  _MonthScreenState createState() => _MonthScreenState();
}

class _MonthScreenState extends State<MonthScreen> {
  CalendarController calendarController;

  @override
  void initState() {
    calendarController = CalendarController();
//    var focusedDay = calendarController.focusedDay;
//    calendarController.selectedDay;
//    calendarController.setSelectedDay(DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MonthBloc bloc = BlocProvider.of<MonthBloc>(context);
//    final AppBloc bloc = BlocProvider.of<AppBloc>(context);

    void selectDay(DateTime day) {
//      bloc.add(ShowClassworkForDay(day));
      bloc.getClassworksForDate(day);
    }

    addClasswork(DateTime date, [List list]) {
      debugPrint("ADD CLASSWORK");
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          bloc: bloc,
          buildcontext: context,
          currentDate: date,
          title: "Добавить занятие",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          buttonText: "Okay",
        ),
      );
    }

    return BlocBuilder<MonthBloc, MonthState>(
      builder: (ctx, state) {
//        if (state is CurrentDateState) {
        debugPrint("MONTH BUILDER" + state.toString());

        if (state is InitMonthViewState) {
          selectDay(DateTime.now());
        } else if (state is ClassworkSaved) {
          selectDay(calendarController.selectedDay);
        }

        return Scaffold(
          backgroundColor: Colors.blueGrey,
          body: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constrain) {
                var maxHeight = constrain.maxHeight;
//              var classworks = state.classworks;

//              bloc.getClassworksForDate(DateTime.now());

                return StreamBuilder<List<Classwork>>(
                    stream: bloc.controller.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            calendarWidget(addClasswork, selectDay),

                            Center(
//                              child: Text("${Utils.apiDayFormat(calendarController.selectedDay)}")
                              child: Text("${formatDate(calendarController.selectedDay, [yyyy, '-', M, '-', d])}")
                              ,),
                            ...snapshot.data
                                .map((classwork) => classworkListItem(classwork))
                                .toList()
                          ],
                        );
                      } else {
                        return calendarWidget(addClasswork, selectDay);
                      }
                    });
              },
            ),
          ),
        );
      },
    );
  }

  TableCalendar calendarWidget(
      addClasswork(DateTime date, List list), void selectDay(DateTime day)) {
    return TableCalendar(
        availableGestures: AvailableGestures.none,
        onDayLongPressed: (DateTime date, list) {
          addClasswork(date, list);
        },
        onDaySelected: (day, list) {
          selectDay(day);
        },
        headerStyle:
            HeaderStyle(

                leftChevronIcon: Icon(Icons.arrow_back_ios),
                rightChevronIcon: Icon(Icons.arrow_forward_ios),

                formatButtonVisible: false, centerHeaderTitle: true),
        calendarStyle: CalendarStyle(
            todayColor: Color(0xffF6AA7B), markersColor: Color(0xffF6AA7B)),
        startingDayOfWeek: StartingDayOfWeek.monday,
        locale: "ru_Ru",
        calendarController: calendarController);
  }

  Padding classworkListItem(Classwork classwork) {
    var startDate = classwork.startDate;
    var finishDate = classwork.finishDate;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 12,
          backgroundColor: null != classwork.colorValue
              ? Color(classwork.colorValue)
              : Colors.yellow,
        ),
        trailing: Container(
          child: Text(
              "${startDate.hour}:${startDate.minute} - ${finishDate.hour}:${finishDate.minute}"),
        ),
        title: Container(
          child: Center(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    classwork.subject ?? "Предмет",
                    style: TextStyle(fontSize: 24),
                  ))),
        ),
      ),
    );
  }
}
