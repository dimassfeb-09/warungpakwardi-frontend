part of 'transaction_detail_bloc.dart';

sealed class TransactionDetailEvent extends Equatable {
  const TransactionDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactionDetailEvent extends TransactionDetailEvent {
  final String transactionId;

  const LoadTransactionDetailEvent({required this.transactionId});
}
