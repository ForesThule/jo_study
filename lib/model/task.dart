import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

//~/development/flutter/bin/flutter packages pub run build_runner build

@HiveType(typeId: 2)
class Task extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String subject;

  @HiveField(2)
  DateTime date;
  @HiveField(3)
  int colorValue;
  @HiveField(4)
  String note;

  Task copyWith(
      {String id, String note, String subject, DateTime date, int colorValue}) {
    return Task(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      date: date ?? this.date,
      note: note ?? this.date,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Task({
    @required String subject,
    @required String place,
    @required DateTime date,
    @required String note,
    String id,
    int colorValue,
  })  : this.id = id ?? Uuid().v4(),
        this.subject = subject,
        this.note = note,
        this.date = date,
        this.colorValue = colorValue;

  @override
  List<Object> get props => [
        id,
        subject,
        note,
        date,
        colorValue,
      ];

  @override
  String toString() {
    return 'Task{id: $id, subject: $subject, date: $date, colorValue: $colorValue, note: $note}';
  }

  Task toEntity() {
    return Task(
        id: id,
        subject: subject,
        note: note,
        date: date,
        colorValue: colorValue);
  }

  static Task fromEntity(Task entity) {
    return Task(
      date: entity.date,
      note: entity.note,
      subject: entity.subject,
      id: entity.id ?? Uuid().v4(),
      colorValue: entity.colorValue,
    );
  }
}
