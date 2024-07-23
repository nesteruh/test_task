import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '/data/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService apiService;

  LoginBloc({required this.apiService}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<CheckTokens>(_onCheckTokens);
  }

  Future<void> _onCheckTokens(CheckTokens event, Emitter<LoginState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    if (accessToken != null && refreshToken != null) {
      try {
        await apiService.refreshToken(refreshToken);
        emit(LoginSuccess(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ));
      } catch (e) {
        emit(LoginFailure(error: 'Failed to refresh token: ${e.toString()}'));
      }
    } else {
      emit(LoginInitial());
    }
  }

  Future<void> _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final data = await apiService.login(event.email, event.password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);
      emit(LoginSuccess(
        accessToken: data['access'],
        refreshToken: data['refresh'],
      ));
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}
