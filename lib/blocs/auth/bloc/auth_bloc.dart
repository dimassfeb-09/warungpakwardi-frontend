import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:warungpakwardi/models/ResponseErrorAPI.dart';
import 'package:warungpakwardi/models/User.dart';

import '../../../db/remote/auth_repository.dart';
import '../../../utils/secureStorage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<FetchUserDetailEvent>((event, emit) async {
      final token = await secureStorage.read(key: "token");

      // Check if token is missing
      if (token == null) {
        emit(UserUnauthenticated());
        return;
      }

      try {
        final response = await authRepository.me(token);
        if (response.data != null) {
          emit(UserAuthenticated(user: response.data!));
        } else {
          emit(UserUnauthenticated());
        }
      } catch (e) {
        if (e is ResponseErrorAPI) {
          emit(UserAuthenticatedErrorState(message: e.message));
        } else {
          emit(
            UserAuthenticatedErrorState(
              message: "An error occurred: ${e.toString()}",
            ),
          );
        }

        emit(UserUnauthenticated());
      }
    });
  }
}
