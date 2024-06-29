import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ko4k/authentication_module/presentation_layer/controller/authentication_bloc.dart';
import 'package:ko4k/core/components/custom_text.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SizedBox(
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: screenHeight * .2.sp),
                customText(
                  'ادخل البريد الالكتروني ',
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * .05.sp,
                ),
                SizedBox(height: screenHeight * .01.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp),
                  child: CustomTextField(
                    hintText: 'example@gmail.com',
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * .04.sp),
                customText(
                  'ادخل كلمة المرور ',
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * .05.sp,
                ),
                SizedBox(height: screenHeight * .01.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp),
                  child: CustomTextField(
                    hintText: '******',
                    obscureText: _obscureText,
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * .04.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: CustomButton(
                    text: 'تسجيل الدخول',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                            SignInWithEmailAndPasswordEvent(
                                email: email!, password: password!));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
