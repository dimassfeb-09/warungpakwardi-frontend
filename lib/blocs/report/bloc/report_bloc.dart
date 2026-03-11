import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warungpakwardi/db/remote/report_repository.dart';
import 'package:warungpakwardi/models/ResponseErrorAPI.dart';
import 'package:warungpakwardi/models/TransactionReport.dart';
import 'package:warungpakwardi/utils/secureStorage.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportRepository reportRepository = ReportRepository();

  ReportBloc() : super(ReportInitial()) {
    on<FetchReportTransaction>((event, emit) async {
      emit(FetchReportTransactionLoading());
      try {
        final token = await secureStorage.read(key: "token");
        final response = await reportRepository.fetchReport(token!);
        emit(FetchReportTransactionLoaded(transactionReport: response.data!));
      } catch (e) {
        if (e is ResponseErrorAPI) {
          emit(FetchReportTransactionError(message: e.message));
        } else {
          emit(
            FetchReportTransactionError(
              message:
                  "Terjadi kesalahan ketika mengambil data laporan ${e.toString()}",
            ),
          );
        }
      }
    });
  }
}
