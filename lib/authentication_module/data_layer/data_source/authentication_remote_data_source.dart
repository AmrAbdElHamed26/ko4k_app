import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ko4k/core/constants/api_constants.dart';
import 'package:ko4k/core/utils/enums.dart';
import '../../../core/components/custom_toast.dart';
import '../../../core/services/cloud_fire_store_services.dart';

abstract class BaseAuthenticationRemoteDataSource {
  Future<UserRoles> signInWithEmailAndPassword(String email, String password);
}

class AuthenticationRemoteDataSource
    extends BaseAuthenticationRemoteDataSource {
  @override
  Future<UserRoles> signInWithEmailAndPassword(
      String email, String password) async {
    CloudFireStoreServices cloudFireStoreServices = CloudFireStoreServices();

    FirebaseFirestore _firebaseFirestore =
        CloudFireStoreServices.cloudFireBaseCollections;

    String? adminDocId =
        await cloudFireStoreServices.getDocumentIdIfFieldExists(
            _firebaseFirestore
                .collection(RemoteAuthenticationDataConstants.kAdminCollection),
            RemoteAuthenticationDataConstants.kUserEmail,
            email);
    if (adminDocId != null) {
      String storedPassword =
          await cloudFireStoreServices.getFieldDataFromDocument(
              _firebaseFirestore
                  .collection(
                      RemoteAuthenticationDataConstants.kAdminCollection)
                  .doc(adminDocId),
              RemoteAuthenticationDataConstants.kUserPassword);

      if (storedPassword == password) {
        return UserRoles.admin;
      } else {
        showErrorToast('خطأ في تسجيل الدخول');
      }
    } else {
      /// search in user collection
      String? userDocId =
          await cloudFireStoreServices.getDocumentIdIfFieldExists(
              _firebaseFirestore.collection(
                  RemoteAuthenticationDataConstants.kUserCollection),
              RemoteAuthenticationDataConstants.kUserEmail,
              email);

      if (userDocId != null) {
        String storedPassword =
            await cloudFireStoreServices.getFieldDataFromDocument(
                _firebaseFirestore
                    .collection(
                        RemoteAuthenticationDataConstants.kUserCollection)
                    .doc(userDocId),
                RemoteAuthenticationDataConstants.kUserPassword);

        if (storedPassword == password) {
          String currentRoleForUser =
              await cloudFireStoreServices.getFieldDataFromDocument(
                  _firebaseFirestore
                      .collection(
                          RemoteAuthenticationDataConstants.kUserCollection)
                      .doc(userDocId),
                  RemoteAuthenticationDataConstants.kUserRole);

          if(currentRoleForUser == RemoteAuthenticationDataConstants.kKo4kRole){
            return UserRoles.ko4k;
          }
          else {
            return UserRoles.hesabat ;
          }
        }
        else {
          showErrorToast('قم بالتأكد من الباسورد');

        }
      } else {
        showErrorToast('قم بالتأكد من البريد الاكتروني');
      }
    }

    return UserRoles.none;
  }
}
