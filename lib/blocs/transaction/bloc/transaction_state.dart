part of 'transaction_bloc.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

final class TransactionInitial extends TransactionState {}

class FetchTransactionLoadingState extends TransactionState {}

class FetchTransactionLoadedState extends TransactionState {
  final List<Transaction> transactions;

  const FetchTransactionLoadedState({required this.transactions});
}

class FetchTransactionErrorState extends TransactionState {
  final String message;

  const FetchTransactionErrorState({required this.message});
}
