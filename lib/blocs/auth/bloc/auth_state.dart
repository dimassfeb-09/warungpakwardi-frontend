part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class UserAuthenticated extends AuthState {
  final User user;

  UserAuthenticated({required this.user});
}

class UserUnauthenticated extends AuthState {
  UserUnauthenticated();
}

class UserAuthenticatedErrorState extends AuthState {
  final String message;

  UserAuthenticatedErrorState({required this.message});
}
