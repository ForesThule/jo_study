import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'classwork.g.dart';

//~/development/flutter/bin/flutter packages pub run build_runner build

@HiveType(typeId: 1)
class Classwork extends Equatable {
  @HiveField(0)
  final String id;

//  final String note;
//  final String task;

  @HiveField(1)
  bool isEveryWeekShow;

  @HiveField(2)
  String subject;

  @HiveField(3)
  String teacher;

  @HiveField(4)
  String place;

  @HiveField(5)
  DateTime startDate;

  @HiveField(6)
  DateTime finishDate;

  @HiveField(7)
  int colorValue;

  Classwork copyWith(
      {bool isEveryWeekShow,
      String id,
      String note,
      String task,
      String subject,
      String tutor,
      String place,
      DateTime startDate,
      DateTime finishDate,
      int colorValue}) {
    return Classwork(
      isEveryWeekShow: isEveryWeekShow ?? this.isEveryWeekShow,
      id: id ?? this.id,
      subject: subject ?? this.subject,
      tutor: tutor ?? this.teacher,
      place: place ?? this.place,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Classwork({
    @required String subject,
    @required String tutor,
    @required String place,
    @required DateTime startDate,
    @required DateTime finishDate,
    bool isEveryWeekShow = false,
    String id,
    int colorValue,
  })  : this.id = id ?? Uuid().v4(),
        this.subject = subject,
        this.teacher = tutor,
        this.isEveryWeekShow = isEveryWeekShow,
        this.place = place,
        this.startDate = startDate,
        this.finishDate = finishDate,
        this.colorValue = colorValue;

  @override
  List<Object> get props => [
        isEveryWeekShow,
        id,
        subject,
        teacher,
        place,
        startDate,
        finishDate,
        colorValue
      ];

  @override
  String toString() {
    return 'Classwork{id: $id, isEveryWeekShow: $isEveryWeekShow, subject: $subject, tutor: $teacher, place: $place, startDate: $startDate, finishDate: $finishDate, colorValue: $colorValue}';
  }

  Classwork toEntity() {
    return Classwork(
        id: id,
        isEveryWeekShow: isEveryWeekShow,
        place: place,
        subject: subject,
        tutor: teacher,
        startDate: startDate,
        finishDate: finishDate,
        colorValue: colorValue);
  }

  static Classwork fromEntity(Classwork entity) {
    return Classwork(
      startDate: entity.startDate,
      finishDate: entity.finishDate,
      place: entity.place,
      tutor: entity.teacher,
      isEveryWeekShow: entity.isEveryWeekShow,
      id: entity.id ?? Uuid().v4(),
      colorValue: entity.colorValue,
    );
  }
}
