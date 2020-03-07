import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:jo_study/app_keys.dart';
import 'package:jo_study/bloc/blocs.dart';
import 'package:jo_study/bloc/events.dart';
import 'package:jo_study/bloc/month_bloc.dart';
import 'package:jo_study/bloc/states.dart';
import 'package:jo_study/bloc/task_bloc.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/model/task.dart';
import 'package:jo_study/utils/consts.dart';
import 'package:jo_study/utils/date_utils.dart';
import 'package:jo_study/widgets/week_day_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import 'color_picker.dart';

class TaskDialog extends StatefulWidget {
  final String title, description, buttonText;
  TaskBloc bloc;

  TaskDialog(
      {@required this.title,
      @required this.description,
      @required this.buttonText,
      @required this.bloc});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  Task task;

  TextEditingController subjController;

  TextEditingController whenController;

  TextEditingController noteController;

  CalendarController calendarController;

  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();

    subjController = TextEditingController();
    whenController = TextEditingController();
    noteController = TextEditingController();

    task = Task();

    subjController.addListener(() {
      task.subject = subjController.text;
    });

    whenController.addListener(() {
      task.date = calendarController.selectedDay;
    });

    noteController.addListener(() {
      task.note = noteController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("TASK DIALOG BUILD");

    void saveTask() {
      Navigator.pop(context);
      widget.bloc.add(AddTaskEvent(task));
    }

    void setDate(DateTime day) {
      debugPrint("DAY: $day");
      task.date = day;
      whenController.text = Utils.apiDayFormat(day);
    }

    void showCalendarDialog() {
      showGeneralDialog(
          barrierLabel: '',
          barrierDismissible: true,
          context: context,
          transitionDuration: Duration(milliseconds: 200),
          transitionBuilder: (context, anim1, anim2, child) {
            final curvedValue = Curves.easeInOutBack.transform(anim1.value);
            void onDaySelect(day, list) {
              setDate(day);
              Navigator.pop(context, true);
            }

            var tableCalendar = TableCalendar(
                headerStyle: HeaderStyle(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20)),
                    centerHeaderTitle: true,
                    formatButtonVisible: false),
                rowHeight: 50,
                onDaySelected: (date, list) {
                  onDaySelect(date, list);
                },
                calendarStyle: CalendarStyle(
                    todayColor: Color(0xffF6AA7B),
                    markersColor: Color(0xffF6AA7B)),
                startingDayOfWeek: StartingDayOfWeek.monday,
                locale: 'ru_RU',
                calendarController: calendarController);

            return Transform.scale(
              //              transform: Matrix4.translationValues(0.0, curvedValue * 50, 0.0),
              scale: curvedValue,
              //              angle: math.radians(anim1.value * 360),
              child: Opacity(
                opacity: anim1.value,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
//                      constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20)),
                        height: 400,
                        width: 400,
                        child: Material(child: tableCalendar)),
                  ),
                ),
              ),
            );
          },
          pageBuilder: (context, showAnimation, hideAnimation) {});
    }

    dialogContent(BuildContext context) {
      return Container(
        key: Key("task_dialog"),
//        padding: EdgeInsets.only(
//          top: Cv.avatarRadius,
//          bottom: Cv.padding,
//          left: Cv.padding,
//          right: Cv.padding,
//        ),
        margin: EdgeInsets.only(top: Cv.avatarRadius),
//        decoration: new BoxDecoration(
//          color: Colors.black,
//          shape: BoxShape.rectangle,
//          borderRadius: BorderRadius.circular(20),
//          border: Border(),
//          boxShadow: [
//            BoxShadow(
//              color: Colors.black26,
//              blurRadius: 30.0,
//              offset: const Offset(0, 20.0),
//            ),
//          ],
//        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
//                fontFamily: "yugothib",
                color: Color(0xffCC69A6),
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 8, 2, 2),
              child: SizedBox(
                  child: Container(
                    color: Colors.white12,
                  ),
                  height: 1.0),
            ),
            TextField(
              autofocus: false,

              decoration: InputDecoration(
                  hintText: "Предмет",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/flask.png",
                      height: 24,
                      width: 24,
                    ),
                  )),
