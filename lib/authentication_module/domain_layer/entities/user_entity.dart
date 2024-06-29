import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String email, docId, role, password;

  const UserEntity(
      {required this.email,
      required this.docId,
      required this.role,
      required this.password});

  @override
  List<Object?> get props => [
        email,
        docId,
        role,
        password,
      ];
}
