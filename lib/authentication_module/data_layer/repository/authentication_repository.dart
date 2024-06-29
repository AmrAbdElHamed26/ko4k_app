import 'package:dartz/dartz.dart';

import 'package:ko4k/core/error/failure.dart';

import '../../../core/utils/enums.dart';
import '../../domain_layer/repository/base_authentication_repository.dart';
import '../data_source/authentication_remote_data_source.dart';

class AuthenticationRepository extends BaseAuthenticationRepository {

  final BaseAuthenticationRemoteDataSource _baseAuthenticationRemoteDataSource;

  AuthenticationRepository(this._baseAuthenticationRemoteDataSource);

  @override
  Future<Either<Failure, UserRoles>> signInWithEmailAndPasswordUseCase(String email, String password) async {
    try {
      var result = await _baseAuthenticationRemoteDataSource.signInWithEmailAndPassword(email, password);
      return Right(result);
    } catch (e) {
      return  Left(ServerFailure((e as Failure).message));
    }


  }

}
