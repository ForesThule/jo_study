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
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/utils/consts.dart';
import 'package:jo_study/widgets/week_day_picker.dart';

import 'color_picker.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  TextEditingController subjController;
  TextEditingController teacherController;
  TextEditingController placeController;
  Classwork classwork;

  DateTime date;

  BuildContext buildcontext;
  MonthBloc bloc;

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
