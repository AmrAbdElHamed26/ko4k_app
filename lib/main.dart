import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ko4k/admin_module/presentation_layer/controller/admin_bloc.dart';
import 'package:ko4k/admin_module/presentation_layer/screens/admin_screen.dart';
import 'package:ko4k/authentication_module/presentation_layer/controller/authentication_bloc.dart';
import 'package:ko4k/core/constants/local_data_base_constances.dart';
import 'package:ko4k/core/utils/enums.dart';
import 'core/services/service_locator.dart';
import 'firebase_options.dart';
import 'authentication_module/presentation_layer/screens/authentication_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences preferences;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ServiceLocator().init();
  preferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return   MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MultiBlocProvider(

            providers: [
              BlocProvider(create: (context) => getIt<AuthenticationBloc>(),),
            ],

            child:   getCurrentScreen(),
          ),
        );
      },
    );
  }

  Widget getCurrentScreen(){
    String currentRole = preferences.get(LocalDataBaseConstants.kCurrentRole).toString();

    if(currentRole == UserRoles.admin.toString()){
      return const AdminScreen();
    }
   /* else if(currentRole == UserRoles.ko4k.toString()){

    }*/
    else {
      return const LoginScreen();
    }
  }
}

