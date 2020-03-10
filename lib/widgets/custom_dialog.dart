import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:jo_study/app_keys.dart';
import 'package:jo_study/bloc/blocs.dart';
import 'package:jo_study/bloc/events.dart';
import 'package:jo_study/bloc/exam_bloc.dart';
import 'package:jo_study/bloc/month_bloc.dart';
import 'package:jo_study/bloc/states.dart';
import 'package:jo_study/bloc/task_bloc.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/model/exam.dart';
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

class ExamDialog extends StatefulWidget {
  final String title, description, buttonText;
  ExamBloc bloc;

  ExamDialog(
      {@required this.title,
      @required this.description,
      @required this.buttonText,
      @required this.bloc});

  @override
  _ExamDialogState createState() => _ExamDialogState();
}

class _ExamDialogState extends State<ExamDialog> {
  Exam exam;

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

    exam = Exam();

    subjController.addListener(() {
      exam.subject = subjController.text;
    });

    whenController.addListener(() {
      exam.date = calendarController.selectedDay;
    });

    noteController.addListener(() {
      exam.note = noteController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("TASK DIALOG BUILD");

    void saveTask() {
      debugPrint("SAVE EXAM: $exam");
      Navigator.pop(context);
      widget.bloc.add(AddExamEvent(exam));
    }

    void setDate(DateTime day) {
      debugPrint("DAY: $day");
      exam.date = day;
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
        margin: EdgeInsets.only(top: Cv.avatarRadius),
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
                exam.colorValue = color.value;
              },
            ),

            SizedBox(height: 8.0),

            TextField(
              readOnly: true,
              autofocus: false,
              onTap: () {
                showCalendarDialog();
              },
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
  Set<int> pickedDays;

  DateTime currentDate;

  BuildContext buildcontext;
  Bloc bloc;

  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.buttonText,
      this.image,
      this.currentDate,
      this.buildcontext,
      this.bloc});

  @override
  Widget build(BuildContext context) {
    subjController = TextEditingController();
    teacherController = TextEditingController();
    placeController = TextEditingController();

    ValueNotifier<DateTime> startDateNotifier = ValueNotifier(currentDate);
    ValueNotifier<DateTime> finishDateNotifier = ValueNotifier(currentDate);

    pickedDays = {};

    classwork = Classwork()..colorValue = 0xFFE942A9;

    startDateNotifier.addListener(() {
      classwork.startDate = startDateNotifier.value;
    });

    finishDateNotifier.addListener(() {
      classwork.finishDate = finishDateNotifier.value;
    });

    subjController.addListener(() {
      classwork.subject = subjController.text;
    });

    teacherController.addListener(() {
      classwork.teacher = teacherController.text;
    });

    placeController.addListener(() {
      classwork.subject = placeController.text;
    });
    placeController.addListener(() {
      classwork.subject = placeController.text;
    });

    ValueNotifier<bool> isEveryWeek = ValueNotifier(false);

    isEveryWeek.addListener(() {
      classwork.isEveryWeekShow = isEveryWeek.value;
    });

    void saveClasswork() {
      bloc.add(AddClassworkEvent(classwork, pickedDays));
      Navigator.pop(context);
    }

    dialogContent(BuildContext context) {
      return Container(
        padding: EdgeInsets.only(
          top: 16,
          bottom: Cv.padding,
          left: Cv.padding,
          right: Cv.padding,
        ),
//        margin: EdgeInsets.only(top: Cv.avatarRadius),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 8, 2, 2),
              child: SizedBox(
                  child: Container(
                    color: Colors.white12,
                  ),
                  height: 1.0),
            ),
            SizedBox(height: 16.0),
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
              key: Key(AppKeys.subjInput),
              controller: subjController,
            ),
            ColorPicker(
              onColorSelected: (color) {
                debugPrint("ON COLOR SELECT: $color");
                classwork.colorValue = color.value;
              },
            ),
            TextField(

              autofocus: false,
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
              autofocus: false,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Выбрать дни",
                style: TextStyle(
                  color: Color(0xffCC69A6),
                  fontSize: 16.0,
                ),
              ),
            ),
            WeekDayPicker(currentDate, pickedDays),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      showDatePicker(context, startDateNotifier);
                    },
                    child: ValueListenableBuilder(
                      valueListenable: startDateNotifier,
                      builder: (ctx, value, ch) {
//                        var dateString = formatDate(value, [yyyy, '-', mm, '-', dd]);
                        var dateString = formatDate(value, [
                          HH,
                          '-',
                          nn,
                        ]);

                        return Row(
                          children: <Widget>[
                            Text(
                              dateString,
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        );
                      },
                    )),
                FlatButton(
                    onPressed: () {
                      showDatePicker(context, finishDateNotifier);
                    },
                    child: ValueListenableBuilder(
                        valueListenable: finishDateNotifier,
                        builder: (BuildContext context, DateTime value, child) {
//                          var dateString = formatDate(value, [yyyy, '-', mm, '-', dd]);
                          var dateString = formatDate(value, [
                            HH,
                            '-',
                            nn,
                          ]);

                          return Row(
                            children: <Widget>[
                              Text(
                                dateString,
                              ),
                              Icon(Icons.arrow_drop_down)
                            ],
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
                        activeColor: Colors.white,
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
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Cv.customDialogPadding),
      ),
      elevation: 0.0,

//      backgroundColor: Colors.red,
      child: SingleChildScrollView(child: dialogContent(context)),
    );
  }

  Future<DateTime> showDatePicker(
      BuildContext context, ValueNotifier<DateTime> notifier) {
    return DatePicker.showDateTimePicker(context, showTitleActions: true,
        onConfirm: (date) {
      print('confirm $date');
      notifier.value = date;
    },
        minTime:
            DateTime(currentDate.year, currentDate.month, currentDate.day, 0),
        maxTime: DateTime(
            currentDate.year, currentDate.month, currentDate.day, 23, 59),
        currentTime: DateTime(currentDate.year, currentDate.month,
            currentDate.day, DateTime.now().hour, DateTime.now().minute),
        locale: LocaleType.ru);
  }
}
