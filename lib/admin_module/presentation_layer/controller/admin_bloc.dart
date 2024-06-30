import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ko4k/core/utils/enums.dart';

import '../../data_layer/models/product_model.dart';
import '../../domain_layer/use_cases/add_new_product_use_case.dart';
import '../../domain_layer/use_cases/delete_product_use_case.dart';
import '../../domain_layer/use_cases/get_all_products_use_case.dart';

part 'admin_event.dart';

part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  GetAllProductsUseCase getAllProductsUseCase;
  AddNewProductUseCase addNewProductUseCase;
  DeleteProductUseCase deleteProductUseCase ;



  AdminBloc(this.getAllProductsUseCase , this.addNewProductUseCase , this.deleteProductUseCase) : super(const AdminState()) {
    on<GetAllProductsEvent>(_getAllProductsEvent);
    on<AddNewProductEvent>(_addNewProduct);
    on<DeleteProductEvent>(_deleteProductEvent);


  }

  FutureOr<void> _getAllProductsEvent(event, emit) async {
    emit(state.copyWith(allProductsState: RequestState.loading));

    final result = await getAllProductsUseCase.execute();

    result.fold((failure) {
      emit(state.copyWith(
        allProductsState: RequestState.error,
        allProductsMessage: failure.toString(),
      ));
    }, (products) {
      emit(state.copyWith(
        allProducts: products,
        allProductsState: RequestState.loaded,
      ));
    });
  }
  FutureOr<void> _addNewProduct(AddNewProductEvent event, emit) async {

    emit(state.copyWith(allProductsState: RequestState.loading));
    final result = await addNewProductUseCase.execute(event.newProduct);

    result.fold((failure) {
      emit(state.copyWith(
        allProductsState: RequestState.error,
        allProductsMessage: failure.toString(),
      ));
    }, (r) {

      List<ProductModel> allProducts = [...state.allProducts] ;
      allProducts.add(event.newProduct);

      emit(state.copyWith(
        allProducts: allProducts,
        allProductsState: RequestState.loaded,
      ));
    });

  }

  FutureOr<void> _deleteProductEvent(DeleteProductEvent event, emit) async {

    emit(state.copyWith(allProductsState: RequestState.loading));
    final result = await deleteProductUseCase.execute(event.productId);

    result.fold((failure) {
      emit(state.copyWith(
        allProductsState: RequestState.error,
        allProductsMessage: failure.toString(),
      ));
    }, (r) {

      List<ProductModel> allProducts = [...state.allProducts] ;
      int indexToRemove = allProducts.indexWhere((product) => product.docId == event.productId);
      allProducts.removeAt(indexToRemove);

      emit(state.copyWith(
        allProducts: allProducts,
        allProductsState: RequestState.loaded,
      ));
    });

  }

}
