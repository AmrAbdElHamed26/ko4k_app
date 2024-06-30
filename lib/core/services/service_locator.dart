import 'package:get_it/get_it.dart';
import 'package:ko4k/admin_module/domain_layer/use_cases/add_new_product_use_case.dart';
import 'package:ko4k/admin_module/domain_layer/use_cases/delete_product_use_case.dart';
import 'package:ko4k/admin_module/domain_layer/use_cases/get_all_products_use_case.dart';
import 'package:ko4k/admin_module/domain_layer/use_cases/get_date_from_firebase_use_case.dart';
import 'package:ko4k/admin_module/presentation_layer/controller/admin_bloc.dart';
import 'package:ko4k/authentication_module/domain_layer/use_cases/sign_in_with_email_and_password_use_case.dart';
import '../../admin_module/data_layer/data_source/admin_remote_data_source.dart';
import '../../admin_module/data_layer/repository/admin_repository.dart';
import '../../admin_module/domain_layer/repository/base_admin_repository.dart';
import '../../admin_module/domain_layer/use_cases/get_daily_report_use_case.dart';
import '../../authentication_module/data_layer/data_source/authentication_remote_data_source.dart';

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
     getIt.registerLazySingleton(() => AdminBloc(getIt() , getIt() , getIt() , getIt(), getIt()));

  }

  void _registerDataSources() {
     getIt.registerLazySingleton<BaseAuthenticationRemoteDataSource>(
          () => AuthenticationRemoteDataSource(),
    );

     getIt.registerLazySingleton<BaseAdminRemoteDataSource>(
           () => AdminRemoteDataSource(),
     );
  }

  void _registerRepositories() {
     getIt.registerLazySingleton<BaseAdminRepository>(
          () => AdminRepository(getIt()),
    );
  }

  void _registerUseCases() {
     getIt.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
          () => SignInWithEmailAndPasswordUseCase(getIt()),
    );


     getIt.registerLazySingleton<GetAllProductsUseCase>(
           () => GetAllProductsUseCase(getIt()),
     );
     getIt.registerLazySingleton<AddNewProductUseCase>(
           () => AddNewProductUseCase(getIt()),
     );
     getIt.registerLazySingleton<DeleteProductUseCase>(
           () => DeleteProductUseCase(getIt()),
     );
     getIt.registerLazySingleton<GetDateFromFirebaseUseCase>(
           () => GetDateFromFirebaseUseCase(getIt()),
     );

     getIt.registerLazySingleton<GetDailyReportUseCase>(
           () => GetDailyReportUseCase(getIt()),
     );
  }
}
