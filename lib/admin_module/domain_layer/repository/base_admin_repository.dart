
import 'package:dartz/dartz.dart';
import 'package:ko4k/admin_module/data_layer/models/product_model.dart';

import '../../../core/error/failure.dart';

abstract class BaseAdminRepository {

  Future<Either<Failure, List<ProductModel>>> getAlProductsUseCase();
  Future<Either<Failure, void>> addNewProductUSeCase(ProductModel newProduct);
  Future<Either<Failure, void>> deleteProductUSeCase(String productId);


}