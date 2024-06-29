import 'package:ko4k/core/constants/api_constants.dart';

import '../../domain_layer/entities/product_entity.dart';

class ProductModel extends ProductEntity {

  const ProductModel({
    required super.name,
    required super.docId,
    required super.numberOfPieces,
    required super.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json[RemoteProductsDataConstants.kName],
      docId: json['docId'],
      numberOfPieces: json[RemoteProductsDataConstants.kNumberOfPieces],
      price: (json[RemoteProductsDataConstants.kPrice] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      RemoteProductsDataConstants.kName: name,
      RemoteProductsDataConstants.kPrice: price,
      RemoteProductsDataConstants.kNumberOfPieces: numberOfPieces,
      'docId': docId,
    };
  }
}
