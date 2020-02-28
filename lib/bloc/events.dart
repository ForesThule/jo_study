import 'package:equatable/equatable.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/tab_selector.dart';

/////////////////////////////////////////////////////////////
abstract class AppEvent extends Equatable {
  const AppEvent();
  @override
  List<Object> get props => [];
}

class ShowTabScreen extends AppEvent {
  AppTab tab;
  ShowTabScreen(this.tab);
}

class LoadExcercise extends AppEvent {}

class UpdateExcersise extends AppEvent {
  Classwork updatedExcercise;
}

class DeleteExcercise extends AppEvent {
  Classwork excercise;
}
