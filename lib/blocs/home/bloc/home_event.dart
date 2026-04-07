part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class FetchDashboardEvent extends HomeEvent {}

/// Dipanggil dari AppEventBus subscriber, tanpa loading state intermediate.
class RefreshDashboardEvent extends HomeEvent {}
