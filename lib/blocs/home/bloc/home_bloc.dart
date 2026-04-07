import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:warungpakwardi/db/local/local_dashboard_repository.dart';
import 'package:warungpakwardi/helper/app_event_bus.dart';
import 'package:warungpakwardi/models/Dashboard.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocalDashboardRepository localDashboardRepo = LocalDashboardRepository();
  late final StreamSubscription<AppEvent> _eventBusSubscription;

  HomeBloc() : super(HomeInitial()) {
    on<FetchDashboardEvent>(_fetchDashboard);
    on<RefreshDashboardEvent>(_silentRefresh);

    // Subscribe ke AppEventBus — auto-refresh tanpa perlu trigger manual
    _eventBusSubscription = AppEventBus.instance.stream.listen((event) {
      if (!isClosed) {
        add(RefreshDashboardEvent());
      }
    });
  }

  void _fetchDashboard(FetchDashboardEvent event, Emitter emit) async {
    emit(FetchDashboardLoadingState());
    try {
      final dashboard = await localDashboardRepo.fetchDashboardData();
      emit(FetchDashboardLoadedState(dashboard: dashboard));
    } catch (e) {
      emit(FetchDashboardErrorState(message: e.toString()));
    }
  }

  /// Silent refresh: update data tanpa menampilkan loading indicator.
  /// Ideal untuk background refresh agar UI tidak berkedip.
  void _silentRefresh(RefreshDashboardEvent event, Emitter emit) async {
    try {
      final dashboard = await localDashboardRepo.fetchDashboardData();
      emit(FetchDashboardLoadedState(dashboard: dashboard));
    } catch (e) {
      // Silent failure — jangan emit error state agar UI tetap menampilkan data lama
    }
  }

  @override
  Future<void> close() {
    _eventBusSubscription.cancel();
    return super.close();
  }
}
