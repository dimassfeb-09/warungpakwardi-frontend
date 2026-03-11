import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warungpakwardi/models/TransactionDetail.dart';

import '../../../db/remote/transaction_repository.dart';
import '../../../models/ResponseErrorAPI.dart';
import '../../../utils/secureStorage.dart';

part 'transaction_detail_event.dart';
part 'transaction_detail_state.dart';

class TransactionDetailBloc
    extends Bloc<TransactionDetailEvent, TransactionDetailState> {
  TransactionRepository transactionRepository = TransactionRepository();

  TransactionDetailBloc() : super(TransactionDetailInitial()) {
    on<LoadTransactionDetailEvent>((event, emit) async {
      try {
        final token = await secureStorage.read(key: "token");
        emit(TransactionDetailLoadingState());
        final response = await transactionRepository.fetchTransactionById(
          event.transactionId,
          token!,
        );
        emit(TransactionDetailLoadedState(transactionDetail: response.data!));
      } catch (e) {
        if (e is ResponseErrorAPI) {
          emit(TransactionDetailErrorState(message: e.message));
        } else {
          emit(TransactionDetailErrorState(message: e.toString()));
        }
      }
    });
  }
}
