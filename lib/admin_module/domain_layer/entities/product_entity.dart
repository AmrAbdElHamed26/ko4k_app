import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String name, docId;

  final int numberOfPieces;

  final double price, sellingPrice;

  const ProductEntity(
      {required this.name,
      required this.docId,
      required this.numberOfPieces,
      required this.price,
      required this.sellingPrice});

  @override
  List<Object?> get props => [
        name,
        docId,
        numberOfPieces,
        price,
        sellingPrice,
      ];
}
