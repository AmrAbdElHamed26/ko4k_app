part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final RequestState signInWithEmailAndPasswordState;
  final String signInWithEmailAndPasswordMessage;

  const AuthenticationState({
    this.signInWithEmailAndPasswordState = RequestState.initial,
    this.signInWithEmailAndPasswordMessage = '',
  });

  AuthenticationState copyWith({
    RequestState? signInWithEmailAndPasswordState,
    String? signInWithEmailAndPasswordMessage,
  }) {
    return AuthenticationState(
      signInWithEmailAndPasswordState: signInWithEmailAndPasswordState ?? this.signInWithEmailAndPasswordState,
      signInWithEmailAndPasswordMessage: signInWithEmailAndPasswordMessage ?? this.signInWithEmailAndPasswordMessage,
    );
  }

  @override
  List<Object?> get props => [
    signInWithEmailAndPasswordState,
    signInWithEmailAndPasswordMessage,
  ];
}
