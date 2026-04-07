import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warungpakwardi/db/local/local_transaction_repository.dart';
import 'package:warungpakwardi/models/Transaction.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final LocalTransactionRepository localTransactionRepo =
      LocalTransactionRepository();

  TransactionBloc() : super(TransactionInitial()) {
    on<FetchTransactionEvent>((event, emit) async {
      emit(FetchTransactionLoadingState());
      try {
        final transactions = await localTransactionRepo.fetchAllTransactions();
        emit(FetchTransactionLoadedState(transactions: transactions));
      } catch (e) {
        emit(FetchTransactionErrorState(message: e.toString()));
      }
    });

    on<FetchTransactionByDateEvent>((event, emit) async {
      emit(FetchTransactionLoadingState());
      try {
        final transactions = await localTransactionRepo
            .fetchTransactionsByDateRange(event.start, event.end);
        emit(FetchTransactionLoadedState(transactions: transactions));
      } catch (e) {
        emit(FetchTransactionErrorState(message: e.toString()));
      }
    });

    on<DeleteTransactionEvent>((event, emit) async {
      try {
        await localTransactionRepo.deleteTransaction(event.transactionId);
        // Refresh list
        add(FetchTransactionEvent());
      } catch (e) {
        emit(FetchTransactionErrorState(message: e.toString()));
      }
    });
  }
}
