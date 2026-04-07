part of 'report_bloc.dart';

sealed class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

final class ReportInitial extends ReportState {}

class FetchReportTransactionLoading extends ReportState {}

class FetchReportTransactionLoaded extends ReportState {
  final TransactionReport transactionReport;
  final DateTime startDate;
  final DateTime endDate;

  FetchReportTransactionLoaded({
    required this.transactionReport,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [transactionReport, startDate, endDate];
}

class FetchReportTransactionError extends ReportState {
  final String message;

  FetchReportTransactionError({required this.message});

  @override
  List<Object> get props => [message];
}
