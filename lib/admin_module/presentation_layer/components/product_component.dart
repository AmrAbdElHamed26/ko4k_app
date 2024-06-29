import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ko4k/admin_module/data_layer/models/product_model.dart';

import '../../../core/components/custom_text.dart';

class ProductComponent extends StatelessWidget {
  const ProductComponent({super.key, required this.currentProduct});

  final ProductModel currentProduct;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * .05.sp,
      decoration: BoxDecoration(
          color: const Color(0xFF1152FD).withOpacity(.2),
          borderRadius: BorderRadius.circular(12.sp)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            TextButton(onPressed: (){}, child: const Icon(Icons.delete_forever_sharp , color: Colors.red,) , ),
            SizedBox(width: screenWidth*.03.sp,),
            customText("جنيه  "),
            customText(currentProduct.price.toString()),
            SizedBox(
              width: screenWidth * .1.sp,
            ),
            customText("قطعة  "),
            customText("${currentProduct.numberOfPieces.toString()}  "),
            SizedBox(
              width: screenWidth * .1.sp,
            ),
            customText(currentProduct.name),
          ],
        ),
      ),
    );
  }
}
