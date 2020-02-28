import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:jo_study/bloc/states.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/repositoty.dart';
import 'package:jo_study/tab_selector.dart';

import 'events.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppRepository repo;

//  StreamController classworksForDay = StreamController<List<Classwork>>();

  AppBloc({@required this.repo});

  @override
  AppState get initialState => Month();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    debugPrint("MAP EVENT TO STATE: ${event}");
//    if (event is Month) {
//      yield* _mapMonthToState();
//    } else
//
    if (event is ShowTabScreen) {
      debugPrint("GO TO _mapSelectedTabScreen");
      yield* _mapSelectedTabScreen(event);
    } else if (event is LoadExcercise) {
      yield* _mapLoadExcerciseToState();
    }
//    else if (event is AddClassworkEvent) {
//      yield* _mapAddExcerciseToState(event);
//    }

    else if (event is UpdateExcersise) {
      yield* _mapUpdateExcerciseToState(event);
    }

//    else if (event is SelectClassworkForDay) {
//      yield* _selectClassworkForDay(event);
//    }

    else if (event is DeleteExcercise) {
      yield* _mapDeleteExcerciseToState(event);
    }
//    else if (event is ToggleAll) {
//      yield* _mapToggleAllToState();
//    } else if (event is ClearCompleted) {
//      yield* _mapClearCompletedToState();
//    }
  }

  Stream<AppState> _mapLoadExcerciseToState() async* {
    try {
      final excercise = await this.repo.loadExcercise();
      yield ExcerciseLoaded(
        excercise.map(excercise.fromEntity).toList(),
      );
    } catch (_) {
      yield ExcerciseNotLoaded();
    }
  }

  Stream<AppState> _mapUpdateExcerciseToState(UpdateExcersise event) async* {
    if (state is ExcerciseLoaded) {
      final List<Classwork> updatedExcercise =
          (state as ExcerciseLoaded).excercises.map((excercise) {
        return excercise.id == event.updatedExcercise.id
            ? event.updatedExcercise
            : Classwork;
      }).toList();
      yield ExcerciseLoaded(updatedExcercise);
      _saveExcercise(updatedExcercise);
    }
  }

  Stream<AppState> _mapDeleteExcerciseToState(DeleteExcercise event) async* {
    if (state is ExcerciseLoaded) {
      final updatedExcercise = (state as ExcerciseLoaded)
          .excercises
          .where((Excercise) => Excercise.id != event.excercise.id)
          .toList();
      yield ExcerciseLoaded(updatedExcercise);
      _saveExcercise(updatedExcercise);
    }
  }

  Stream<AppState> _mapClearCompletedToState() async* {
    if (state is ExcerciseLoaded) {
      final List<Classwork> updatedExcercise = (state as ExcerciseLoaded)
          .excercises
          .where((exc) => !exc.isEveryWeekShow)
          .toList();
      yield ExcerciseLoaded(updatedExcercise);
      _saveExcercise(updatedExcercise);
    }
  }

  Future _saveExcercise(List<Classwork> Excercise) {
    return repo.saveExcercise(
      Excercise.map((Excercise) => Excercise.toEntity()).toList(),
    );
  }

  _mapMonthToState() {
    return Month();
  }

  Stream<AppState> _mapSelectedTabScreen(ShowTabScreen event) async* {
    debugPrint("TAB SELECTD: ${event.tab}");

    switch (event.tab) {
      case AppTab.month:
        yield Month();
        break;
      case AppTab.day:
        yield Day();
        break;
      case AppTab.week:
        yield Week();
        break;
      case AppTab.task:
        yield Task();
        break;
      case AppTab.exam:
        yield Exam();
        break;
    }
  }
}
