import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/tab_selector.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class Week extends AppState {}

class Month extends AppState {}

class Day extends AppState {}

class ExamState extends AppState {}

class TaskScreenState extends AppState {}

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
