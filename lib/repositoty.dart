import 'package:date_format/date_format.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:jo_study/model/classwork.dart';

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

  Future saveExcercise(List<Classwork> list) {}

  Future saveClasswork(Classwork classwork) async {
    debugPrint("CHECK CLASSWORK FOR SAVE: ${classwork}");

    var classworkbox = await Hive.openBox('classwork');

    var i = await classworkbox.add(classwork);

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
