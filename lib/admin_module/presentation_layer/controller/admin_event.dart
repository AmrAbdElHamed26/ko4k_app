part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();
}

class GetAllProductsEvent extends AdminEvent{

  @override
  List<Object?> get props => [];

}

class AddNewProductEvent extends AdminEvent {
  const AddNewProductEvent({required this.newProduct});
  final ProductModel newProduct ;

  @override
   List<Object?> get props => [newProduct];
}

class DeleteProductEvent extends AdminEvent {
  const DeleteProductEvent({required this.productId});

  final String productId ;
  @override
  List<Object?> get props => [productId];
}