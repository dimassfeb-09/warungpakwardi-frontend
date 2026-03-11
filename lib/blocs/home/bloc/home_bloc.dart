import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:warungpakwardi/models/Dashboard.dart';
import 'package:warungpakwardi/models/ResponseErrorAPI.dart';
import 'package:warungpakwardi/utils/secureStorage.dart';

import '../../../db/remote/dashboard_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  DashboardRepository dashboardRepository = DashboardRepository();

  HomeBloc() : super(HomeInitial()) {
    on<FetchDashboardEvent>(_fetchDashboard);
  }

  void _fetchDashboard(FetchDashboardEvent event, Emitter emit) async {
    try {
      final token = await secureStorage.read(key: "token");
      emit(FetchDashboardLoadingState());
      final response = await dashboardRepository.fetchSummariesDataUser(
        token ?? '',
      );
      emit(FetchDashboardLoadedState(dashboard: response.data!));
    } catch (e) {
      if (e is ResponseErrorAPI) {
        emit(FetchDashboardErrorState(message: e.message));
      } else {
        emit(FetchDashboardErrorState(message: e.toString()));
      }
    }
  }
}
