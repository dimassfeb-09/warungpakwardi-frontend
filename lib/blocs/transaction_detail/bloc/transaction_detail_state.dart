part of 'transaction_detail_bloc.dart';

sealed class TransactionDetailState extends Equatable {
  const TransactionDetailState();

  @override
  List<Object> get props => [];
}

final class TransactionDetailInitial extends TransactionDetailState {}

class TransactionDetailLoadingState extends TransactionDetailState {}

class TransactionDetailErrorState extends TransactionDetailState {
  final String message;

  const TransactionDetailErrorState({required this.message});
}

class TransactionDetailLoadedState extends TransactionDetailState {
  final TransactionDetail transactionDetail;

  const TransactionDetailLoadedState({required this.transactionDetail});
}
