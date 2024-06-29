import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ko4k/admin_module/data_layer/models/product_model.dart';
import 'package:ko4k/core/constants/api_constants.dart';
import 'package:ko4k/core/utils/enums.dart';
import '../../../core/components/custom_toast.dart';
import '../../../core/services/cloud_fire_store_services.dart';

abstract class BaseAdminRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<void>addNewProduct(ProductModel newProduct);
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

      ProductModel productModel = ProductModel(name: newProduct.name, docId: docRef.id, numberOfPieces: newProduct.numberOfPieces, price: newProduct.price);

      await docRef.set(productModel.toJson());
      showSuccessToast("تم اضافه المنتج بنجاح");
    } catch (e) {
      showErrorToast("خطا في الاضافه: $e");
    }
  }
}
