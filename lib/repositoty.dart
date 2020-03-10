import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/model/exam.dart';
import 'package:jo_study/utils/date_utils.dart';

import 'model/task.dart';

class AppRepository {
  Future<List<Classwork>> getClassworksForDay(DateTime day) async {
    debugPrint("CHECK DateTime: ${day}");

    var classworkbox = await Hive.openBox('classwork');
    var keys = classworkbox.keys;

    List<Classwork> result = [...classworkbox.values];

    var where = result.where((classwork) => null != classwork.startDate
        ? Utils.isSameDay(classwork.startDate, day)
        : false);

    debugPrint("SAME DAY: $where");

    return where.toList();
  }

  Stream<Map<DateTime, List<Classwork>>> getClassworksForPeriod(
      List<DateTime> daysInRange) async* {
    debugPrint("PERIOD: ${daysInRange}");

    var classworkbox = await Hive.openBox('classwork');

    List<Classwork> allClassworks = [...classworkbox.values];

    Map<DateTime, List<Classwork>> mapResult = {};

    for (var day in daysInRange) {
      List<Classwork> classworks = allClassworks
          .where((classwork) => null != classwork.startDate
              ? Utils.isSameDay(classwork.startDate, day)
              : false)
          .toList();

      mapResult[day] = classworks;
    }

    debugPrint("CLASSWORK FOR PERIOD: ${mapResult}");

    yield mapResult;
  }

  Stream<Map<DateTime, List<Task>>> getTasksForPeriod(
      List<DateTime> daysInRange) async* {
    debugPrint("PERIOD: ${daysInRange}");

    var taskbox = await Hive.openBox('task');

    List<Task> allTasks = [...taskbox.values];

    Map<DateTime, List<Task>> mapResult = {};

    for (var day in daysInRange) {
      List<Task> tasks = allTasks
          .where((task) =>
              null != task.date ? Utils.isSameDay(task.date, day) : false)
          .toList();

      mapResult[day] = tasks;
    }

    yield mapResult;
  }

  Future saveExam(Exam exam) async {
    debugPrint("REPOSITORY SAVE EXAM: $exam");
    var box = await Hive.openBox('exam');
    box.add(exam);
    debugPrint("CHECK SAVED EXAM ${box.containsKey(exam)}");
  }

  Stream<Map<DateTime, List<Exam>>> getExamsForPeriod(
      List<DateTime> thisMonth) async* {
    debugPrint("PERIOD: ${thisMonth}");
    var box = await Hive.openBox('exam');
    List<Exam> allTasks = [...box.values];
    Map<DateTime, List<Exam>> mapResult = {};
    for (var day in thisMonth) {
      List<Exam> tasks = allTasks
          .where((task) =>
              null != task.date ? Utils.isSameDay(task.date, day) : false)
          .toList();
      mapResult[day] = tasks;
    }

    yield mapResult;
  }

  Stream<List<Classwork>> classworksForDay(DateTime day) async* {
    debugPrint("CHECK DateTime: ${day}");

    var classworkbox = await Hive.openBox('classwork');
    var keys = classworkbox.keys;

    List<Classwork> result = [...classworkbox.values];

//    for (var o in classworkbox.values) {
//      result.add(o);
//    }

    debugPrint("KEYS: $keys");
    debugPrint("BOX: $classworkbox");
    debugPrint("BOX NAME: ${classworkbox.name}");

    debugPrint("RESULT: $result");

    var where = result.where((classwork) => null != classwork.startDate
        ? Utils.isSameDay(classwork.startDate, day)
        : false);

    debugPrint("SAME DAY: $where");

    yield where.toList();
  }

  Future saveTask(Task task) async {
    debugPrint("SAVE TASK: $task");

    var taskbox = await Hive.openBox('task');

    taskbox.add(task);
  }

  Future saveClasswork(Classwork classwork, Set<int> pickedDays) async {
    debugPrint("CHECK CLASSWORK FOR SAVE: ${classwork}");

    var classworkbox = await Hive.openBox('classwork');

    if (classwork.isEveryWeekShow) {

      Utils.daysInRange(Utils.firstDayOfMonth(classwork.startDate), Utils.lastDayOfMonth(classwork.startDate))
//      Utils.daysInMonth(classwork.startDate)
          .where((element) => element.weekday==classwork.startDate.weekday)
          .forEach((day) {
        var classworkCopy = classwork.copyWith(
          startDate: DateTime(
            classwork.startDate.year,
            day.month,
            day.day,
            classwork.startDate.hour,
            classwork.startDate.minute,
          ),
          finishDate: DateTime(
            classwork.finishDate.year,
            day.month,
            day.day,
            classwork.finishDate.hour,
            classwork.finishDate.minute,
          ),
        );

        classworkbox.add(classworkCopy);
      });
    }else{
  classworkbox.add(classwork);
    }

    debugPrint("CHECK SAVED CLASSWORK ${classworkbox.containsKey(classwork)}");
  }

  loadExcercise() {}

  Future<List<Classwork>> selectClassworkForDay(DateTime day) async {
    debugPrint("CHECK DateTime: ${day}");

    var classworkbox = await Hive.openBox('classwork');
    var keys = classworkbox.keys;

    debugPrint("KEYS: $keys");

//    var i = await classworkbox.add(classwork);
//
//    debugPrint("CHECK SAVED CLASSWORK ${classworkbox.containsKey(classwork)}");
  }
}
