import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warungpakwardi/models/Transaction.dart';

import '../../../db/remote/transaction_repository.dart';
import '../../../models/ResponseErrorAPI.dart';
import '../../../utils/secureStorage.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionRepository transactionRepository = TransactionRepository();

  TransactionBloc() : super(TransactionInitial()) {
    on<FetchTransactionEvent>((event, emit) async {
      try {
        final token = await secureStorage.read(key: "token");
        emit(FetchTransactionLoadingState());
        final response = await transactionRepository.fetchTransaction(
          token ?? '',
        );
        emit(FetchTransactionLoadedState(transactions: response.data!));
      } catch (e) {
        print(e);
        if (e is ResponseErrorAPI) {
          emit(FetchTransactionErrorState(message: e.message));
        } else {
          emit(FetchTransactionErrorState(message: e.toString()));
        }
      }
    });
  }
}
