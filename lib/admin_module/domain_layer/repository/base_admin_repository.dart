
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ko4k/admin_module/data_layer/models/product_model.dart';

import '../../../core/error/failure.dart';
import '../../data_layer/models/sold_product_model.dart';

abstract class BaseAdminRepository {

  Future<Either<Failure, List<ProductModel>>> getAlProductsUseCase();
  Future<Either<Failure, void>> addNewProductUSeCase(ProductModel newProduct);
  Future<Either<Failure, void>> deleteProductUSeCase(String productId);
  Future<Either<Failure, Timestamp>> getDateFromFirebaseUseCase();

  Future<Either<Failure, List<SoldProductModel>>> getDailyReportUseCase(String currentDay);


}