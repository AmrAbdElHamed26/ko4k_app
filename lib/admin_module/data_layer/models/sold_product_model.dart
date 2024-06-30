import 'package:ko4k/admin_module/domain_layer/entities/sold_product_entity.dart';
import 'package:ko4k/core/constants/api_constants.dart';


class SoldProductModel extends SoldProductEntity {

  const SoldProductModel({
    required super.name,
    required super.docId,
    required super.price,
  });

  factory SoldProductModel.fromJson(Map<String, dynamic> json) {
    return SoldProductModel(
      name: json[RemoteProductsDataConstants.kName],
      docId: json['docId'],
      price: (json[RemoteProductsDataConstants.kPrice] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      RemoteProductsDataConstants.kName: name,
      RemoteProductsDataConstants.kPrice: price,
      'docId': docId,
    };
  }
}
