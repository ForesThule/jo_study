import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jo_study/bloc/blocs.dart';
import 'package:jo_study/bloc/events.dart';
import 'package:jo_study/bloc/month_bloc.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/widgets/custom_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

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
          date: date,
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

        return SingleChildScrollView(
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

                  ...snapshot.data.map((classwork) => classworkListItem(classwork)).toList()


                ],
              );





                      return Flexible(
                        flex: 2,
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) =>
                                classworkListItem(snapshot.data[index])),
                      );
                    } else {
                      return calendarWidget(addClasswork, selectDay);
                    }
                  });



            },
          ),
        );

        return StreamBuilder<List<Classwork>>(
            stream: bloc.repo.classworksForDay(calendarController.selectedDay),
            builder: (context, snapshot) {
              debugPrint("SNAPSHOT: $snapshot");

              if (snapshot.hasData) {
//
//
//                return CustomScrollView(
//                  slivers: <Widget>[
//                    SliverAppBar(
//                      stretch: true,
//
//                      expandedHeight: w.maxHeight / 2,
//                      flexibleSpace: ,
////              stretch: true,
////              pinned: true,
////              automaticallyImplyLeading: true,
//                      shape: ContinuousRectangleBorder(
//                          borderRadius: BorderRadius.only(
//                              bottomLeft: Radius.circular(100),
//                              bottomRight: Radius.circular(100))),
////              leading:
//                    ),
//                    SliverList(
//                      delegate: SliverChildBuilderDelegate((ctx, index) {
//                        return Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Container(
//                            height: 24,
//                            width: 100,
//                            color: Colors.blue,
//                          ),
//                        );
//                      }, childCount: snapshot.data.length),
//                    )
//                  ],
//                );
//              },
//            );

                return Container(
                  height: 24,
                  width: 100,
                  color: Colors.blue,
                );
              } else {
                return LayoutBuilder(
                  builder: (ctx, w) {
                    return CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          stretch: true,

                          expandedHeight: w.maxHeight / 2,
                          flexibleSpace: TableCalendar(
                              rowHeight: 12,
                              onDayLongPressed: (DateTime date, list) {
                                addClasswork(date, list);
                              },
                              onDaySelected: (day, list) {
                                selectDay(day);
                              },
                              calendarStyle: CalendarStyle(
                                  todayColor: Color(0xffF6AA7B),
                                  markersColor: Color(0xffF6AA7B)),
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              locale: Locale("ru_Ru"),
                              calendarController: calendarController),
//              stretch: true,
//              pinned: true,
//              automaticallyImplyLeading: true,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(100),
                                  bottomRight: Radius.circular(100))),
//              leading:
                        ),
                      ],
                    );
                  },
                );

                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, s) {
                      return Container(
                        height: 24,
                        width: 100,
                        color: Colors.blue,
                      );
                    });
              }
            });
//        } else {
//          return Container();
//        }
      },
    );
  }

  TableCalendar calendarWidget(addClasswork(DateTime date, List list), void selectDay(DateTime day)) {
    return TableCalendar(
//                            rowHeight: maxHeight / 6,
                      availableGestures: AvailableGestures.none,
                      onDayLongPressed: (DateTime date, list) {
                        addClasswork(date, list);
                      },
                      onDaySelected: (day, list) {
                        selectDay(day);
                      },
                      headerStyle: HeaderStyle(formatButtonVisible: false,centerHeaderTitle: true),
                      calendarStyle: CalendarStyle(
                          todayColor: Color(0xffF6AA7B),
                          markersColor: Color(0xffF6AA7B)),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      locale: "ru_Ru",
                      calendarController: calendarController);
  }

  Padding classworkListItem(Classwork classwork) {
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
          height: 36,
          width: 100,
          child: Text("описание"),
        ),
        title: Container(
          height: 36,
          width: 100,
          child: classwork.subject != null
              ? Text(classwork.subject)
              : Text("Предмет"),
        ),
      ),
    );
  }
}

//child: StreamBuilder<List<Classwork>>(
//stream:
//bloc.repo.classworksForDay(calendarController.selectedDay),
//builder: (context, snapshot) {
//if (snapshot.hasData) {
//return Container();
//} else {
//return ListView.builder(
//itemCount: snapshot.data.length,
//itemBuilder: (context, s) {});
//}
//}),
