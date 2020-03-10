import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:jo_study/bloc/states.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/utils/date_utils.dart';

import '../repositoty.dart';

class WeekBloc extends Bloc<WeekEvent, WeekState> {
  final AppRepository repo;

//  final controller = StreamController<List<Classwork>>();
  final controller = StreamController<Map<DateTime, List<Classwork>>>();

//  void getClassworksForDate(DateTime day) async {
//    final results = await repo.getClassworksForDay(day);
//    controller.sink.add(results);
//  }
//
//  void getClassworksForPeriod(List<DateTime> period) async {
//    final results = await repo.getClassworksForPeriod(period);
//    controller.sink.add(results);
//  }

  Stream<Map<DateTime, List<Classwork>>> getClassworksForCurrentWeek() async* {
    var now = DateTime.now();

    var firstDayOfWeek = Utils.firstDayOfWeek(now);
    var lastday = Utils.lastDayOfWeek(now);
    List<DateTime> thisWeek =
        Utils.daysInRange(firstDayOfWeek, lastday).toList();

    yield* repo.getClassworksForPeriod(thisWeek);
  }

  WeekBloc(this.repo);

  @override
  WeekState get initialState => InitDayViewState();

  @override
  Stream<WeekState> mapEventToState(WeekEvent event) async* {
//    if (event is ShowClassworkForDay) {
//      debugPrint("GO TO _mapSelectedTabScreen");
//      yield* classworkForDay(event);
//    } else if (event is AddClassworkEvent) {
//      debugPrint("GO TO mapClassworkForDayToState");
//      yield* addClasswork(event);
//    }
  }

//  Stream<WeekState> classworkForDay(ShowClassworkForDay event) async* {
//    var list = await repo.selectClassworkForDay(event.day);
//    yield InitMonthViewState(list);
//  }

//
//  Stream<AppState> _selectClassworkForDay(SelectClassworkForDay event) async* {
//    var list = await repo.selectClassworkForDay(event.day);
//
//    yield ClassworksForDay();
//  }

//  Stream<WeekState> addClasswork(AddClassworkEvent event) async* {
//    await saveClasswork(event.classwork);
//    yield ClassworkSaved(event.classwork);
//  }

//  Future saveClasswork(Classwork classwork) {
//    return repo.saveClasswork(classwork);
//  }

  getCurrentDateClasswork() {}
}

///////////////////////////////////////////////////////////////
abstract class WeekState extends Equatable {
  const WeekState();

  @override
  List<Object> get props => [];
}

class ClassworksForDay extends WeekState {
  final List<Classwork> classworks;

  const ClassworksForDay([this.classworks]);

  @override
  List<Object> get props => [classworks];

  @override
  String toString() {
    return 'ClassworksForDay{classworks: $classworks}';
  }
}

class InitDayViewState extends WeekState {
  final List<Classwork> classworks;

  const InitDayViewState([this.classworks]);

  @override
  List<Object> get props => [classworks];

  @override
  String toString() => 'CurrentDateState{ classworks: $classworks}';
}

class ClassworkSaved extends WeekState {
  final Classwork classwork;

  const ClassworkSaved([this.classwork]);

  @override
  List<Object> get props => [classwork];

  @override
  String toString() => 'ClassworkSaved { classwork: $classwork}';
}

///////////////////////////////////////////////////////////////////
abstract class WeekEvent extends Equatable {
  const WeekEvent();

  @override
  List<Object> get props => [];
}

class ShowClassworkForDay extends WeekEvent {
  final DateTime day;

  const ShowClassworkForDay(this.day);

  @override
  List<Object> get props => [day];

  @override
  String toString() {
    return 'ShowClassworkForDay{day: $day}';
  }
}

//class SelectClassworkForDay extends AppEvent {
//  final DateTime day;
//  const SelectClassworkForDay(this.day);
//  @override
//  List<Object> get props => [day];
//
//  @override
//  String toString() {
//    return 'SelectClassworkForDay{day: $day}';
//  }
//}

class AddClassworkEvent extends WeekEvent {
  final Classwork classwork;

  const AddClassworkEvent(this.classwork);

  @override
  List<Object> get props => [classwork];

  @override
  String toString() => 'AddClassworkEvent { classwork: $classwork }';
}
