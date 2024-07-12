import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../authentication_module/presentation_layer/screens/authentication_screen.dart';
import '../core/components/custom_text.dart';
import '../core/components/custom_toast.dart';
import '../core/constants/local_data_base_constances.dart';
import '../main.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  bool loading = false ;

  Future<void> addItemToCollection(String docId, Map<String, dynamic> data) async {
    final collectionRef = FirebaseFirestore.instance.collection("dailyReport").doc(docId).collection("items");

    try {
      // Add the new document to the subcollection
      await collectionRef.add(data);
      print('Document successfully added!');
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  Future<void> decrementItem(String docId, Map<String, dynamic> item) async {
    loading = true ;

    final currentDate = DateTime.now();
    final currentMonth = "${currentDate.year}-${currentDate.month}";
    final currentDay = "${currentDate.day}-${currentDate.month}-${currentDate.year}";

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.runTransaction((transaction) async {
        // Get item snapshot first
        DocumentReference itemRef = firestore.collection('store').doc(docId);
        DocumentSnapshot itemSnapshot = await transaction.get(itemRef);

        // Check if item exists and quantity is positive
        if (itemSnapshot.exists && itemSnapshot['numberOfItems'] > 0) {
          // Decrement item quantity in the store
          int newQuantity = itemSnapshot['numberOfItems'] - 1;

          // Ensure monthlyReport exists and initialize if not
          DocumentReference monthlyReportRef = firestore.collection('monthlyReport').doc(currentMonth);
          DocumentSnapshot monthlyReportSnapshot = await transaction.get(monthlyReportRef);
          if (!monthlyReportSnapshot.exists) {
            transaction.set(monthlyReportRef, {
              'totalPrice': 0,
              'totalSellingPrice': 0,
            });
          }


          // Update totalSellingPrice in monthlyReport
          double currentTotalSellingPrice = 0;
          if (monthlyReportSnapshot.exists && monthlyReportSnapshot.data() != null) {
            currentTotalSellingPrice = ((monthlyReportSnapshot.data() as Map<String,dynamic>)!['totalSellingPrice'] ?? 0).toDouble();
          }
          double itemSellingPrice = item['sellingPrice'].toDouble();
          double newTotalSellingPrice = currentTotalSellingPrice + itemSellingPrice;

          // Add or update the daily report
          addItemToCollection( currentDay , {
            'docId': docId,
            'price': item['sellingPrice'],
            'productName': item['name'],
          });



          transaction.update(monthlyReportRef, {'totalSellingPrice': newTotalSellingPrice});
          transaction.update(itemRef, {'numberOfItems': newQuantity});

        }

      });
      loading = false;

    } catch (error, stackTrace) {
      loading = false;
      print("Failed to decrement item: $error");
      print("Stack trace: $stackTrace");
      // Optionally re-throw the error or handle it as needed
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Items'),
        actions: [
          IconButton(
              onPressed: () {
                preferences.remove(LocalDataBaseConstants.kCurrentRole);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
              },
              icon: const Icon(Icons.login, color: Colors.black)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('store').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items found'));
          }

          final storeItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: storeItems.length,
            itemBuilder: (context, index) {
              final item = storeItems[index].data() as Map<String, dynamic>;
              final docId = storeItems[index].id;

              return Visibility(
                visible: item['numberOfItems'] > 0,
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item['name'],
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      customText("سعر البيع: ${item['sellingPrice']} ج"),
                      customText(
                          "عدد القطع المتبقيه: ${item['numberOfItems']} ق"),
                      Row(
                        children: [
                          IconButton(

                            onPressed: () {
                              if(loading == false){
                                decrementItem(docId, item);
                              }
                            },

                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            '${item['numberOfItems']}',
                            style: TextStyle(fontSize: 20.sp),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
