import 'package:dartz/dartz.dart';
import 'package:ko4k/admin_module/data_layer/models/product_model.dart';
import 'package:ko4k/admin_module/domain_layer/repository/base_admin_repository.dart';

import '../../../core/error/failure.dart';
import '../../data_layer/models/sold_product_model.dart';


class GetDailyReportUseCase{
  BaseAdminRepository baseUserRepository ;
  GetDailyReportUseCase(this.baseUserRepository) ;

  Future<Either<Failure , List<SoldProductModel>>> execute(String currentDay) async {
    return await baseUserRepository.getDailyReportUseCase(currentDay) ;
  }

}