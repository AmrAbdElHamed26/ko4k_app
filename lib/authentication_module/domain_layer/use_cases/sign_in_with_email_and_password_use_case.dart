import 'package:dartz/dartz.dart';
import 'package:ko4k/authentication_module/domain_layer/entities/user_entity.dart';
import 'package:ko4k/authentication_module/domain_layer/repository/base_authentication_repository.dart';
import 'package:ko4k/core/utils/enums.dart';

import '../../../core/error/failure.dart';


class SignInWithEmailAndPasswordUseCase{
  BaseAuthenticationRepository baseUserRepository ;
  SignInWithEmailAndPasswordUseCase(this.baseUserRepository) ;

  Future<Either<Failure , UserRoles>> execute(String email , String password) async {
    return await baseUserRepository.signInWithEmailAndPasswordUseCase(email , password) ;
  }

}