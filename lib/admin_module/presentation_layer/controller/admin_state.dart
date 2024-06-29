part of 'admin_bloc.dart';

class AdminState extends Equatable {
  final List<ProductModel> allProducts;
  final RequestState allProductsState;
  final String allProductsMessage;

  const AdminState({
    this.allProducts = const [],
    this.allProductsState = RequestState.initial,
    this.allProductsMessage = '',
  });

  AdminState copyWith({
    List<ProductModel>? allProducts,
    RequestState? allProductsState,
    String? allProductsMessage,
  }) {
    return AdminState(
      allProducts: allProducts ?? this.allProducts,
      allProductsState: allProductsState ?? this.allProductsState,
      allProductsMessage: allProductsMessage ?? this.allProductsMessage,
    );
  }

  @override
  List<Object?> get props => [
    allProducts,
    allProductsState,
    allProductsMessage,
  ];
}
