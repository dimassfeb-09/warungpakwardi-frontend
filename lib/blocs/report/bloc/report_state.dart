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

  FetchReportTransactionLoaded({required this.transactionReport});
}

class FetchReportTransactionError extends ReportState {
  final String message;

  FetchReportTransactionError({required this.message});
}
