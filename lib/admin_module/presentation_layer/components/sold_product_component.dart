import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ko4k/admin_module/data_layer/models/product_model.dart';
import 'package:ko4k/admin_module/data_layer/models/sold_product_model.dart';
import 'package:ko4k/admin_module/presentation_layer/controller/admin_bloc.dart';

import '../../../core/components/custom_text.dart';

class SoldProductComponent extends StatelessWidget {
  const SoldProductComponent({super.key, required this.name , required this.price , required this.numberOfPieces});

  final String name ;
  final int numberOfPieces ;
  final double price ;

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

            SizedBox(width: screenWidth*.03.sp,),
            customText("ج  ", fontWeight: FontWeight.bold),
            Expanded(flex : 2 ,child: customText(price.toString())),
            SizedBox(
              width: screenWidth * .1.sp,
            ),
            customText("ق  " , fontWeight: FontWeight.bold),
            Expanded(flex : 1 , child: customText("${numberOfPieces.toString()}  ")),
            SizedBox(
              width: screenWidth * .1.sp,
            ),
            Expanded(flex : 3 ,child: customText(name)),
          ],
        ),
      ),
    );
  }
}
