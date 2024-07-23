import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_state.dart';
import 'task_details.dart';

SvgPicture getStatusIcon(String status) {
  switch (status) {
    case 'Выполнено':
      return SvgPicture.asset('assets/done_icon.svg', width: 25.w);
    case 'Запланировано':
      return SvgPicture.asset('assets/preparing_icon.svg', width: 25.w);
    case 'В процессе':
      return SvgPicture.asset('assets/in_progress_icon.svg', width: 25.w);
    case 'Отменено, просрочено':
      return SvgPicture.asset('assets/cancel_icon.svg', width: 25.w);
    default:
      return SvgPicture.asset('assets/cancel_icon.svg', width: 25.w);
  }
}

class TaskList extends StatefulWidget {
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Set<int> selectedContainerIndices = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedContainerIndices.contains(index)) {
                          selectedContainerIndices.remove(index);
                        } else {
                          selectedContainerIndices.add(index);
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      color: selectedContainerIndices.contains(index)
                          ? Color(0xFFECF1F7)
                          : Colors.white,
                      child: Row(
                        children: [
                          SizedBox(width: 10.w),
                          getStatusIcon(task.status),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.name,
                                      style: TextStyle(
                                          fontSize: 16.w,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2.h),
                                    Row(
                                      children: [
                                        SvgPicture.asset('assets/time_icon.svg',
                                            width: 12.w),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '${task.period}',
                                          style: TextStyle(
                                              fontSize: 10.w,
                                              color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Пшеница, ${task.fieldName} (${task.area} га)',
                                      style: TextStyle(
                                          fontSize: 12.w,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFE6EEF3), width: 2.0.w),
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  child: Text(
                                    '${task.progress} га',
                                    style: TextStyle(fontSize: 14.w),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    ),
                  ),
                  if (selectedContainerIndices.contains(index))
                    TaskDetails(
                      task: task,
                    ),
                ],
              );
            },
          );
        } else if (state is TaskError) {
          return Center(child: Text('Failed to fetch tasks: ${state.error}'));
        } else {
          return Center(child: Text('No tasks available'));
        }
      },
    );
  }
}
