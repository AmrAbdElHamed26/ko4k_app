
import 'package:dartz/dartz.dart';

import 'package:ko4k/admin_module/data_layer/models/product_model.dart';

import 'package:ko4k/core/error/failure.dart';

import '../../domain_layer/repository/base_admin_repository.dart';
import '../data_source/admin_remote_data_source.dart';

class AdminRepository extends BaseAdminRepository  {

  final BaseAdminRemoteDataSource _baseAdminRemoteDataSource ;

  AdminRepository(this._baseAdminRemoteDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> getAlProductsUseCase()async {
    try {
      var result = await _baseAdminRemoteDataSource.getAllProducts( );
      return Right(result);
    } catch (e) {
      return  Left(ServerFailure((e as Failure).message));
    }

  }

  @override
  Future<Either<Failure, void>> addNewProductUSeCase(ProductModel newProduct) async{
    try {
      var result = await _baseAdminRemoteDataSource.addNewProduct( newProduct);
      return Right(result);
    } catch (e) {
      return  Left(ServerFailure((e as Failure).message));
    }
  }


}
