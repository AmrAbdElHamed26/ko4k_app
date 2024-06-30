import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ko4k/admin_module/data_layer/models/product_model.dart';
import 'package:ko4k/admin_module/domain_layer/repository/base_admin_repository.dart';

import '../../../core/error/failure.dart';


class GetDateFromFirebaseUseCase{
  BaseAdminRepository baseUserRepository ;
  GetDateFromFirebaseUseCase(this.baseUserRepository) ;

  Future<Either<Failure , Timestamp>> execute() async {
    return await baseUserRepository.getDateFromFirebaseUseCase() ;
  }

}