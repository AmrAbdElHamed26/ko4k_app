import 'package:dartz/dartz.dart';
import 'package:ko4k/core/utils/enums.dart';

import '../../../core/error/failure.dart';

abstract class BaseAuthenticationRepository {

  Future<Either<Failure, UserRoles>> signInWithEmailAndPasswordUseCase(String email , String password);
}