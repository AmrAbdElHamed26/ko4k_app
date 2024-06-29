import 'package:dartz/dartz.dart';
import 'package:ko4k/admin_module/data_layer/models/product_model.dart';
import 'package:ko4k/admin_module/domain_layer/repository/base_admin_repository.dart';

import '../../../core/error/failure.dart';


class GetAllProductsUseCase{
  BaseAdminRepository baseUserRepository ;
  GetAllProductsUseCase(this.baseUserRepository) ;

  Future<Either<Failure , List<ProductModel>>> execute() async {
    return await baseUserRepository.getAlProductsUseCase() ;
  }

}