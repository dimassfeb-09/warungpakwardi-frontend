part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class FetchDashboardLoadingState extends HomeState {}

class FetchDashboardLoadedState extends HomeState {
  final Dashboard dashboard;

  FetchDashboardLoadedState({required this.dashboard});
}

class FetchDashboardErrorState extends HomeState {
  final String message;

  FetchDashboardErrorState({required this.message});
}
