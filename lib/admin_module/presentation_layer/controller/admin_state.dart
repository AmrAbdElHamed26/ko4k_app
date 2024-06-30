part of 'admin_bloc.dart';

class AdminState extends Equatable {
  final List<ProductModel> allProducts;
  final RequestState allProductsState;
  final String allProductsMessage;

  final RequestState currentTimeState;

  final List<SoldProductModel> allSoldProducts;
  final RequestState allSoldProductsState;
  final String allSoldProductsMessage;

  final Map<String, int> soldItemCount;
  final Map<String, double> soldItemTotalPrice;
  final List<String> allDifferentSoldItems;

  final double  totalSoldItemsPrice ;
  const AdminState({
    this.totalSoldItemsPrice = 0 ,
    this.allDifferentSoldItems = const [],
    this.allProducts = const [],
    this.allProductsState = RequestState.initial,
    this.allProductsMessage = '',
    this.currentTimeState = RequestState.initial,
    this.allSoldProducts = const [],
    this.allSoldProductsState = RequestState.initial,
    this.allSoldProductsMessage = '',
    this.soldItemCount = const {},
    this.soldItemTotalPrice = const {},
  });

  AdminState copyWith({
    double ? totalSoldItemsPrice ,
    List<String>? allDifferentSoldItems ,
    List<ProductModel>? allProducts,
    RequestState? allProductsState,
    String? allProductsMessage,
    RequestState? currentTimeState,
    List<SoldProductModel>? allSoldProducts,
    RequestState? allSoldProductsState,
    String? allSoldProductsMessage,
    Map<String, int>? soldItemCount,
    Map<String, double>? soldItemTotalPrice,
  }) {
    return AdminState(
      totalSoldItemsPrice : totalSoldItemsPrice ?? this.totalSoldItemsPrice ,
      allDifferentSoldItems : allDifferentSoldItems ?? this.allDifferentSoldItems ,
      allProducts: allProducts ?? this.allProducts,
      allProductsState: allProductsState ?? this.allProductsState,
      allProductsMessage: allProductsMessage ?? this.allProductsMessage,
      currentTimeState: currentTimeState ?? this.currentTimeState,
      allSoldProducts: allSoldProducts ?? this.allSoldProducts,
      allSoldProductsState: allSoldProductsState ?? this.allSoldProductsState,
      allSoldProductsMessage: allSoldProductsMessage ?? this.allSoldProductsMessage,
      soldItemCount: soldItemCount ?? this.soldItemCount,
      soldItemTotalPrice: soldItemTotalPrice ?? this.soldItemTotalPrice,
    );
  }

  @override
  List<Object?> get props => [
    totalSoldItemsPrice,
    allDifferentSoldItems,
    allProducts,
    allProductsState,
    allProductsMessage,
    currentTimeState,
    allSoldProducts,
    allSoldProductsState,
    allSoldProductsMessage,
    soldItemCount,
    soldItemTotalPrice,
  ];
}
