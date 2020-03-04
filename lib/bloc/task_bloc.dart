import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:jo_study/bloc/states.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/model/task.dart';
import 'package:jo_study/utils/date_utils.dart';

import '../repositoty.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AppRepository repo;

  final controller = StreamController<Map<DateTime, List<Classwork>>>();

//  Stream<Map<DateTime, List<Classwork>>> getClassworksForPeriod(
//      List<DateTime> period) async* {
//    yield* repo.getClassworksForPeriod(period);
//  }

  Stream<Map<DateTime, List<Classwork>>> getTasksForCurrentMonth() async* {
    var now = DateTime.now();
    var firstDayOfWeek = Utils.firstDayOfMonth(now);
    var lastday = Utils.lastDayOfMonth(now);
    List<DateTime> thisMonth =
        Utils.daysInRange(firstDayOfWeek, lastday).toList();

    yield* repo.getClassworksForPeriod(thisMonth);
  }

  TaskBloc(this.repo);

  @override
  TaskState get initialState => InitTaskViewState();

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {}

  Future saveClasswork(Classwork classwork) {
    return repo.saveClasswork(classwork);
  }

  getCurrentDateClasswork() {}
}

///////////////////////////////////////////////////////////////
abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class InitTaskViewState extends TaskState {}

///////////////////////////////////////////////////////////////////
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class AddTaskEvent extends TaskEvent {
  Task task;
  AddTaskEvent(this.task);
}
