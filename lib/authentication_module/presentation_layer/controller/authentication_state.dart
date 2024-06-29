part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final UserRoles currentUserRole ;
  final RequestState signInWithEmailAndPasswordState;
  final String signInWithEmailAndPasswordMessage;

  const AuthenticationState({
    this.currentUserRole  = UserRoles.none ,
    this.signInWithEmailAndPasswordState = RequestState.initial,
    this.signInWithEmailAndPasswordMessage = '',
  });

  AuthenticationState copyWith({
    UserRoles ? currentUserRole ,
    RequestState? signInWithEmailAndPasswordState,
    String? signInWithEmailAndPasswordMessage,
  }) {
    return AuthenticationState(
      currentUserRole : currentUserRole ?? this.currentUserRole ,
      signInWithEmailAndPasswordState: signInWithEmailAndPasswordState ?? this.signInWithEmailAndPasswordState,
      signInWithEmailAndPasswordMessage: signInWithEmailAndPasswordMessage ?? this.signInWithEmailAndPasswordMessage,
    );
  }

  @override
  List<Object?> get props => [
    signInWithEmailAndPasswordState,
    signInWithEmailAndPasswordMessage,
    currentUserRole,
  ];
}
