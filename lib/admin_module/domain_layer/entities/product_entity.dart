import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String name, docId;

  final int numberOfPieces ;
  final double price ;
  const ProductEntity(
      {required this.name,
      required this.docId,
      required this.numberOfPieces,
      required this.price});

  @override
  List<Object?> get props => [
    name,
        docId,
    numberOfPieces,
    price,
      ];
}
