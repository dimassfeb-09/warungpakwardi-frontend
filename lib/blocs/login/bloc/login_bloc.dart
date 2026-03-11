import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../db/remote/auth_repository.dart';
import '../../../models/Login.dart';
import '../../../models/ResponseAPI.dart';
import '../../../utils/secureStorage.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthRepository authRepository = AuthRepository();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitEvent>(_loginSubmit);
  }

  void _loginSubmit(LoginSubmitEvent event, Emitter emit) async {
    if (event.login.email.isEmpty) {
      emit(LoginErrorState(message: 'Email wajib diisi'));
      return;
    } else if (event.login.password.isEmpty) {
      emit(LoginErrorState(message: 'Password wajib diisi'));
      return;
    }

    try {
      emit(LoginLoadingState());
      ResponseAPI<String> response = await authRepository.login(event.login);

      await secureStorage.write(key: 'token', value: response.data);
      emit(LoginLoadedState());
    } catch (e) {
      print(e);
      emit(LoginErrorState(message: e.toString()));
    }
  }
}
