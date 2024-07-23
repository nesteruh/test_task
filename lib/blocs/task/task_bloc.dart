import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '/data/api_service.dart';
import '/data/task_database.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ApiService apiService;

  TaskBloc({required this.apiService}) : super(TaskInitial()) {
    on<FetchTasks>(_onFetchTasks);
    on<RefreshTasks>(_onRefreshTasks);
  }

  Future<void> _onFetchTasks(FetchTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await apiService.fetchTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (error) {
      final tasksFromDB = await TaskDatabase.instance.fetchTasks();
      if (tasksFromDB.isNotEmpty) {
        emit(TaskLoaded(tasks: tasksFromDB));
      } else {
        emit(TaskError(error: error.toString()));
      }
    }
  }

  Future<void> _onRefreshTasks(RefreshTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await apiService.fetchAndUpdateTasks();
      final tasksFromDB = await TaskDatabase.instance.fetchTasks();
      emit(TaskLoaded(tasks: tasksFromDB));
    } catch (error) {
      emit(TaskError(error: error.toString()));
    }
  }
}
