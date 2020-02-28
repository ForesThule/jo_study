import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:jo_study/bloc/states.dart';
import 'package:jo_study/model/classwork.dart';

import '../repositoty.dart';

class MonthBloc extends Bloc<MonthEvent, MonthState> {
  final AppRepository repo;

  final controller = StreamController<List<Classwork>>();

  void getClassworksForDate(DateTime day) async {
    final results = await repo.getClassworksForDay(day);
    controller.sink.add(results);
  }

  MonthBloc(this.repo);

  @override
  MonthState get initialState => InitMonthViewState();

  @override
  Stream<MonthState> mapEventToState(MonthEvent event) async* {
    if (event is ShowClassworkForDay) {
      debugPrint("GO TO _mapSelectedTabScreen");
      yield* classworkForDay(event);
    } else if (event is AddClassworkEvent) {
      debugPrint("GO TO mapClassworkForDayToState");
      yield* addClasswork(event);
    }
  }

  Stream<MonthState> classworkForDay(ShowClassworkForDay event) async* {
    var list = await repo.selectClassworkForDay(event.day);
    yield InitMonthViewState(list);
  }

//
//  Stream<AppState> _selectClassworkForDay(SelectClassworkForDay event) async* {
//    var list = await repo.selectClassworkForDay(event.day);
//
//    yield ClassworksForDay();
//  }

  Stream<MonthState> addClasswork(AddClassworkEvent event) async* {
    await saveClasswork(event.classwork);
    yield ClassworkSaved(event.classwork);
  }

  Future saveClasswork(Classwork classwork) {
    return repo.saveClasswork(classwork);
  }

  getCurrentDateClasswork() {}
}

///////////////////////////////////////////////////////////////
abstract class MonthState extends Equatable {
  const MonthState();

  @override
  List<Object> get props => [];
}

class ClassworksForDay extends MonthState {
  final List<Classwork> classworks;

  const ClassworksForDay([this.classworks]);

  @override
  List<Object> get props => [classworks];

  @override
  String toString() {
    return 'ClassworksForDay{classworks: $classworks}';
  }
}

class InitMonthViewState extends MonthState {
  final List<Classwork> classworks;

  const InitMonthViewState([this.classworks]);

  @override
  List<Object> get props => [classworks];

  @override
  String toString() => 'CurrentDateState{ classworks: $classworks}';
}

class ClassworkSaved extends MonthState {
  final Classwork classwork;

  const ClassworkSaved([this.classwork]);

  @override
  List<Object> get props => [classwork];

  @override
  String toString() => 'ClassworkSaved { classwork: $classwork}';
}

///////////////////////////////////////////////////////////////////
abstract class MonthEvent extends Equatable {
  const MonthEvent();

  @override
  List<Object> get props => [];
}

class ShowClassworkForDay extends MonthEvent {
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

class AddClassworkEvent extends MonthEvent {
  final Classwork classwork;

  const AddClassworkEvent(this.classwork);

  @override
  List<Object> get props => [classwork];

  @override
  String toString() => 'AddClassworkEvent { classwork: $classwork }';
}