//              key: Key(AppKeys.subjInput),
              controller: subjController,
            ),
//
//            RangeSlider(
//              values: RangeValues(),
//            ),

            SizedBox(height: 8.0),

            ColorPicker(
              onColorSelected: (color) {
                debugPrint("ON COLOR SELECT: $color");
                task.colorValue = color.value;
              },
            ),

            SizedBox(height: 8.0),

            TextField(
              readOnly: true,
              autofocus: false,
              onTap: () {
                showCalendarDialog();
              },

//              enabled: false,
              decoration: InputDecoration(
                  hintText: "Когда",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/when_icon.png",
                      height: 24,
                      width: 24,
                    ),
                  )),
//              key: Key(AppKeys.subjInput),

              controller: whenController,
            ),

            SizedBox(height: 8.0),
            TextField(
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "Заметки",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/clip_attach.png",
                      height: 24,
                      width: 24,
                    ),
                  )),
//              key: Key(AppKeys.subjInput),
              controller: noteController,
            ),

            FlatButton(
              padding: EdgeInsets.all(16),
              onPressed: () {
                saveTask();
              },
              child: Ink(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(colors: [
                        Color(0xffF6A97A),
                        Color(0xffCD69A6),
                      ])),
                  child: Padding(
                      padding: EdgeInsets.all(12), child: Text("СОХРАНИТЬ"))),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
            )
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Cv.customDialogPadding),
      ),
      elevation: 10,
      insetAnimationCurve: Curves.elasticInOut,
      insetAnimationDuration: Duration(milliseconds: 800),
      backgroundColor: Colors.black,
      child: SingleChildScrollView(child: dialogContent(context)),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  TextEditingController subjController;
  TextEditingController teacherController;
  TextEditingController placeController;
  Classwork classwork;

  DateTime date;

  BuildContext buildcontext;
  Bloc bloc;

  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.buttonText,
      this.image,
      this.date,
      this.buildcontext,
      this.bloc});

  @override
  Widget build(BuildContext context) {
    subjController = TextEditingController();
    teacherController = TextEditingController();
    placeController = TextEditingController();

    ValueNotifier<DateTime> startDate = ValueNotifier(DateTime.now());
    ValueNotifier<DateTime> finishDate = ValueNotifier(DateTime.now());

    classwork = Classwork();

    subjController.addListener(() {
      classwork.subject = subjController.text;
    });

    teacherController.addListener(() {
      classwork.tutor = teacherController.text;
    });

    placeController.addListener(() {
      classwork.subject = placeController.text;
    });
    placeController.addListener(() {
      classwork.subject = placeController.text;
    });

    ValueNotifier<bool> isEveryWeek = ValueNotifier(false);

//    final AppBloc bloc = BlocProvider.of<AppBloc>(buildcontext);

    void saveClasswork() {
      var result = classwork
//        ..startDate = DateTime.now()
//        ..finishDate = DateTime.now()
//        ..subject = subjController.text
        ..place = "404"
        ..tutor = "Kokokoev";

      bloc.add(AddClassworkEvent(result));

      Navigator.pop(context);
    }

    dialogContent(BuildContext context) {
      return Container(
        padding: EdgeInsets.only(
          top: Cv.avatarRadius + Cv.padding,
          bottom: Cv.padding,
          left: Cv.padding,
          right: Cv.padding,
        ),
        margin: EdgeInsets.only(top: Cv.avatarRadius),
        decoration: new BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Cv.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
//                fontFamily: "yugothib",
                color: Color(0xffCC69A6),
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                  hintText: "Предмет",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/flask.png",
                      height: 24,
                      width: 24,
                    ),
                  )),
              key: Key(AppKeys.subjInput),
              controller: subjController,
            ),
