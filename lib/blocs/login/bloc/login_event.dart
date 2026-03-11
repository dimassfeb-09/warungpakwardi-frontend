part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginSubmitEvent extends LoginEvent {
  final Login login;

  LoginSubmitEvent({required this.login});
}
