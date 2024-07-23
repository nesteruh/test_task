import 'package:equatable/equatable.dart';
import '/data/models/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class TaskError extends TaskState {
  final String error;

  const TaskError({required this.error});

  @override
  List<Object> get props => [error];
}
