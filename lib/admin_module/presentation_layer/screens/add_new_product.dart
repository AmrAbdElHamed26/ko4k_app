import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ko4k/admin_module/presentation_layer/controller/admin_bloc.dart';
import 'package:ko4k/core/components/custom_button.dart';
import 'package:ko4k/core/components/custom_text_field.dart';
import 'package:ko4k/core/services/service_locator.dart';
import 'package:ko4k/core/utils/enums.dart';
import '../../../core/components/custom_text.dart';
import '../../data_layer/models/product_model.dart';

class AddNewProduct extends StatelessWidget {
  AddNewProduct({super.key, required this.adminBloc});

  final AdminBloc adminBloc;


  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController numberOfPiecesController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      body: BlocProvider.value(
          value: adminBloc,
        child: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: screenHeight * .1.sp),
                      customText("اسم المنتج"),
                      SizedBox(height: screenHeight * .01.sp),
                      CustomTextField(
                        hintText: 'بسكويت',
                        controller: nameController,
                        validator: _validateField,
                      ),
                      SizedBox(height: screenHeight * .01.sp),
                      customText("سعر المنتج"),
                      SizedBox(height: screenHeight * .01.sp),
                      CustomTextField(
                        textInputType: TextInputType.number,
                        hintText: '20 جنيه',
                        controller: priceController,
                        validator: _validateField,
                      ),
                      SizedBox(height: screenHeight * .01.sp),
                      customText("عدد قطع المنتج"),
                      SizedBox(height: screenHeight * .01.sp),
                      CustomTextField(
                        textInputType: TextInputType.number,
                        hintText: '12 قطعة',
                        controller: numberOfPiecesController,
                        validator: _validateField,
                      ),
                      SizedBox(height: screenHeight * .05.sp),

                      if(state.allProductsState == RequestState.loaded)
                      CustomButton(
                        text: "اضافه منتج جديد",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {


                            final ProductModel newProduct = ProductModel(
                                name: nameController.text,
                                docId: "",
                                numberOfPieces: int.parse(
                                    numberOfPiecesController
                                        .text),
                                price: double.parse(priceController.text));

                            BlocProvider.of<AdminBloc>(context).add(
                                AddNewProductEvent(newProduct: newProduct));
                          }
                        },
                      ),
                      if(state.allProductsState == RequestState.loading)
                        CustomButton(

                          text: "جاري التحميل",
                          onPressed: () {

                          },
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
