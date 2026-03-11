import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:warungpakwardi/models/Register.dart';

import '../../db/remote/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthRepository authRepository = AuthRepository();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitEvent>(_registerSubmit);
  }

  void _registerSubmit(RegisterSubmitEvent event, Emitter emit) async {
    if (event.register.name.isEmpty) {
      emit(RegisterErrorState(message: 'Nama wajib diisi'));
      return;
    } else if (event.register.email.isEmpty) {
      emit(RegisterErrorState(message: 'Email wajib diisi'));
      return;
    } else if (event.register.password.isEmpty) {
      emit(RegisterErrorState(message: 'Password wajib diisi'));
      return;
    }

    try {
      emit(RegisterLoadingState());
      await authRepository.register(event.register);
      emit(RegisterLoadedState());
    } catch (e) {
      emit(RegisterErrorState(message: e.toString()));
    }
  }
}
