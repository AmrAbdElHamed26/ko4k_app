import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ko4k/admin_module/presentation_layer/controller/admin_bloc.dart';
import 'package:ko4k/core/components/custom_toast.dart';

import '../../../core/components/custom_text.dart';
import '../../data_layer/models/product_model.dart';

class AddNewDataToStore extends StatefulWidget {
  const AddNewDataToStore({super.key, required this.adminBloc, required this.allProducts});

  final List<ProductModel> allProducts;
  final AdminBloc adminBloc;

  @override
  State<AddNewDataToStore> createState() => _AddNewDataToStoreState();
}

class _AddNewDataToStoreState extends State<AddNewDataToStore> {
  List<int> newQuantity = [];

  @override
  void initState() {
    for (int i = 0; i < widget.allProducts.length; i++) {
      newQuantity.add(0);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("اضافه منتج جديد للمخزن"),
      ),
      body: ListView.builder(
        itemCount: widget.allProducts.length,
        itemBuilder: (context, index) {
          ProductModel currentProduct = widget.allProducts[index];
          void _incrementQuantity() {
            setState(() {
              newQuantity[index]++;
            });
          }

          void _decrementQuantity() {
            if (newQuantity[index] > 0) {
              setState(() {
                newQuantity[index]--;
              });
            }
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1152FD).withOpacity(.2),
                borderRadius: BorderRadius.circular(12.sp),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currentProduct.name,
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    customText("سعر الشراء: ${currentProduct.price} ج"),
                    customText("سعر البيع: ${currentProduct.sellingPrice} ج"),
                    customText("عدد القطع لكل علبه: ${currentProduct.numberOfPieces} ق"),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _decrementQuantity,
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '${newQuantity[index]}',
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        IconButton(
                          onPressed: _incrementQuantity,
                          icon: const Icon(Icons.add),
                        ),
                        TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () async {
                            String currentDocId = currentProduct.docId;
                            String name = currentProduct.name;
                            int numberOfItems = currentProduct.numberOfPieces * newQuantity[index];
                            double sellingPrice = currentProduct.sellingPrice;
                            double newPrice = currentProduct.price * newQuantity[index];

                            DocumentReference docRef = FirebaseFirestore.instance.collection('store').doc(currentDocId);

                            FirebaseFirestore.instance.runTransaction((transaction) async {
                              DocumentSnapshot docSnapshot = await transaction.get(docRef);

                              if (docSnapshot.exists) {
                                // Document exists, update the numberOfItems
                                int currentNumberOfItems = docSnapshot['numberOfItems'];
                                transaction.update(docRef, {
                                  'numberOfItems': currentNumberOfItems + numberOfItems,
                                });
                              } else {
                                // Document does not exist, create a new one
                                transaction.set(docRef, {
                                  'docId': currentDocId, // Add docId field
                                  'name': name,
                                  'numberOfItems': numberOfItems,
                                  'sellingPrice': sellingPrice,
                                });
                              }
                            }).then((_) async {
                              print("Transaction successfully completed!");

                              // Add to monthly report
                              DateTime now = DateTime.now();
                              String currentMonth = "${now.year}-${now.month}";

                              DocumentReference monthlyReportRef = FirebaseFirestore.instance.collection('monthlyReport').doc(currentMonth);

                              await FirebaseFirestore.instance.runTransaction((transaction) async {
                                DocumentSnapshot monthlyReportSnapshot = await transaction.get(monthlyReportRef);

                                if (monthlyReportSnapshot.exists) {
                                  // Document exists, update the totalPrice
                                  double currentTotalPrice = (monthlyReportSnapshot['totalPrice'] as num).toDouble();
                                  transaction.update(monthlyReportRef, {
                                    'totalPrice': currentTotalPrice + newPrice,
                                  });
                                } else {
                                  // Document does not exist, create a new one
                                  transaction.set(monthlyReportRef, {
                                    'docId': currentMonth, // Add docId field
                                    'totalPrice': newPrice,
                                    'month': currentMonth,
                                  });
                                }
                              }).then((_) {
                                newQuantity[index] = 0;
                                setState(() {});

                                showSuccessToast("تمت الاضافه بنجاح");
                              }).catchError((error) {
                                showErrorToast("خطا قم بالتكرار مجداا");
                                print("Monthly report transaction failed: $error");
                              });
                            }).catchError((error) {
                              showErrorToast("خطا قم بالتكرار مجداا");
                              print("Transaction failed: $error");
                            });
                          },

                          child: Text("اضافه"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
