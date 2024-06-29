import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ko4k/admin_module/presentation_layer/screens/admin_screen.dart';
import 'package:ko4k/authentication_module/presentation_layer/controller/authentication_bloc.dart';
import 'package:ko4k/core/components/custom_text.dart';
import 'package:ko4k/core/utils/enums.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state.currentUserRole == UserRoles.admin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminScreen()),
            );
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state.signInWithEmailAndPasswordState ==
                      RequestState.loading) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.white,
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
                              controller: _emailController,
                              hintText: 'example@gmail.com',
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
                              controller: _passwordController,
                              hintText: '******',
                              obscureText: _obscureText,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال كلمة المرور';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(SignInWithEmailAndPasswordEvent(
                                      email: _emailController.text,
                                      password: _passwordController.text));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
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
                            controller: _emailController,
                            hintText: 'example@gmail.com',
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
                            controller: _passwordController,
                            hintText: '******',
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال كلمة المرور';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
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
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(SignInWithEmailAndPasswordEvent(
                                    email: _emailController.text,
                                    password: _passwordController.text));
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
