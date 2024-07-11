import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ko4k/admin_module/data_layer/models/product_model.dart';
import 'package:ko4k/admin_module/data_layer/models/sold_product_model.dart';
import 'package:ko4k/core/constants/api_constants.dart';
import 'package:ko4k/core/utils/enums.dart';
import '../../../core/components/custom_toast.dart';
import '../../../core/services/cloud_fire_store_services.dart';

abstract class BaseAdminRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();

  Future<List<SoldProductModel>> getSoldProducts(String currentDay);

  Future<void> addNewProduct(ProductModel newProduct);

  Future<void> deleteProduct(String productId);

  Future<Timestamp> getTimeFromFirebase();
}

class AdminRemoteDataSource extends BaseAdminRemoteDataSource {
  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      QuerySnapshot querySnapshot = await CloudFireStoreServices
          .cloudFireBaseCollections
          .collection('products')
          .get();

      List<ProductModel> products = querySnapshot.docs.map((doc) {
        return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return products;
    } catch (e) {
      showErrorToast('Failed to fetch products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<void> addNewProduct(ProductModel newProduct) async {
    try {
      DocumentReference docRef = CloudFireStoreServices.cloudFireBaseCollections
          .collection('products')
          .doc();

      ProductModel productModel = ProductModel(
          name: newProduct.name,
          docId: docRef.id,
          numberOfPieces: newProduct.numberOfPieces,
          price: newProduct.price, sellingPrice: newProduct.sellingPrice);

      await docRef.set(productModel.toJson());
      showSuccessToast("تم اضافه المنتج بنجاح");
    } catch (e) {
      showErrorToast("خطا في الاضافه: $e");
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      CloudFireStoreServices cloudFireStoreServices = CloudFireStoreServices();
      cloudFireStoreServices.deleteSpecificDocFromCollection(
          CloudFireStoreServices.cloudFireBaseCollections
              .collection(RemoteProductsDataConstants.kProductsCollection),
          productId);
      showSuccessToast("تم الحذف بنجاح");
    } catch (e) {
      showErrorToast("خطا في الحذف: $e");
    }
  }

  @override
  Future<Timestamp> getTimeFromFirebase() async {
    try {
      DocumentReference docRef = CloudFireStoreServices.cloudFireBaseCollections
          .collection('serverTime')
          .doc();

      await docRef.set({
        'timestamp': FieldValue.serverTimestamp(),
      });

      DocumentSnapshot snapshot = await docRef.get();
      Timestamp serverTime = snapshot['timestamp'];

      await docRef.delete();

      return serverTime;
    } catch (e) {
      print('Error getting server time: $e');
      throw e;
    }
  }

  @override
  Future<List<SoldProductModel>> getSoldProducts(String currentDay) async {
    try {
      CollectionReference soldProductsCollection = CloudFireStoreServices
          .cloudFireBaseCollections
          .collection(RemoteDailyReportDataConstants.kDailyReportCollection)
          .doc(currentDay)
          .collection('items');
      QuerySnapshot querySnapshot = await soldProductsCollection.get();

      List<SoldProductModel> soldProductsList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return SoldProductModel.fromJson(data);
      }).toList();

      return soldProductsList;
    } catch (e) {
      print('Error getting sold products: $e');
      throw e;
    }
  }
}
