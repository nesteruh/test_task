import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class FetchTasks extends TaskEvent {}

class RefreshTasks extends TaskEvent {}
