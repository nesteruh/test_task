import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_task/screens/auth_check.dart';
import 'blocs/login/login_bloc.dart';
import 'data/api_service.dart';
import 'blocs/task/task_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(apiService: ApiService()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(apiService: ApiService()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: AuthCheck(),
        ),
      ),
    );
  }
}