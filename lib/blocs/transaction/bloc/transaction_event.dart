part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class FetchTransactionEvent extends TransactionEvent {}

class FetchTransactionByDateEvent extends TransactionEvent {
  final DateTime start;
  final DateTime end;

  const FetchTransactionByDateEvent({required this.start, required this.end});

  @override
  List<Object> get props => [start, end];
}

class DeleteTransactionEvent extends TransactionEvent {
  final String transactionId;

  const DeleteTransactionEvent({required this.transactionId});

  @override
  List<Object> get props => [transactionId];
}
