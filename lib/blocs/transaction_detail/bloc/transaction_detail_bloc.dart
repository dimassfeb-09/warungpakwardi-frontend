import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warungpakwardi/db/local/local_transaction_repository.dart';
import 'package:warungpakwardi/models/TransactionDetail.dart';

part 'transaction_detail_event.dart';
part 'transaction_detail_state.dart';

class TransactionDetailBloc
    extends Bloc<TransactionDetailEvent, TransactionDetailState> {
  final LocalTransactionRepository localTransactionRepo = LocalTransactionRepository();

  TransactionDetailBloc() : super(TransactionDetailInitial()) {
    on<LoadTransactionDetailEvent>((event, emit) async {
      emit(TransactionDetailLoadingState());
      try {
        final detail = await localTransactionRepo.fetchTransactionById(
          event.transactionId,
        );
        if (detail != null) {
          emit(TransactionDetailLoadedState(transactionDetail: detail));
        } else {
          emit(const TransactionDetailErrorState(message: 'Data tidak ditemukan'));
        }
      } catch (e) {
        emit(TransactionDetailErrorState(message: e.toString()));
      }
    });
  }
}
