import 'package:equatable/equatable.dart';

class SoldProductEntity extends Equatable {
  final String name, docId;
  final double price ;
  const SoldProductEntity(
      {required this.name,
        required this.docId,
        required this.price});

  @override
  List<Object?> get props => [
    name,
    docId,
    price,
  ];
}
