import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ko4k/authentication_module/domain_layer/use_cases/sign_in_with_email_and_password_use_case.dart';

import '../../../core/utils/enums.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase ;
  AuthenticationBloc(this.signInWithEmailAndPasswordUseCase) : super(const AuthenticationState()) {
    on<SignInWithEmailAndPasswordEvent>(_signInWithEmailAndPasswordEvent);
  }


  void _signInWithEmailAndPasswordEvent(SignInWithEmailAndPasswordEvent event,
      Emitter<AuthenticationState> emit,) async {

    emit(state.copyWith(
      signInWithEmailAndPasswordState: RequestState.loading,
    ));
    final result = await signInWithEmailAndPasswordUseCase.execute(event.email , event.password);
    result.fold(
            (failure) {
          emit(state.copyWith(
            signInWithEmailAndPasswordState: RequestState.error,
            signInWithEmailAndPasswordMessage: failure.message,
          ));
        },
    (r)
    {

    });


  }

}
