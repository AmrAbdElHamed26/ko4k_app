import 'package:ko4k/core/constants/api_constants.dart';

import '../../domain_layer/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.email,
    required super.docId,
    required super.role,
    required super.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json[RemoteAuthenticationDataConstants.kUserEmail],
      docId: json['docId'],
      role: json[RemoteAuthenticationDataConstants.kUserRole],
      password: json[RemoteAuthenticationDataConstants.kUserPassword],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      RemoteAuthenticationDataConstants.kUserEmail: email,
      RemoteAuthenticationDataConstants.kUserRole: role,
      RemoteAuthenticationDataConstants.kUserPassword: password,
      'docId': docId,
    };
  }
}
