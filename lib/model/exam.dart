import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'exam.g.dart';

//~/development/flutter/bin/flutter packages pub run build_runner build

@HiveType(typeId: 3)
class Exam extends Equatable {
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

  Exam copyWith(
      {String id, String note, String subject, DateTime date, int colorValue}) {
    return Exam(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      date: date ?? this.date,
      note: note ?? this.date,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Exam({
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
    return 'Exam{id: $id, subject: $subject, date: $date, colorValue: $colorValue, note: $note}';
  }

  Exam toEntity() {
    return Exam(
        id: id,
        subject: subject,
        note: note,
        date: date,
        colorValue: colorValue);
  }

  static Exam fromEntity(Exam entity) {
    return Exam(
      date: entity.date,
      note: entity.note,
      subject: entity.subject,
      id: entity.id ?? Uuid().v4(),
      colorValue: entity.colorValue,
    );
  }
}
