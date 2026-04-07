import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warungpakwardi/db/local/local_report_repository.dart';
import 'package:warungpakwardi/models/TransactionReport.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final LocalReportRepository localReportRepo = LocalReportRepository();

  ReportBloc() : super(ReportInitial()) {
    on<FetchReportTransaction>((event, emit) async {
      emit(FetchReportTransactionLoading());
      try {
        final start = DateTime(DateTime.now().year, DateTime.now().month, 1);
        final end = DateTime.now();
        final report = await localReportRepo.fetchReportData(startDate: start, endDate: end);
        emit(FetchReportTransactionLoaded(
          transactionReport: report,
          startDate: start,
          endDate: end,
        ));
      } catch (e) {
        emit(
          FetchReportTransactionError(
            message: "Terjadi kesalahan ketika mengambil data laporan ${e.toString()}",
          ),
        );
      }
    });

    on<FetchReportTransactionRange>((event, emit) async {
      emit(FetchReportTransactionLoading());
      try {
        final report = await localReportRepo.fetchReportData(
          startDate: event.startDate,
          endDate: event.endDate,
        );
        emit(FetchReportTransactionLoaded(
          transactionReport: report,
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      } catch (e) {
        emit(
          FetchReportTransactionError(
            message: "Terjadi kesalahan ketika mengambil data laporan ${e.toString()}",
          ),
        );
      }
    });
  }
}