//
//            RangeSlider(
//              values: RangeValues(),
//            ),

            ColorPicker(
              onColorSelected: (color) {
                debugPrint("ON COLOR SELECT: $color");
                classwork.colorValue = color.value;
              },
            ),

//            SliderTheme(
//              data: SliderThemeData(
//                  rangeTrackShape: RectangularRangeSliderTrackShape()),
//              child: Slider(
//                value: 0,
//                divisions: 10,
//                min: 0,
//                max: 100,
//              ),
//            ),

            TextField(
              decoration: InputDecoration(
                  hintText: "Преподаватель",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/tutor.png",
                      height: 24,
                      width: 24,
                    ),
                  )),
              key: Key(AppKeys.dialogTeacherInput),
              controller: teacherController,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "Где?",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/map-marker.png",
                      height: 24,
                      width: 24,
                    ),
                  )),
              key: Key(AppKeys.dialog_place_input),
              controller: placeController,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Выбрать дни",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),

            WeekDayPicker(),

            Row(
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2018, 3, 5),
                          maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
//                        startDate.value =
//                            "${date.hour.toString()}:${date.minute.toString()}";
                        startDate.value = date;
                        classwork.startDate = date;
                      }, currentTime: startDate.value, locale: LocaleType.ru);
                    },
                    child: ValueListenableBuilder(
                      valueListenable: startDate,
                      builder: (ctx, value, ch) {
                        var dateString =
                            formatDate(value, [yyyy, '-', mm, '-', dd]);

                        return Text(
                          dateString,
                          style: TextStyle(color: Colors.blue),
                        );
                      },
                    )),
                FlatButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2018, 3, 5),
                          maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
//                        finishDate.value =
//                            "${date.hour.toString()}:${date.minute.toString()}";

                        finishDate.value = date;
                        classwork.finishDate = date;
                      }, currentTime: finishDate.value, locale: LocaleType.ru);
                    },
                    child: ValueListenableBuilder(
                        valueListenable: finishDate,
                        builder: (BuildContext context, DateTime value, child) {
                          var dateString =
                              formatDate(value, [yyyy, '-', mm, '-', dd]);

                          return Text(
                            dateString,
                            style: TextStyle(color: Colors.blue),
                          );
                        })),
              ],
            ),

            Row(
              children: <Widget>[
                ValueListenableBuilder(
                    valueListenable: isEveryWeek,
                    builder: (context, check, _) {
                      return Checkbox(
                        value: check,
                        onChanged: (check) {
                          isEveryWeek.value = check;
                        },
                      );
                    }),
                Text("Отображать каждую неделю")
              ],
            ),

            FlatButton(
              padding: EdgeInsets.all(16),
              onPressed: () {
                saveClasswork();
              },
              child: Ink(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(colors: [
                        Color(0xffF6A97A),
                        Color(0xffCD69A6),
                      ])),
                  child: Padding(
                      padding: EdgeInsets.all(12), child: Text("СОХРАНИТЬ"))),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
            )

//          Container(
//            height: 24,
//            child: ListView.builder(
//
//                scrollDirection: Axis.horizontal,
//                itemCount: Utils.weekdays.length,
//                itemBuilder: (context, index) {
//                  return Container(
//                    height: 24,
//                    width: 24,
//                    child: Text(
//                      Utils.weekdays[index],
//                      style: TextStyle(fontSize: 8),
//                    ),
//                  );
//                }
////
//                ),
//          ),

//          SizedBox(height: 24.0),
//          Align(
//            alignment: Alignment.bottomRight,
//            child: FlatButton(
//              onPressed: () {
//                Navigator.of(context).pop(); // To close the dialog
//              },
//              child: Text(buttonText),
//            ),
//          ),
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Cv.customDialogPadding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.black45,
      child: SingleChildScrollView(child: dialogContent(context)),
    );
  }
}
