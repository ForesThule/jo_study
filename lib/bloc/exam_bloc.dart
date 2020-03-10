import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:jo_study/bloc/states.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/model/exam.dart';
import 'package:jo_study/model/task.dart';
import 'package:jo_study/utils/date_utils.dart';

import '../repositoty.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final AppRepository repo;

  final controller = StreamController<Map<DateTime, List<Classwork>>>();

//  Stream<Map<DateTime, List<Classwork>>> getClassworksForPeriod(
//      List<DateTime> period) async* {
//    yield* repo.getClassworksForPeriod(period);
//  }

  Stream<Map<DateTime, List<Task>>> getTasksForCurrentMonth() async* {
    var now = DateTime.now();
    var firstDayOfWeek = Utils.firstDayOfMonth(now);
    var lastday = Utils.lastDayOfMonth(now);
    List<DateTime> thisMonth =
        Utils.daysInRange(firstDayOfWeek, lastday).toList();

    yield* repo.getTasksForPeriod(thisMonth);
  }

  ExamBloc(this.repo);

  @override
  ExamState get initialState => InitExamViewState();

  @override
  Stream<ExamState> mapEventToState(ExamEvent event) async* {
    if (event is AddExamEvent) {
      debugPrint("ADD EXAM EVENT: $event");
      await saveExam(event.exam);
      yield ExamSavedState();
    }
  }

//  Future saveClasswork(Classwork classwork) {
//    return repo.saveClasswork(classwork);
//  }

  Future saveExam(Exam exam)async {
    return repo.saveExam(exam);
  }

  getCurrentDateClasswork() {}

  getTasksForPeriod() {}

  Stream<Map<DateTime, List<Exam>>>getExamsForCurrentMonth()async* {
    var now = DateTime.now();
    var firstDayOfWeek = Utils.firstDayOfMonth(now);
    var lastday = Utils.lastDayOfMonth(now);
    List<DateTime> thisMonth =
    Utils.daysInRange(firstDayOfWeek, lastday).toList();

    yield* repo.getExamsForPeriod(thisMonth);
  }
}

///////////////////////////////////////////////////////////////
abstract class ExamState extends Equatable {
  const ExamState();

  @override
  List<Object> get props => [];
}

class InitExamViewState extends ExamState {}

class ExamSavedState extends ExamState {}

///////////////////////////////////////////////////////////////////
abstract class ExamEvent extends Equatable {
  const ExamEvent();

  @override
  List<Object> get props => [];
}

class AddExamEvent extends ExamEvent {
  Exam exam;
  AddExamEvent(this.exam);
}
