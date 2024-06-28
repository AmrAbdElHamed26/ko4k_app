part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

}

class SignInWithEmailAndPasswordEvent extends AuthenticationEvent {

  final String email , password;
  const SignInWithEmailAndPasswordEvent({required this.email ,required this.password});
  @override
  List<Object?> get props => [email,password];

}
