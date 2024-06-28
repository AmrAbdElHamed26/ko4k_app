import 'package:get_it/get_it.dart';
import 'package:ko4k/authentication_module/domain_layer/use_cases/sign_in_with_email_and_password_use_case.dart';
import '../../authentication_module/data_layer/data_source/authentication_remote_data_source.dart';
import '../../authentication_module/data_layer/repository/authentication_repository.dart';
import '../../authentication_module/domain_layer/repository/base_authentication_repository.dart';
import '../../authentication_module/presentation_layer/controller/authentication_bloc.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  void init() {
    _registerBlocs();
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
  }

  void _registerBlocs() {
     getIt.registerFactory(() => AuthenticationBloc(getIt()));
  }

  void _registerDataSources() {
     getIt.registerLazySingleton<BaseAuthenticationRemoteDataSource>(
          () => AuthenticationRemoteDataSource(),
    );
  }

  void _registerRepositories() {
     getIt.registerLazySingleton<BaseAuthenticationRepository>(
          () => AuthenticationRepository(getIt()),
    );
  }

  void _registerUseCases() {
     getIt.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
          () => SignInWithEmailAndPasswordUseCase(getIt()),
    );
  }
}
