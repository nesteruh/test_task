import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/blocs/login/login_bloc.dart';
import 'package:test_task/blocs/login/login_state.dart';
import 'package:test_task/screens/login_screen.dart';
import 'package:test_task/screens/task_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkTokens(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return LoginScreen();
        } else {
          return snapshot.data == true ? TaskScreen() : LoginScreen();
        }
      },
    );
  }

  Future<bool> _checkTokens(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    if (accessToken != null && refreshToken != null) {
      try {
        await context.read<LoginBloc>().apiService.refreshToken(refreshToken);
        context.read<LoginBloc>().emit(LoginSuccess(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ));
        return true;
      } catch (e) {
        context.read<LoginBloc>().emit(LoginFailure(error: 'Failed to refresh token: ${e.toString()}'));
        return false;
      }
    }
    return false;
  }
}