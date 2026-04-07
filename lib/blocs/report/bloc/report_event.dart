part of 'report_bloc.dart';

sealed class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class FetchReportTransaction extends ReportEvent {}

class FetchReportTransactionRange extends ReportEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FetchReportTransactionRange({required this.startDate, required this.endDate});

  @override
  List<Object> get props => [startDate, endDate];
}
