import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ko4k/core/components/custom_toast.dart';

abstract class BaseCloudFireStoreServices {
  Future<void> addDocToSpecificCollection(var collection, var document);

  Future<String?> getDocumentIdIfFieldExists(var collection, var field, var value);

  Future<dynamic> getFieldDataFromDocument(var doc, var field);
  
  Future<void> deleteSpecificDocFromCollection(var collection , String docId);
}

class CloudFireStoreServices extends BaseCloudFireStoreServices {
  static final CloudFireStoreServices _instance = CloudFireStoreServices._internal();
  static FirebaseFirestore cloudFireBaseCollections = FirebaseFirestore.instance;

  factory CloudFireStoreServices() {
    return _instance;
  }

  CloudFireStoreServices._internal();

  @override
  Future<void> addDocToSpecificCollection(collection, document) async {
    await collection
        .add(document)
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  @override
  Future<String?> getDocumentIdIfFieldExists(collection, field, value) async {
    try {
      var querySnapshot = await collection.where(field, isEqualTo: value).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (error) {
       return null;
    }
  }

  @override
  Future<dynamic> getFieldDataFromDocument(doc, field) async {
    try {
      var documentSnapshot = await doc.get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data()[field];
      } else {
        return null;
      }
    } catch (error) {

      return null;
    }
  }

  @override
  Future<void> deleteSpecificDocFromCollection(collection, String docId)async {
    try {
      await cloudFireBaseCollections.collection(collection).doc(docId).delete();
    } catch (e) {
      throw e;
    }
  }
}
