import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ko4k/admin_module/data_layer/models/sold_product_model.dart';
import 'package:ko4k/core/constants/local_data_base_constances.dart';
import 'package:ko4k/core/utils/enums.dart';
import 'package:ko4k/main.dart';

import '../../data_layer/models/product_model.dart';
import '../../domain_layer/use_cases/add_new_product_use_case.dart';
import '../../domain_layer/use_cases/delete_product_use_case.dart';
import '../../domain_layer/use_cases/get_all_products_use_case.dart';
import '../../domain_layer/use_cases/get_daily_report_use_case.dart';
import '../../domain_layer/use_cases/get_date_from_firebase_use_case.dart';

part 'admin_event.dart';

part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  GetAllProductsUseCase getAllProductsUseCase;
  AddNewProductUseCase addNewProductUseCase;
  DeleteProductUseCase deleteProductUseCase ;

  GetDateFromFirebaseUseCase getTimeFromFirebaseUseCase ;

  GetDailyReportUseCase getDailyReportUseCase ;

  AdminBloc(this.getDailyReportUseCase ,  this.getAllProductsUseCase , this.addNewProductUseCase , this.deleteProductUseCase , this.getTimeFromFirebaseUseCase
      ) : super(const AdminState()) {
    on<GetAllProductsEvent>(_getAllProductsEvent);
    on<AddNewProductEvent>(_addNewProduct);
    on<DeleteProductEvent>(_deleteProductEvent);
    on<GetTimeFromFirebaseEvent>(_getTimeFromFirebaseEvent);
    on<GetSoldProductsForSpecificDayEvent>(_getSoldProductsForSpecificDay);

  }
  FutureOr<void> _getSoldProductsForSpecificDay(GetSoldProductsForSpecificDayEvent event, emit) async {
    emit(state.copyWith(allSoldProductsState: RequestState.loading));

    final result = await getDailyReportUseCase.execute(event.currentDay);

    result.fold((failure) {
      emit(state.copyWith(
        allSoldProductsState: RequestState.error,
        allSoldProductsMessage: failure.toString(),
      ));
    }, (products) {

      print(products);


      Map<String, int> itemCount = {};
      Map<String, double> itemTotalPrice = {};

      // Iterate through products list
      products.forEach((product) {
        if (itemCount.containsKey(product.name)) {
          itemCount[product.name] = itemCount[product.name]! + 1;
          itemTotalPrice[product.name] = itemTotalPrice[product.name]! + product.price;
        } else {
          itemCount[product.name] = 1;
          itemTotalPrice[product.name] = product.price;
        }
      });

      List<String> allDifferentSoldItems = [ ];
      double totalSoldItems = 0 ;
      // Output counts and total prices
      itemCount.forEach((name, count) {
        double totalAmount = itemTotalPrice[name]!;
        totalSoldItems += totalAmount ;
        print('$name: $count items, Total Amount: $totalAmount');
        allDifferentSoldItems.add(name);
      });


      emit(state.copyWith(
        totalSoldItemsPrice: totalSoldItems ,
        allDifferentSoldItems: allDifferentSoldItems,
        allSoldProducts: products,
        soldItemCount: itemCount,
        soldItemTotalPrice: itemTotalPrice,
        allSoldProductsState: RequestState.loaded,
      ));
    });
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
  FutureOr<void> _getTimeFromFirebaseEvent(GetTimeFromFirebaseEvent event, emit) async {

    emit(state.copyWith(
      currentTimeState: RequestState.loading,

    ));

    final result = await getTimeFromFirebaseUseCase.execute();

    result.fold((failure) {
      emit(state.copyWith(
        currentTimeState: RequestState.error,

      ));
    }, (currentTime) {

      preferences.setString(LocalDataBaseConstants.kCurrentTime, currentTime.toString());
      emit(state.copyWith(
        currentTimeState: RequestState.loaded,

      ));
    });

  }

}
