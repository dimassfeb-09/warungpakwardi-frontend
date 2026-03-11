part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterSubmitEvent extends RegisterEvent {
  final Register register;

  RegisterSubmitEvent({required this.register});
}
