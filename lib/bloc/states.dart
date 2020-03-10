import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/tab_selector.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class WeekHomeScreenState extends AppState {}

class MonthHomeScreenState extends AppState {}

class DayHomeScreenState extends AppState {}

class ExamHomeScreenState extends AppState {}

class TaskHomeScreenState extends AppState {}




class AddExcercise extends AppState {}

class ExcerciseLoaded extends AppState {
  final List<Classwork> excercises;

  const ExcerciseLoaded([this.excercises = const []]);

  @override
  List<Object> get props => [excercises];

  @override
  String toString() => 'ExcerciseLoaded { excercise: $excercises }';
}

class ExcerciseNotLoaded extends AppState {}
