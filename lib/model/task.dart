import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

//~/development/flutter/bin/flutter packages pub run build_runner build

@HiveType(typeId: 1)
class Task extends Equatable {
  @HiveField(0)
  final String id;

//  final String note;
//  final String task;

  @HiveField(1)
  bool isEveryWeekShow;

  @HiveField(2)
  String subject;

  @HiveField(3)
  String tutor;

  @HiveField(4)
  String place;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  int colorValue;

  String when;

  String note;

  Task copyWith(
      {bool isEveryWeekShow,
      String id,
      String note,
      String when,
      String task,
      String subject,
      String tutor,
      String place,
      DateTime startDate,
      DateTime finishDate,
      int colorValue}) {
    return Task(
      isEveryWeekShow: isEveryWeekShow ?? this.isEveryWeekShow,
      id: id ?? this.id,
      subject: subject ?? this.subject,
      tutor: tutor ?? this.tutor,
      place: place ?? this.place,
      startDate: startDate ?? this.date,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Task({
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
        this.tutor = tutor,
        this.isEveryWeekShow = isEveryWeekShow,
        this.place = place,
        this.date = startDate,
        this.colorValue = colorValue;

  @override
  List<Object> get props =>
      [isEveryWeekShow, id, subject, tutor, place, date, colorValue];

  @override
  String toString() {
    return 'Task{id: $id, isEveryWeekShow: $isEveryWeekShow, subject: $subject, tutor: $tutor, place: $place, startDate: $date, colorValue: $colorValue}';
  }

  Task toEntity() {
    return Task(
        id: id,
        isEveryWeekShow: isEveryWeekShow,
        place: place,
        subject: subject,
        tutor: tutor,
        startDate: date,
        colorValue: colorValue);
  }

  static Task fromEntity(Task entity) {
    return Task(
      startDate: entity.date,
      place: entity.place,
      tutor: entity.tutor,
      isEveryWeekShow: entity.isEveryWeekShow,
      id: entity.id ?? Uuid().v4(),
      colorValue: entity.colorValue,
    );
  }
}
