import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        emailError: _validateEmail(value),
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        passwordError: _validatePassword(value),
      ),
    );
  }

  void submit() {
    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);

    emit(
      state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
      ),
    );
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return 'Please enter your email';
    if (!value.contains('@')) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
