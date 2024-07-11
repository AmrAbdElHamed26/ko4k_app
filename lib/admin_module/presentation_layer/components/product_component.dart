import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ko4k/admin_module/data_layer/models/product_model.dart';
import 'package:ko4k/admin_module/presentation_layer/controller/admin_bloc.dart';

import '../../../core/components/custom_text.dart';

class ProductComponent extends StatelessWidget {
  const ProductComponent({super.key, required this.currentProduct});

  final ProductModel currentProduct;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    void _showProductDetails() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${currentProduct.name}  ${currentProduct.numberOfPieces} قطعه",
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  customText("سعر شراء المنتج: ${currentProduct.price} ج"),
                  customText("سعر بيع القطعه: ${currentProduct.sellingPrice} ج"),
                ],
              ),
            ),
          );
        },
      );
    }

    return GestureDetector(
      onTap: _showProductDetails,
      child: Container(
        height: screenHeight * .05.sp,
        decoration: BoxDecoration(
            color: const Color(0xFF1152FD).withOpacity(.2),
            borderRadius: BorderRadius.circular(12.sp)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  BlocProvider.of<AdminBloc>(context).add(DeleteProductEvent(productId: currentProduct.docId));
                },
                child: const Icon(Icons.delete_forever_sharp, color: Colors.red),
              ),
              SizedBox(width: screenWidth * .03.sp),
              customText("ج  ", fontWeight: FontWeight.bold),
              Expanded(flex: 2, child: customText(currentProduct.price.toString())),
              SizedBox(width: screenWidth * .1.sp),
              customText("ج  ", fontWeight: FontWeight.bold),
              Expanded(flex: 1, child: customText("${currentProduct.sellingPrice.toString()}  ")),
              SizedBox(width: screenWidth * .1.sp),
              Expanded(flex: 4, child: customText("${currentProduct.name}  ${currentProduct.numberOfPieces} ق ")),
            ],
          ),
        ),
      ),
    );
  }
}
