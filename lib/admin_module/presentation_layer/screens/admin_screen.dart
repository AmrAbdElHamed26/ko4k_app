import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'add_new_data_to_store.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({super.key});

  String currentData = "جاري تحميل التاريخ";

  Future<String> getCurrentMonthDocId() async {
    DocumentReference timestampRef = FirebaseFirestore.instance
        .collection('metadata')
        .doc('serverTimestamp');

    // Update the document with server timestamp
    await timestampRef.set({'timestamp': FieldValue.serverTimestamp()});

    // Get the updated document
    DocumentSnapshot timestampDoc = await timestampRef.get();
    Timestamp serverTimestamp = timestampDoc['timestamp'];
    DateTime currentDateTime = serverTimestamp.toDate();

    // Format the current month document ID
    return '${currentDateTime.year}-${currentDateTime.month}';
  }


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
      body: SingleChildScrollView(
        child: BlocProvider(
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
        
                  if (state.allSoldProductsState == RequestState.initial) {
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
                        SizedBox(
                          height: screenHeight * .15.h,
                          child: state.allSoldProductsState == RequestState.loaded
                              ? state.allDifferentSoldItems.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: screenHeight * .13.sp,
                                          child: ListView.builder(
                                              itemCount: state
                                                  .allDifferentSoldItems.length,
                                              itemBuilder: (context, index) {
                                                String name = state
                                                    .allDifferentSoldItems[index];
                                                int numberOfSoldItems =
                                                    state.soldItemCount[name] ??
                                                        0;
                                                double totalPrice =
                                                    state.soldItemTotalPrice[
                                                            name] ??
                                                        0;
        
                                                return Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 8.sp),
                                                    child: SoldProductComponent(
                                                      name: name,
                                                      price: totalPrice,
                                                      numberOfPieces:
                                                          numberOfSoldItems,
                                                    ));
                                              }),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: screenWidth * .07.sp),
                                          child: customText(
                                              state.totalSoldItemsPrice
                                                  .toString(),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  : const Center(child: Text("لا يوجد مبيعات "))
                              : const Center(child: CircularProgressIndicator()),
                        ),
        
                        /// store
                        ///
                        ///
        
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
                                    builder: (context) => AddNewDataToStore(
                                        allProducts: state.allProducts,
                                        adminBloc: getIt<AdminBloc>()),
                                  ),
                                );
                              },
                              child: customText("اضافة منتج للمخزن"),
                            ),
                            SizedBox(
                              width: screenWidth * .06.sp,
                            ),
                            customText("المخزن",
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * .04.sp),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(flex: 1, child: customText("المتبقي")),
                            Expanded(flex: 1, child: customText(" سعر البيع ")),
                            Expanded(flex: 1, child: customText("الاسم ")),
                          ],
                        ),
        
                        /// StreamBuilder for store collection
                        SizedBox(
                          height: screenHeight * .12.h,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('store')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text('خطا في التحميل '));
                              }
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text('لا يوجد داتا في المخزن'));
                              }
        
                              final storeItems = snapshot.data!.docs;
        
                              return ListView.builder(
                                shrinkWrap: true,
                                // Ensure it fits within the Column
                                itemCount: storeItems.length,
                                itemBuilder: (context, index) {
                                  final item = storeItems[index];
        
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF1152FD)
                                            .withOpacity(.2),
                                        borderRadius:
                                            BorderRadius.circular(12.sp)),
                                    width: double.infinity,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30.sp),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: customText(
                                                  "${item['numberOfItems'].toString()}  ")),
                                          Expanded(
                                              flex: 1,
                                              child: customText(
                                                  "${item['sellingPrice'].toString()}  ")),
                                          Expanded(
                                              flex: 1,
                                              child: customText(
                                                  "${item['name']}  ")),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
        
                        /// montly report

                        FutureBuilder<String>(
                          future: getCurrentMonthDocId(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(child: Text('Something went wrong'));
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Text('No data available'));
                            }

                            String currentMonthDoc = snapshot.data!;

                            return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('monthlyReport')
                                  .doc(currentMonthDoc)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return const Center(child: Text('Something went wrong'));
                                }
                                if (!snapshot.hasData || !snapshot.data!.exists) {
                                  return const Center(child: Text('No data available'));
                                }

                                final data = snapshot.data!.data() as Map<String, dynamic>;
                                final double totalPrice =
                                    (data['totalPrice'] as num).toDouble() ?? 0.0;
                                final double totalSellingPrice =
                                    (data['totalSellingPrice'] as num).toDouble() ?? 0.0;
                                final double netProfit = totalSellingPrice - totalPrice;

                                return GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              customText("التقرير الشهري",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * .04.sp),
                                              SizedBox(height: 8.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  customText("صافي الربح"),
                                                  customText(netProfit.toString()),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  customText("مبيعات"),
                                                  customText(totalSellingPrice.toString()),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  customText("مشتريات"),
                                                  customText(totalPrice.toString()),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      customText("التقرير الشهري",
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * .04.sp),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Expanded(flex: 1, child: customText("صافي الربح")),
                                          Expanded(flex: 1, child: customText("مبيعات")),
                                          Expanded(flex: 1, child: customText("مشتريات")),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Expanded(flex: 1, child: customText(netProfit.toString())),
                                          Expanded(
                                              flex: 1,
                                              child: customText(totalSellingPrice.toString())),
                                          Expanded(flex: 1, child: customText(totalPrice.toString())),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
