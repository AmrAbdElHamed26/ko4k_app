import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ko4k/admin_module/presentation_layer/controller/admin_bloc.dart';
import 'package:ko4k/admin_module/presentation_layer/screens/add_new_product.dart';
import 'package:ko4k/core/components/custom_text.dart';
import 'package:ko4k/core/constants/local_data_base_constances.dart';
import 'package:ko4k/core/services/service_locator.dart';
import 'package:ko4k/core/services/time_stamp_services.dart';
import 'package:ko4k/core/utils/enums.dart';
import 'package:ko4k/main.dart';

import '../components/product_component.dart';
import '../components/sold_product_component.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({super.key});

  String currentData = "جاري تحميل التاريخ";

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1152FD),
        leading: IconButton(
          icon: const Icon(
            Icons.view_headline_sharp,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.login, color: Colors.white)),
        ],
      ),
      body: BlocProvider(
        create: (context) => getIt<AdminBloc>()
          ..add(GetAllProductsEvent())
          ..add(const GetTimeFromFirebaseEvent()),
        child: SizedBox(
          width: double.infinity,
          child: BlocListener<AdminBloc, AdminState>(
            listener: (context, state) {
              if (state.currentTimeState == RequestState.loaded) {
                currentData = TimeStampServices().convertTimeStampToDate(
                    TimeStampServices().convertStringToTimestamp(preferences
                        .get(LocalDataBaseConstants.kCurrentTime)
                        .toString()));

                if(state.allSoldProductsState == RequestState.initial) {
                  BlocProvider.of<AdminBloc>(context).add(
                    GetSoldProductsForSpecificDayEvent(
                        currentDay: currentData));
                }


              }
            },
            child: BlocBuilder<AdminBloc, AdminState>(

              builder: (context, state) {

                return Padding(
                  padding: EdgeInsets.all(8.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddNewProduct(
                                      adminBloc: getIt<AdminBloc>()),
                                ),
                              );
                            },
                            child: customText(
                              "اضافة منتج",
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * .06.sp,
                          ),
                          customText("المنتجات",
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * .04.sp),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * .25.sp,
                        child: state.allProductsState == RequestState.loaded
                            ? ListView.builder(
                                itemCount: state.allProducts.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.sp),
                                    child: ProductComponent(
                                      currentProduct: state.allProducts[index],
                                    ),
                                  );
                                })
                            : const Center(child: CircularProgressIndicator()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          customText(currentData),
                          SizedBox(
                            width: screenWidth * .02.sp,
                          ),
                          customText("التقرير اليومي",
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * .04.sp),
                        ],
                      ),

                      /// daily report
                      ///
                      state.allSoldProductsState == RequestState.loaded
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: screenHeight * .15.sp,
                                child: ListView.builder(
                                itemCount: state.allDifferentSoldItems.length,
                                itemBuilder: (context, index) {

                                  String name  = state.allDifferentSoldItems[index];
                                  int numberOfSoldItems = state.soldItemCount[name] ??0;
                                  double totalPrice = state.soldItemTotalPrice[name] ?? 0 ;


                                  return Padding(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 8.sp),
                                    child: SoldProductComponent(name: name, price: totalPrice, numberOfPieces: numberOfSoldItems,)
                                  );
                                }),
                              ),
                              Padding(
                                padding:   EdgeInsets.only(left: screenWidth * .07.sp),
                                child: customText(state.totalSoldItemsPrice.toString() , fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                          : const Center(child: CircularProgressIndicator()),

                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
