import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_task/blocs/task/task_bloc.dart';
import 'package:test_task/data/api_service.dart';
import 'package:test_task/screens/login_screen.dart';
import 'package:test_task/widgets/task_list.dart';
import 'package:test_task/blocs/task/task_event.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задачи и работы'),
        backgroundColor: Color(0xFFEDF1F2),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red,),
            onPressed: () async {
              await ApiService().logout(); 
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            TaskBloc(apiService: ApiService())..add(FetchTasks()),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<TaskBloc>(context).add(RefreshTasks());
                  return await Future.delayed(Duration(seconds: 1));
                },
                child: TaskList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
