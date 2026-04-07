import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:warungpakwardi/db/local/local_product_repository.dart';
import 'package:warungpakwardi/helper/app_event_bus.dart';
import 'package:warungpakwardi/models/Product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final LocalProductRepository localProductRepo = LocalProductRepository();
  List<Product> _allProducts = [];

  ProductBloc() : super(ProductInitial()) {
    on<FetchProductEvent>(_fetchProduct);
    on<DeleteProductEvent>(_deleteProduct);
    on<SearchProductEvent>(_searchProduct);
  }

  void _fetchProduct(FetchProductEvent event, Emitter emit) async {
    emit(FetchProductLoadingState());

    try {
      final products = await localProductRepo.fetchAllProducts();
      _allProducts = products;
      emit(FetchProductLoadedState(products: _allProducts));
    } catch (e) {
      emit(
        FetchProductErrorState(message: "An error occurred: ${e.toString()}"),
      );
    }
  }

  void _searchProduct(SearchProductEvent event, Emitter emit) {
    if (event.query.isEmpty) {
      emit(FetchProductLoadedState(products: _allProducts));
      return;
    }

    final filtered = _allProducts.where((p) {
      final nameMatches = p.name.toLowerCase().contains(event.query.toLowerCase());
      final unitMatches = p.unit.toLowerCase().contains(event.query.toLowerCase());
      return nameMatches || unitMatches;
    }).toList();

    emit(FetchProductLoadedState(products: filtered));
  }

  void _deleteProduct(DeleteProductEvent event, Emitter emit) async {
    try {
      emit(FetchProductLoadingState());

      // Soft delete local
      await localProductRepo.softDeleteProduct(event.productId);

      // Fire refresh event
      AppEventBus.instance.fire(AppEvent.productDeleted);

      // Update local cache
      _allProducts.removeWhere((product) => product.id == event.productId);
      
      emit(FetchProductLoadedState(products: _allProducts));
    } catch (e) {
      emit(FetchProductErrorState(message: e.toString()));
    }
  }
}
